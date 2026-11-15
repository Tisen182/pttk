package dao;

import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Savepoint;
import java.sql.Statement;
import java.util.Arrays;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import model.Address4;
import model.Customer4;

public class CustomerDAO extends DAO {
    private static final int PASSWORD_ITERATIONS = 120_000;
    private static final int PASSWORD_BITS = 256;
    private static final int SALT_BYTES = 16;

    public CustomerDAO(java.sql.Connection con) {
        super(con);
    }

    public Customer4[] getCustomerById(int id) throws SQLException {
        if (id <= 0) {
            throw new IllegalArgumentException("Customer id must be greater than zero.");
        }
        String sql = "SELECT m.id, m.username, m.fullname, m.dob, m.email, "
                + "m.phone, m.note, a.id AS addressId, a.houseNumber, a.street, a.ward, a.city "
                + "FROM tblCustomer c "
                + "JOIN tblMember m ON c.tblMemberId = m.id "
                + "LEFT JOIN tblAddress a ON m.tblAddressId = a.id "
                + "WHERE c.tblMemberId = ?";
        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setInt(1, id);
            try (ResultSet result = statement.executeQuery()) {
                return result.next() ? new Customer4[] { mapCustomer(result) } : new Customer4[0];
            }
        }
    }

    public Customer4 authenticate(String username, String password) throws SQLException {
        if (blank(username) || password == null) {
            return null;
        }
        String sql = "SELECT m.id, m.username, m.password, m.fullname, m.dob, m.email, "
                + "m.phone, m.note, a.id AS addressId, a.houseNumber, a.street, a.ward, a.city "
                + "FROM tblMember m "
                + "JOIN tblCustomer c ON c.tblMemberId = m.id "
                + "LEFT JOIN tblAddress a ON m.tblAddressId = a.id "
                + "WHERE m.username = ?";
        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setString(1, username.trim());
            try (ResultSet result = statement.executeQuery()) {
                if (!result.next() || !verifyPassword(password, result.getString("password"))) {
                    return null;
                }
                return mapCustomer(result);
            }
        } catch (GeneralSecurityException exception) {
            throw new SQLException("Could not verify the account password.", exception);
        }
    }

    public Customer4 registerCustomer(Customer4 customer) throws SQLException {
        validateCustomer(customer);
        String passwordHash;
        try {
            passwordHash = hashPassword(customer.getPassword());
        } catch (GeneralSecurityException exception) {
            throw new SQLException("Could not secure the account password.", exception);
        }

        boolean wasAutoCommit = con.getAutoCommit();
        Savepoint savepoint = null;
        if (wasAutoCommit) {
            con.setAutoCommit(false);
        } else {
            savepoint = con.setSavepoint();
        }

        int addressId;
        int memberId;
        try {
            addressId = insertAddress(customer.getAddress());
            memberId = insertMember(customer, addressId, passwordHash);
            try (PreparedStatement statement = con.prepareStatement(
                    "INSERT INTO tblCustomer (tblMemberId) VALUES (?)")) {
                statement.setInt(1, memberId);
                if (statement.executeUpdate() != 1) {
                    throw new SQLException("The customer account was not created.");
                }
            }
            if (wasAutoCommit) {
                con.commit();
            } else {
                con.releaseSavepoint(savepoint);
            }
        } catch (SQLException | RuntimeException exception) {
            if (wasAutoCommit) {
                con.rollback();
            } else {
                con.rollback(savepoint);
            }
            throw exception;
        } finally {
            if (wasAutoCommit) {
                con.setAutoCommit(true);
            }
        }

        customer.setId(memberId);
        customer.getAddress().setId(addressId);
        customer.setPassword(null);
        return customer;
    }

    private int insertAddress(Address4 address) throws SQLException {
        String sql = "INSERT INTO tblAddress (houseNumber, street, ward, city) VALUES (?, ?, ?, ?)";
        try (PreparedStatement statement = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, address.getHouseNumber().trim());
            statement.setString(2, address.getStreet().trim());
            statement.setString(3, address.getWard().trim());
            statement.setString(4, address.getCity().trim());
            if (statement.executeUpdate() != 1) {
                throw new SQLException("The delivery address was not saved.");
            }
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (!keys.next()) {
                    throw new SQLException("The database did not return an address id.");
                }
                return keys.getInt(1);
            }
        }
    }

    private int insertMember(Customer4 customer, int addressId, String passwordHash)
            throws SQLException {
        String sql = "INSERT INTO tblMember "
                + "(username, password, fullname, dob, email, phone, note, tblAddressId) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement statement = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, customer.getUsername().trim());
            statement.setString(2, passwordHash);
            statement.setString(3, customer.getFullname().trim());
            statement.setDate(4, java.sql.Date.valueOf(customer.getDob()));
            statement.setString(5, customer.getEmail().trim());
            statement.setString(6, customer.getPhone().trim());
            statement.setString(7, customer.getNote());
            statement.setInt(8, addressId);
            if (statement.executeUpdate() != 1) {
                throw new SQLException("The member record was not created.");
            }
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (!keys.next()) {
                    throw new SQLException("The database did not return a member id.");
                }
                return keys.getInt(1);
            }
        }
    }

    private Customer4 mapCustomer(ResultSet result) throws SQLException {
        java.sql.Date dateOfBirth = result.getDate("dob");
        int addressId = result.getInt("addressId");
        boolean hasAddress = !result.wasNull();
        Address4 address = hasAddress
                ? new Address4(addressId, result.getString("houseNumber"),
                        result.getString("street"), result.getString("ward"),
                        result.getString("city"))
                : null;
        return new Customer4(result.getInt("id"), result.getString("username"), null,
                result.getString("fullname"),
                dateOfBirth == null ? null : dateOfBirth.toLocalDate(),
                result.getString("email"), result.getString("phone"),
                result.getString("note"), address);
    }

    private void validateCustomer(Customer4 customer) {
        if (customer == null || blank(customer.getUsername()) || blank(customer.getPassword())
                || customer.getPassword().length() < 8 || blank(customer.getFullname())
                || customer.getDob() == null || blank(customer.getEmail())
                || blank(customer.getPhone()) || customer.getAddress() == null
                || blank(customer.getAddress().getHouseNumber())
                || blank(customer.getAddress().getStreet())
                || blank(customer.getAddress().getWard())
                || blank(customer.getAddress().getCity())) {
            throw new IllegalArgumentException("Complete all required registration fields. "
                    + "Password must contain at least 8 characters.");
        }
    }

    private boolean blank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String hashPassword(String password) throws GeneralSecurityException {
        byte[] salt = new byte[SALT_BYTES];
        new SecureRandom().nextBytes(salt);
        byte[] hash = derivePassword(password.toCharArray(), salt, PASSWORD_ITERATIONS);
        return "pbkdf2$" + PASSWORD_ITERATIONS + "$" + Base64.getEncoder().encodeToString(salt)
                + "$" + Base64.getEncoder().encodeToString(hash);
    }

    private boolean verifyPassword(String password, String encoded)
            throws GeneralSecurityException {
        if (encoded == null) {
            return false;
        }
        String[] parts = encoded.split("\\$", -1);
        if (parts.length != 4 || !"pbkdf2".equals(parts[0])) {
            return false;
        }
        int iterations;
        byte[] salt;
        byte[] expected;
        try {
            iterations = Integer.parseInt(parts[1]);
            salt = Base64.getDecoder().decode(parts[2]);
            expected = Base64.getDecoder().decode(parts[3]);
        } catch (IllegalArgumentException exception) {
            return false;
        }
        if (iterations < 1 || iterations > 1_000_000 || salt.length < SALT_BYTES
                || expected.length != PASSWORD_BITS / 8) {
            return false;
        }
        byte[] actual = derivePassword(password.toCharArray(), salt, iterations);
        return MessageDigest.isEqual(expected, actual);
    }

    private byte[] derivePassword(char[] password, byte[] salt, int iterations)
            throws GeneralSecurityException {
        PBEKeySpec spec = new PBEKeySpec(password, salt, iterations, PASSWORD_BITS);
        Arrays.fill(password, '\0');
        try {
            return SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256")
                    .generateSecret(spec).getEncoded();
        } finally {
            spec.clearPassword();
        }
    }
}

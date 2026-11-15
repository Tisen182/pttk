package dao;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Savepoint;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Receipt4;
import model.ReceiptDetails4;

public class ReceiptDAO extends DAO {
    public ReceiptDAO(java.sql.Connection con) {
        super(con);
    }

    public boolean saveOrder(Receipt4 receipt) throws SQLException {
        validateOrder(receipt);

        boolean wasAutoCommit = con.getAutoCommit();
        Savepoint savepoint = null;
        if (wasAutoCommit) {
            con.setAutoCommit(false);
        } else {
            savepoint = con.setSavepoint();
        }

        List<Integer> detailIds = new ArrayList<>();
        int receiptId;
        try {
            receiptId = insertReceipt(receipt);
            for (ReceiptDetails4 detail : receipt.getReceiptDetails()) {
                decrementProductStock(detail);
                detailIds.add(insertReceiptDetail(receiptId, detail));
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

        receipt.setId(receiptId);
        receipt.setTotal(receipt.calculateTotal());
        for (int i = 0; i < detailIds.size(); i++) {
            ReceiptDetails4 detail = receipt.getReceiptDetails().get(i);
            detail.setId(detailIds.get(i));
            detail.getProduct().setStockQuantity(
                    detail.getProduct().getStockQuantity() - detail.getQuantity());
        }
        return true;
    }

    private void decrementProductStock(ReceiptDetails4 detail) throws SQLException {
        String sql = "UPDATE tblProduct SET stockQuantity = stockQuantity - ? "
                + "WHERE id = ? AND stockQuantity >= ?";
        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setInt(1, detail.getQuantity());
            statement.setInt(2, detail.getProduct().getId());
            statement.setInt(3, detail.getQuantity());
            if (statement.executeUpdate() != 1) {
                throw new SQLException("Insufficient stock or product not found for product id "
                        + detail.getProduct().getId() + ".");
            }
        }
    }

    private int insertReceipt(Receipt4 receipt) throws SQLException {
        String sql = "INSERT INTO tblReceipt "
                + "(receiptCode, receiptDate, status, total, payment, tblAddressId, "
                + "tblCustomerTblMemberId) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement statement = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, receipt.getReceiptCode());
            statement.setDate(2, java.sql.Date.valueOf(receipt.getReceiptDate()));
            statement.setString(3, receipt.getStatus());
            statement.setFloat(4, receipt.calculateTotal());
            statement.setString(5, receipt.getPayment());
            statement.setInt(6, receipt.getDeliveryAddress().getId());
            statement.setInt(7, receipt.getCustomer().getId());
            if (statement.executeUpdate() != 1) {
                throw new SQLException("The order header was not inserted.");
            }
            try (java.sql.ResultSet keys = statement.getGeneratedKeys()) {
                if (!keys.next()) {
                    throw new SQLException("The database did not return an order id.");
                }
                return keys.getInt(1);
            }
        }
    }

    private int insertReceiptDetail(int receiptId, ReceiptDetails4 detail) throws SQLException {
        String sql = "INSERT INTO tblReceiptDetails "
                + "(quantity, price, tblReceiptId, tblProductId) VALUES (?, ?, ?, ?)";
        try (PreparedStatement statement = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, detail.getQuantity());
            statement.setFloat(2, detail.getPrice());
            statement.setInt(3, receiptId);
            statement.setInt(4, detail.getProduct().getId());
            if (statement.executeUpdate() != 1) {
                throw new SQLException("An order line was not inserted.");
            }
            try (java.sql.ResultSet keys = statement.getGeneratedKeys()) {
                if (!keys.next()) {
                    throw new SQLException("The database did not return an order-line id.");
                }
                return keys.getInt(1);
            }
        }
    }

    private void validateOrder(Receipt4 receipt) {
        if (receipt == null) {
            throw new IllegalArgumentException("Order is required.");
        }
        if (receipt.getReceiptCode() == null || receipt.getReceiptCode().trim().isEmpty()) {
            throw new IllegalArgumentException("Order code is required.");
        }
        if (receipt.getReceiptDate() == null) {
            throw new IllegalArgumentException("Order date is required.");
        }
        if (receipt.getCustomer() == null || receipt.getCustomer().getId() <= 0) {
            throw new IllegalArgumentException("A saved customer is required.");
        }
        if (receipt.getDeliveryAddress() == null || receipt.getDeliveryAddress().getId() <= 0) {
            throw new IllegalArgumentException("A saved delivery address is required.");
        }
        if (receipt.getReceiptDetails().isEmpty()) {
            throw new IllegalArgumentException("Cannot save an order without items.");
        }
        for (ReceiptDetails4 detail : receipt.getReceiptDetails()) {
            if (detail.getProduct() == null || detail.getProduct().getId() <= 0
                    || detail.getQuantity() <= 0 || detail.getPrice() < 0) {
                throw new IllegalArgumentException("Order lines require a saved product, "
                        + "positive quantity, and non-negative price.");
            }
        }
    }
}

package DAO;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.Product4;

public class ProductDAO extends DAO {
    public ProductDAO(java.sql.Connection con) {
        super(con);
    }

    public Product4[] searchProductByName(String keyword) throws SQLException {
        if (keyword == null) {
            throw new IllegalArgumentException("Search keyword is required.");
        }
        String normalizedKeyword = keyword.trim().toLowerCase(java.util.Locale.ROOT);
        if (normalizedKeyword.isEmpty()) {
            return new Product4[0];
        }
        String sql = "SELECT id, productCode, productName, unitPrice, stockQuantity, description "
                + "FROM tblProduct WHERE LOWER(productName) LIKE ? ESCAPE '!' ORDER BY productName";
        List<Product4> products = new ArrayList<>();
        try (PreparedStatement statement = con.prepareStatement(sql)) {
            String escapedKeyword = normalizedKeyword.replace("!", "!!")
                    .replace("%", "!%").replace("_", "!_");
            statement.setString(1, "%" + escapedKeyword + "%");
            try (ResultSet results = statement.executeQuery()) {
                while (results.next()) {
                    products.add(mapProduct(results));
                }
            }
        }
        return products.toArray(new Product4[0]);
    }

    public Product4 getProductById(int id) throws SQLException {
        if (id <= 0) {
            throw new IllegalArgumentException("Product id must be greater than zero.");
        }
        String sql = "SELECT id, productCode, productName, unitPrice, stockQuantity, description "
                + "FROM tblProduct WHERE id = ?";
        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setInt(1, id);
            try (ResultSet results = statement.executeQuery()) {
                return results.next() ? mapProduct(results) : null;
            }
        }
    }

    private Product4 mapProduct(ResultSet result) throws SQLException {
        return new Product4(result.getInt("id"), result.getString("productCode"),
                result.getString("productName"), result.getFloat("unitPrice"),
                result.getInt("stockQuantity"), result.getString("description"));
    }
}

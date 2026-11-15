package DAO;

import java.sql.SQLException;
import models.Cart4;
import models.CartDetails4;
import models.Product4;

public class CartDAO extends DAO {
    private final ProductDAO productDAO;

    public CartDAO(java.sql.Connection con) {
        super(con);
        this.productDAO = new ProductDAO(con);
    }

    public boolean addItemToCart(Cart4 cart, int productId, int quantity) throws SQLException {
        if (cart == null) {
            throw new IllegalArgumentException("A cart is required.");
        }
        Product4 product = productDAO.getProductById(productId);
        if (product == null) {
            return false;
        }
        cart.addProduct(product, quantity);
        return true;
    }

    public boolean updateQuantity(Cart4 cart, int productId, int quantity) throws SQLException {
        if (cart == null) {
            throw new IllegalArgumentException("A cart is required.");
        }
        if (quantity <= 0) {
            cart.removeProduct(productId);
            return true;
        }

        Product4 product = productDAO.getProductById(productId);
        if (product == null) {
            return false;
        }
        for (CartDetails4 detail : cart.getCartDetails()) {
            if (detail.getProduct().getId() == productId) {
                detail.setProduct(product);
                cart.setQuantity(productId, quantity);
                return true;
            }
        }
        return false;
    }

    public CartDetails4[] getCartDetail(Cart4 cart) {
        if (cart == null) {
            throw new IllegalArgumentException("A cart is required.");
        }
        return cart.getCartDetails().toArray(new CartDetails4[0]);
    }
}

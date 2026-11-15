package model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Cart4 {
    private int id;
    private String cartCode;
    private float provisionalTotal;
    private Customer4 customer;
    private final List<CartDetails4> cartDetails = new ArrayList<>();

    public Cart4() {}

    public Cart4(int id, String cartCode, Customer4 customer) {
        this.id = id;
        this.cartCode = cartCode;
        this.customer = customer;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getCartCode() { return cartCode; }
    public void setCartCode(String cartCode) { this.cartCode = cartCode; }
    public float getProvisionalTotal() { return provisionalTotal; }
    public Customer4 getCustomer() { return customer; }
    public void setCustomer(Customer4 customer) { this.customer = customer; }
    public List<CartDetails4> getCartDetails() {
        return Collections.unmodifiableList(cartDetails);
    }

    public void addProduct(Product4 product, int quantity) {
        if (product == null || product.getId() <= 0) {
            throw new IllegalArgumentException("A saved product is required.");
        }
        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be greater than zero.");
        }
        for (CartDetails4 detail : cartDetails) {
            if (detail.getProduct().getId() == product.getId()) {
                setQuantity(product.getId(), detail.getQuantity() + quantity);
                return;
            }
        }
        if (quantity > product.getStockQuantity()) {
            throw new IllegalArgumentException("Quantity exceeds available stock.");
        }
        cartDetails.add(new CartDetails4(0, quantity, product));
        recalculateTotal();
    }

    public void setQuantity(int productId, int quantity) {
        if (quantity <= 0) {
            removeProduct(productId);
            return;
        }
        for (CartDetails4 detail : cartDetails) {
            if (detail.getProduct().getId() == productId) {
                if (quantity > detail.getProduct().getStockQuantity()) {
                    throw new IllegalArgumentException("Quantity exceeds available stock.");
                }
                detail.setQuantity(quantity);
                recalculateTotal();
                return;
            }
        }
        throw new IllegalArgumentException("Product is not in the cart.");
    }

    public void removeProduct(int productId) {
        cartDetails.removeIf(detail -> detail.getProduct().getId() == productId);
        recalculateTotal();
    }

    public float recalculateTotal() {
        provisionalTotal = 0f;
        for (CartDetails4 detail : cartDetails) {
            provisionalTotal += detail.getSubtotal();
        }
        return provisionalTotal;
    }
}

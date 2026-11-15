package models;

public class CartDetails4 {
    private int id;
    private int quantity;
    private Product4 product;

    public CartDetails4() {}

    public CartDetails4(int id, int quantity, Product4 product) {
        this.id = id;
        this.quantity = quantity;
        this.product = product;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public Product4 getProduct() { return product; }
    public void setProduct(Product4 product) { this.product = product; }
    public float getSubtotal() {
        return product == null ? 0f : product.getUnitPrice() * quantity;
    }
}

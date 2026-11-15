package model;

public class ReceiptDetails4 {
    private int id;
    private int quantity;
    private float price;
    private Product4 product;

    public ReceiptDetails4() {}

    public ReceiptDetails4(int id, int quantity, float price, Product4 product) {
        this.id = id;
        this.quantity = quantity;
        this.price = price;
        this.product = product;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public float getPrice() { return price; }
    public void setPrice(float price) { this.price = price; }
    public Product4 getProduct() { return product; }
    public void setProduct(Product4 product) { this.product = product; }
    public float getSubtotal() { return price * quantity; }
}

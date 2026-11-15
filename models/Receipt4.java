package models;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Receipt4 {
    private int id;
    private String receiptCode;
    private LocalDate receiptDate;
    private String status;
    private float total;
    private String payment;
    private Address4 deliveryAddress;
    private Customer4 customer;
    private final List<ReceiptDetails4> receiptDetails = new ArrayList<>();

    public Receipt4() {}

    public Receipt4(int id, String receiptCode, LocalDate receiptDate, String status, float total,
                    String payment, Address4 deliveryAddress, Customer4 customer) {
        this.id = id;
        this.receiptCode = receiptCode;
        this.receiptDate = receiptDate;
        this.status = status;
        this.total = total;
        this.payment = payment;
        this.deliveryAddress = deliveryAddress;
        this.customer = customer;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getReceiptCode() { return receiptCode; }
    public void setReceiptCode(String receiptCode) { this.receiptCode = receiptCode; }
    public LocalDate getReceiptDate() { return receiptDate; }
    public void setReceiptDate(LocalDate receiptDate) { this.receiptDate = receiptDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public float getTotal() { return total; }
    public void setTotal(float total) { this.total = total; }
    public String getPayment() { return payment; }
    public void setPayment(String payment) { this.payment = payment; }
    public Address4 getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(Address4 deliveryAddress) { this.deliveryAddress = deliveryAddress; }
    public Customer4 getCustomer() { return customer; }
    public void setCustomer(Customer4 customer) { this.customer = customer; }
    public List<ReceiptDetails4> getReceiptDetails() {
        return Collections.unmodifiableList(receiptDetails);
    }
    public void addDetail(ReceiptDetails4 detail) {
        if (detail == null) {
            throw new IllegalArgumentException("Receipt detail is required.");
        }
        receiptDetails.add(detail);
    }
    public float calculateTotal() {
        float calculated = 0f;
        for (ReceiptDetails4 detail : receiptDetails) {
            calculated += detail.getSubtotal();
        }
        return calculated;
    }

    public static Receipt4 fromCart(Cart4 cart, String receiptCode, LocalDate receiptDate,
                                   String payment, Address4 deliveryAddress) {
        if (cart == null || cart.getCustomer() == null) {
            throw new IllegalArgumentException("A customer cart is required.");
        }
        if (cart.getCartDetails().isEmpty()) {
            throw new IllegalArgumentException("Cannot submit an empty cart.");
        }
        Receipt4 receipt = new Receipt4(0, receiptCode, receiptDate, "Pending",
                cart.recalculateTotal(), payment, deliveryAddress, cart.getCustomer());
        for (CartDetails4 cartDetail : cart.getCartDetails()) {
            Product4 product = cartDetail.getProduct();
            receipt.addDetail(new ReceiptDetails4(0, cartDetail.getQuantity(),
                    product.getUnitPrice(), product));
        }
        return receipt;
    }
}

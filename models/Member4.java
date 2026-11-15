package models;

import java.time.LocalDate;

public class Member4 {
    private int id;
    private String username;
    private String password;
    private String fullname;
    private LocalDate dob;
    private String email;
    private String phone;
    private String note;
    private Address4 address;

    public Member4() {}

    public Member4(int id, String username, String password, String fullname, LocalDate dob,
                   String email, String phone, String note, Address4 address) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.fullname = fullname;
        this.dob = dob;
        this.email = email;
        this.phone = phone;
        this.note = note;
        this.address = address;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }
    public LocalDate getDob() { return dob; }
    public void setDob(LocalDate dob) { this.dob = dob; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public Address4 getAddress() { return address; }
    public void setAddress(Address4 address) { this.address = address; }
}

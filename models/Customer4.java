package models;

import java.time.LocalDate;

public class Customer4 extends Member4 {
    public Customer4() {}

    public Customer4(int id, String username, String password, String fullname, LocalDate dob,
                     String email, String phone, String note, Address4 address) {
        super(id, username, password, fullname, dob, email, phone, note, address);
    }
}

CREATE DATABASE IF NOT EXISTS DepartmentStoreDB
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE DepartmentStoreDB;

CREATE TABLE IF NOT EXISTS tblAddress (
    id INT NOT NULL AUTO_INCREMENT,
    houseNumber VARCHAR(100) NOT NULL,
    street VARCHAR(150) NOT NULL,
    ward VARCHAR(150) NOT NULL,
    city VARCHAR(150) NOT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblMember (
    id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    fullname VARCHAR(200) NOT NULL,
    dob DATE NOT NULL,
    email VARCHAR(254) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    note VARCHAR(1000) NOT NULL DEFAULT '',
    tblAddressId INT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_tblMember_username (username),
    CONSTRAINT fk_tblMember_address FOREIGN KEY (tblAddressId)
        REFERENCES tblAddress (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblCustomer (
    tblMemberId INT NOT NULL,
    PRIMARY KEY (tblMemberId),
    CONSTRAINT fk_tblCustomer_member FOREIGN KEY (tblMemberId)
        REFERENCES tblMember (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblProduct (
    id INT NOT NULL AUTO_INCREMENT,
    productCode VARCHAR(80) NOT NULL,
    productName VARCHAR(255) NOT NULL,
    unitPrice DECIMAL(12, 2) NOT NULL,
    stockQuantity INT NOT NULL DEFAULT 0,
    description TEXT,
    PRIMARY KEY (id),
    UNIQUE KEY uq_tblProduct_productCode (productCode),
    KEY ix_tblProduct_productName (productName),
    CONSTRAINT chk_tblProduct_unitPrice CHECK (unitPrice >= 0),
    CONSTRAINT chk_tblProduct_stockQuantity CHECK (stockQuantity >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblReceipt (
    id INT NOT NULL AUTO_INCREMENT,
    receiptCode VARCHAR(40) NOT NULL,
    receiptDate DATE NOT NULL,
    status VARCHAR(40) NOT NULL,
    total DECIMAL(14, 2) NOT NULL DEFAULT 0,
    payment VARCHAR(100) NOT NULL,
    tblAddressId INT NOT NULL,
    tblCustomerTblMemberId INT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_tblReceipt_receiptCode (receiptCode),
    CONSTRAINT fk_tblReceipt_address FOREIGN KEY (tblAddressId)
        REFERENCES tblAddress (id),
    CONSTRAINT fk_tblReceipt_customer FOREIGN KEY (tblCustomerTblMemberId)
        REFERENCES tblCustomer (tblMemberId)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblReceiptDetails (
    id INT NOT NULL AUTO_INCREMENT,
    quantity INT NOT NULL,
    price DECIMAL(12, 2) NOT NULL,
    tblReceiptId INT NOT NULL,
    tblProductId INT NOT NULL,
    PRIMARY KEY (id),
    KEY ix_tblReceiptDetails_receipt (tblReceiptId),
    CONSTRAINT fk_tblReceiptDetails_receipt FOREIGN KEY (tblReceiptId)
        REFERENCES tblReceipt (id),
    CONSTRAINT fk_tblReceiptDetails_product FOREIGN KEY (tblProductId)
        REFERENCES tblProduct (id),
    CONSTRAINT chk_tblReceiptDetails_quantity CHECK (quantity > 0),
    CONSTRAINT chk_tblReceiptDetails_price CHECK (price >= 0)
) ENGINE=InnoDB;

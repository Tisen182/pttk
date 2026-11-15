USE DepartmentStoreDB;

-- These are synthetic demo accounts and approximate sample retail prices.
-- All demo accounts use the password Demo2026!; do not use them in production.
DROP TEMPORARY TABLE IF EXISTS seedCustomers;
CREATE TEMPORARY TABLE seedCustomers (
    username VARCHAR(100) NOT NULL PRIMARY KEY,
    passwordHash VARCHAR(255) NOT NULL,
    fullname VARCHAR(200) NOT NULL,
    dob DATE NOT NULL,
    email VARCHAR(254) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    houseNumber VARCHAR(100) NOT NULL,
    street VARCHAR(150) NOT NULL,
    ward VARCHAR(150) NOT NULL,
    city VARCHAR(150) NOT NULL
) ENGINE=InnoDB;

INSERT INTO seedCustomers
    (username, passwordHash, fullname, dob, email, phone,
     houseNumber, street, ward, city)
VALUES
    ('demo_customer_01', 'pbkdf2$120000$V4bZynUBdJnTkLcyg/QUOg==$4MiGWsGKNTA104MrRmzZBfPDf0izaHxwfHtgE60C+Fs=', 'Nguyễn Minh An', '1993-02-14', 'demo_customer_01@example.test', '0000000001', 'Demo 01', 'Đường Mẫu 01', 'Phường Mẫu 01', 'TP. Hồ Chí Minh'),
    ('demo_customer_02', 'pbkdf2$120000$9ZX1bKoptLfxLwoenwsuIA==$VS8PlKi86Y5qL/377+qI2aXkd6LHttRClmoIuY3H5no=', 'Trần Thu Bình', '1995-07-22', 'demo_customer_02@example.test', '0000000002', 'Demo 02', 'Đường Mẫu 02', 'Phường Mẫu 02', 'TP. Hà Nội'),
    ('demo_customer_03', 'pbkdf2$120000$JsHOEAYo+F5soyCDa5tlsA==$ZcNBSBUKyTyrK3p3V13G5DA8oDZC/diZJ2RCjTktXRo=', 'Lê Quốc Bảo', '1988-11-03', 'demo_customer_03@example.test', '0000000003', 'Demo 03', 'Đường Mẫu 03', 'Phường Mẫu 03', 'TP. Đà Nẵng'),
    ('demo_customer_04', 'pbkdf2$120000$OCzgkwmigPdMsxRSfwaZhA==$++S2nTrL5+x3unK2WXGe8vQH39qeXt0CRBdjXE+/5lU=', 'Phạm Ngọc Chi', '1997-04-18', 'demo_customer_04@example.test', '0000000004', 'Demo 04', 'Đường Mẫu 04', 'Phường Mẫu 04', 'TP. Cần Thơ'),
    ('demo_customer_05', 'pbkdf2$120000$XCDohHrBum1JqxX+HCqzjQ==$niowTIJC2JNGRsCm/LvLdRs3fexaoo3E/lcUVlYiQU8=', 'Hoàng Gia Huy', '1991-09-09', 'demo_customer_05@example.test', '0000000005', 'Demo 05', 'Đường Mẫu 05', 'Phường Mẫu 05', 'TP. Hải Phòng'),
    ('demo_customer_06', 'pbkdf2$120000$9wH0ijCYwnTBryuylWgLnw==$HQl62AvGHZbZpHSMYmyH/H4K7bqsMekn9XmRJCE878c=', 'Vũ Thảo Linh', '1999-01-27', 'demo_customer_06@example.test', '0000000006', 'Demo 06', 'Đường Mẫu 06', 'Phường Mẫu 06', 'TP. Huế'),
    ('demo_customer_07', 'pbkdf2$120000$SYDmvJnyCAvqTZaIhkrZzw==$a/tXER+fMbC1opDuOkJI2paxF0oHYtar0gABhfIOdZs=', 'Đặng Đức Long', '1986-06-12', 'demo_customer_07@example.test', '0000000007', 'Demo 07', 'Đường Mẫu 07', 'Phường Mẫu 07', 'TP. Hồ Chí Minh'),
    ('demo_customer_08', 'pbkdf2$120000$mP4hr/HenpPghR3lFBSLVw==$ot8rJuy5KjWMevMkldBLJjdYYIEjeMC9fz8tAFQIhcA=', 'Bùi Khánh Ngọc', '1994-12-05', 'demo_customer_08@example.test', '0000000008', 'Demo 08', 'Đường Mẫu 08', 'Phường Mẫu 08', 'TP. Hà Nội'),
    ('demo_customer_09', 'pbkdf2$120000$+xcyqKFazfu7CZnePYlPag==$h4zOXwrBqwFFPcuTN+DL0R1tkxpveMUek//mM1yTojw=', 'Đỗ Anh Tuấn', '1990-03-30', 'demo_customer_09@example.test', '0000000009', 'Demo 09', 'Đường Mẫu 09', 'Phường Mẫu 09', 'TP. Đà Nẵng'),
    ('demo_customer_10', 'pbkdf2$120000$QVyAsnmWsRcXkM1G/qg4DA==$RL1Ig6P03g/igPAxPAyd+Dqi5atyJWk6M6/N9ub3Clk=', 'Hồ Mai Phương', '1998-08-16', 'demo_customer_10@example.test', '0000000010', 'Demo 10', 'Đường Mẫu 10', 'Phường Mẫu 10', 'TP. Cần Thơ'),
    ('demo_customer_11', 'pbkdf2$120000$HM5KJ4LztW0dwjRZuY/n0g==$eMeuxMT4AlWinFz7IENe2VMWZW20N8t5bxmIu72CddU=', 'Ngô Thành Đạt', '1989-05-21', 'demo_customer_11@example.test', '0000000011', 'Demo 11', 'Đường Mẫu 11', 'Phường Mẫu 11', 'TP. Hải Phòng'),
    ('demo_customer_12', 'pbkdf2$120000$m+dm5TIPJscDi49bpkoP2A==$+EsmCgTI7ipxEzzHgp+5clC97oBiHeBNuAIk4oZ1gGA=', 'Dương Hà My', '2000-10-08', 'demo_customer_12@example.test', '0000000012', 'Demo 12', 'Đường Mẫu 12', 'Phường Mẫu 12', 'TP. Huế'),
    ('demo_customer_13', 'pbkdf2$120000$iec056CO8kNc0MlP4cNRjQ==$hZDCvK3QxA9rYfDf9Yf6I0HIXty6/Ok0gVOltA1Kycg=', 'Lý Hoàng Nam', '1992-01-11', 'demo_customer_13@example.test', '0000000013', 'Demo 13', 'Đường Mẫu 13', 'Phường Mẫu 13', 'TP. Hồ Chí Minh'),
    ('demo_customer_14', 'pbkdf2$120000$+pTW7f7N3BENLnXJdT5Nlg==$kJYOleIVfgyJ5eZqcGG2pam4VrkWXHs2JI7FZZ5k55g=', 'Mai Bảo Trân', '1996-06-25', 'demo_customer_14@example.test', '0000000014', 'Demo 14', 'Đường Mẫu 14', 'Phường Mẫu 14', 'TP. Hà Nội'),
    ('demo_customer_15', 'pbkdf2$120000$hLnJKdiqISjRV8xC/ddEgw==$rk53kJHNnCR+Z7+ZxaiY9+12UMoAhD03/yoQjLl9CmQ=', 'Tạ Quang Vinh', '1987-12-19', 'demo_customer_15@example.test', '0000000015', 'Demo 15', 'Đường Mẫu 15', 'Phường Mẫu 15', 'TP. Đà Nẵng'),
    ('demo_customer_16', 'pbkdf2$120000$BxPseDB+0z/JCZLnUP0m4w==$KHDT9f2ZO8zwRpNc34p2Gwwd63eKD5CXXBUvp1zEbts=', 'Cao Thùy Dung', '1993-09-02', 'demo_customer_16@example.test', '0000000016', 'Demo 16', 'Đường Mẫu 16', 'Phường Mẫu 16', 'TP. Cần Thơ'),
    ('demo_customer_17', 'pbkdf2$120000$Fn1uzW7v2RtUWT54b86FlQ==$/g3Gi9UivczFarfojS+4DYDxN2ljZXJUXpX/EaYWpBA=', 'Phan Nhật Minh', '1998-02-07', 'demo_customer_17@example.test', '0000000017', 'Demo 17', 'Đường Mẫu 17', 'Phường Mẫu 17', 'TP. Hải Phòng'),
    ('demo_customer_18', 'pbkdf2$120000$w1TchpHIlRld8k0Pi3EZpQ==$fmZJ14mrhdGPKqh1MzsftcUU01XI/Kc7gPJj+gfzuwA=', 'Võ Thanh Hà', '1991-04-14', 'demo_customer_18@example.test', '0000000018', 'Demo 18', 'Đường Mẫu 18', 'Phường Mẫu 18', 'TP. Huế'),
    ('demo_customer_19', 'pbkdf2$120000$ZX+MHDZ8lZWUbln8DQtpXw==$wztY9ey06hLH3Yq9f8r8rosxvfKm29iu0onJ5hBRcQE=', 'Trương Đức Anh', '1985-08-29', 'demo_customer_19@example.test', '0000000019', 'Demo 19', 'Đường Mẫu 19', 'Phường Mẫu 19', 'TP. Hồ Chí Minh'),
    ('demo_customer_20', 'pbkdf2$120000$NucUnsz+LUmnW+/LpU/qfw==$d5J4K4lmgY9mJWAXGgMJOJ4thdAP3J8UOgFSltPoR0Y=', 'Đinh Ngọc Yến', '1997-11-13', 'demo_customer_20@example.test', '0000000020', 'Demo 20', 'Đường Mẫu 20', 'Phường Mẫu 20', 'TP. Hà Nội'),
    ('demo_customer_21', 'pbkdf2$120000$JCDDsCeyIoeOaHzrd7l/Pw==$7RM8saYdB1B0UFrDARuA/bfyyVoZomftyRlqp5LSbmU=', 'Nguyễn Hải Đăng', '1994-03-06', 'demo_customer_21@example.test', '0000000021', 'Demo 21', 'Đường Mẫu 21', 'Phường Mẫu 21', 'TP. Đà Nẵng'),
    ('demo_customer_22', 'pbkdf2$120000$JplR23v2lm8fIEJ5qsttjw==$/CprpAtf/VTcDNQ6es4er8RGDxTYxgQCCPZaepNh69Q=', 'Trần Mỹ Duyên', '2001-07-17', 'demo_customer_22@example.test', '0000000022', 'Demo 22', 'Đường Mẫu 22', 'Phường Mẫu 22', 'TP. Cần Thơ'),
    ('demo_customer_23', 'pbkdf2$120000$fk4r34g8vISgmg0ppy4QPA==$UPcXnkXqp5gf4OQWABQORkxKHQ93ohhxV8UCsJZN+pM=', 'Lê Tiến Thành', '1989-10-24', 'demo_customer_23@example.test', '0000000023', 'Demo 23', 'Đường Mẫu 23', 'Phường Mẫu 23', 'TP. Hải Phòng'),
    ('demo_customer_24', 'pbkdf2$120000$DxkrQylZiwOQAFzvFZp26A==$oyAu+mjkaU8IGDlaLiMELmso0/vHJo5IbERB7ljk1Jw=', 'Phạm Thu Trang', '1996-05-09', 'demo_customer_24@example.test', '0000000024', 'Demo 24', 'Đường Mẫu 24', 'Phường Mẫu 24', 'TP. Huế'),
    ('demo_customer_25', 'pbkdf2$120000$Z6GI33Ao2tApTTfDj9VyuA==$nZ0ajUL1P7PZK3g1YEVXkBw0c99/RvYXXerwzgE0NIU=', 'Hoàng Tuấn Kiệt', '1992-12-01', 'demo_customer_25@example.test', '0000000025', 'Demo 25', 'Đường Mẫu 25', 'Phường Mẫu 25', 'TP. Hồ Chí Minh'),
    ('demo_customer_26', 'pbkdf2$120000$4e5i55Dhpag9z/LiNnX6XQ==$kuDI/FMNXFf6HcNrtPKUNf4s+lywcP5X3xI4+CWuLB8=', 'Vũ Diệu Anh', '1999-09-26', 'demo_customer_26@example.test', '0000000026', 'Demo 26', 'Đường Mẫu 26', 'Phường Mẫu 26', 'TP. Hà Nội'),
    ('demo_customer_27', 'pbkdf2$120000$gyh1pdrK6N7v7MaCWoTn/Q==$LCXNsKGc2A0LFqTHXNwuXMx/qVui6lwPmGIJUYdtLEc=', 'Đặng Minh Khang', '1988-04-03', 'demo_customer_27@example.test', '0000000027', 'Demo 27', 'Đường Mẫu 27', 'Phường Mẫu 27', 'TP. Đà Nẵng'),
    ('demo_customer_28', 'pbkdf2$120000$OFX8+fmtnQveZjzBQbuBUw==$xuCPVfQuMe2x/sscN6aiR1ZO0WPlbcfNpI4KXYgHowA=', 'Bùi Phương Thảo', '1995-01-20', 'demo_customer_28@example.test', '0000000028', 'Demo 28', 'Đường Mẫu 28', 'Phường Mẫu 28', 'TP. Cần Thơ'),
    ('demo_customer_29', 'pbkdf2$120000$vktN5FSFPrAxwVVvh6sHgg==$YaER1R05M7b1PXGpqF2epoIvH1gYzQjQRvjxZK9YSkg=', 'Đỗ Gia Bảo', '1990-07-04', 'demo_customer_29@example.test', '0000000029', 'Demo 29', 'Đường Mẫu 29', 'Phường Mẫu 29', 'TP. Hải Phòng'),
    ('demo_customer_30', 'pbkdf2$120000$C8nOuYrkMQOyjHeGmAFSfQ==$0LDHSpg6ZAxvp9b6jfkhcMESAvqhiGN2F8PPbmA6ACU=', 'Hồ Ngọc Mai', '2000-12-28', 'demo_customer_30@example.test', '0000000030', 'Demo 30', 'Đường Mẫu 30', 'Phường Mẫu 30', 'TP. Huế');

START TRANSACTION;

INSERT INTO tblAddress (houseNumber, street, ward, city)
SELECT s.houseNumber, s.street, s.ward, s.city
FROM seedCustomers s
LEFT JOIN tblMember m ON m.username = s.username
WHERE m.id IS NULL;

INSERT INTO tblMember
    (username, password, fullname, dob, email, phone, note, tblAddressId)
SELECT s.username, s.passwordHash, s.fullname, s.dob, s.email, s.phone,
       'Tài khoản demo; thông tin hư cấu.', a.id
FROM seedCustomers s
JOIN tblAddress a
    ON a.houseNumber = s.houseNumber
   AND a.street = s.street
   AND a.ward = s.ward
   AND a.city = s.city
LEFT JOIN tblMember existing ON existing.username = s.username
WHERE existing.id IS NULL;

INSERT INTO tblCustomer (tblMemberId)
SELECT m.id
FROM tblMember m
JOIN seedCustomers s
    ON s.username = m.username
   AND s.passwordHash = m.password
LEFT JOIN tblCustomer c ON c.tblMemberId = m.id
WHERE c.tblMemberId IS NULL;

INSERT IGNORE INTO tblProduct
    (productCode, productName, unitPrice, stockQuantity, description)
VALUES
    ('DEMO-SP-001', 'Sữa chua ăn Vinamilk có đường 100 g', 6500, 120, 'Hộp 100 g; sữa chua lên men có đường. Giá bán tham khảo.'),
    ('DEMO-SP-002', 'Sữa chua ăn Vinamilk ít đường 100 g', 6500, 100, 'Hộp 100 g; sữa chua lên men ít đường. Giá bán tham khảo.'),
    ('DEMO-SP-003', 'Sữa chua nếp cẩm Vinamilk 100 g', 9000, 80, 'Hộp 100 g; sữa chua ăn kèm nếp cẩm. Giá bán tham khảo.'),
    ('DEMO-SP-004', 'Sữa chua uống Probi Vinamilk 65 ml', 6000, 150, 'Chai 65 ml; thức uống sữa chua lên men. Giá bán tham khảo.'),
    ('DEMO-SP-005', 'Sữa tươi tiệt trùng Vinamilk 100% 1 lít', 38000, 70, 'Hộp 1 lít; sữa tươi tiệt trùng. Giá bán tham khảo.'),
    ('DEMO-SP-006', 'Sữa tươi TH true MILK ít đường 1 lít', 42000, 65, 'Hộp 1 lít; sữa tươi tiệt trùng ít đường. Giá bán tham khảo.'),
    ('DEMO-SP-007', 'Sữa đặc Ông Thọ đỏ 380 g', 30000, 50, 'Lon 380 g; sữa đặc có đường. Giá bán tham khảo.'),
    ('DEMO-SP-008', 'Phô mai Con Bò Cười 8 miếng 112 g', 32000, 45, 'Hộp 112 g; gồm 8 miếng phô mai tam giác. Giá bán tham khảo.'),
    ('DEMO-SP-009', 'Bơ lạt Anchor 200 g', 68000, 25, 'Gói 200 g; bơ lạt dùng làm bánh hoặc nấu ăn. Giá bán tham khảo.'),
    ('DEMO-SP-010', 'Trứng gà tươi hộp 10 quả', 32000, 55, 'Vỉ 10 quả; trứng gà tươi, bảo quản lạnh. Giá bán tham khảo.'),
    ('DEMO-SP-011', 'Rau muống', 18000, 40, 'Bó khoảng 500 g; rau ăn lá tươi. Giá bán tham khảo theo kg.'),
    ('DEMO-SP-012', 'Cải ngọt', 22000, 35, 'Rau tươi; thích hợp xào hoặc nấu canh. Giá bán tham khảo theo kg.'),
    ('DEMO-SP-013', 'Cải thìa', 25000, 35, 'Rau tươi; thích hợp xào hoặc nấu lẩu. Giá bán tham khảo theo kg.'),
    ('DEMO-SP-014', 'Rau dền đỏ', 20000, 30, 'Rau tươi; thích hợp nấu canh. Giá bán tham khảo theo kg.'),
    ('DEMO-SP-015', 'Xà lách lolo xanh', 38000, 25, 'Rau ăn sống; đóng gói khoảng 300 g. Giá bán tham khảo theo kg.'),
    ('DEMO-SP-016', 'Bắp cải trắng', 18000, 40, 'Bắp cải tươi; thích hợp luộc, xào hoặc cuốn. Giá bán tham khảo theo kg.'),
    ('DEMO-SP-017', 'Súp lơ xanh (bông cải xanh)', 45000, 25, 'Súp lơ tươi; thích hợp hấp hoặc xào. Giá bán tham khảo theo kg.'),
    ('DEMO-SP-018', 'Cà rốt Đà Lạt', 28000, 40, 'Củ tươi; dùng nấu canh, xào hoặc ép nước. Giá bán tham khảo theo kg.'),
    ('DEMO-SP-019', 'Khoai tây Đà Lạt', 30000, 40, 'Củ tươi; thích hợp chiên, hầm hoặc nấu súp. Giá bán tham khảo theo kg.'),
    ('DEMO-SP-020', 'Cà chua', 32000, 35, 'Cà chua tươi; dùng nấu ăn hoặc làm salad. Giá bán tham khảo theo kg.'),
    ('DEMO-SP-021', 'Dưa leo', 22000, 35, 'Dưa leo tươi; dùng ăn sống hoặc trộn salad. Giá bán tham khảo theo kg.'),
    ('DEMO-SP-022', 'Hành lá', 45000, 20, 'Rau gia vị tươi; giá bán tham khảo theo kg.'),
    ('DEMO-SP-023', 'Rau mồng tơi', 22000, 30, 'Rau tươi; thích hợp nấu canh cua hoặc canh tôm. Giá bán tham khảo theo kg.'),
    ('DEMO-SP-024', 'Đậu que', 35000, 25, 'Đậu que tươi; thích hợp luộc hoặc xào. Giá bán tham khảo theo kg.'),
    ('DEMO-SP-025', 'Bí đỏ', 20000, 30, 'Bí đỏ tươi; dùng nấu canh hoặc nấu chè. Giá bán tham khảo theo kg.'),
    ('DEMO-SP-026', 'Chuối già Nam Mỹ', 28000, 35, 'Chuối tươi; giá bán tham khảo theo kg.'),
    ('DEMO-SP-027', 'Táo Envy nhập khẩu', 95000, 25, 'Táo tươi; giá bán tham khảo theo kg, tùy nguồn cung.'),
    ('DEMO-SP-028', 'Cam sành', 35000, 35, 'Cam tươi; dùng ăn hoặc vắt nước. Giá bán tham khảo theo kg.'),
    ('DEMO-SP-029', 'Xoài cát chu', 55000, 25, 'Xoài tươi; giá bán tham khảo theo kg, tùy mùa vụ.'),
    ('DEMO-SP-030', 'Thanh long ruột trắng', 30000, 30, 'Thanh long tươi; giá bán tham khảo theo kg.'),
    ('DEMO-SP-031', 'Thịt heo ba rọi', 165000, 20, 'Thịt heo tươi; đóng gói khoảng 500 g. Giá bán tham khảo theo kg.'),
    ('DEMO-SP-032', 'Thịt heo nạc vai', 145000, 20, 'Thịt heo tươi; đóng gói khoảng 500 g. Giá bán tham khảo theo kg.'),
    ('DEMO-SP-033', 'Ức gà phi lê', 105000, 25, 'Thịt gà tươi bỏ xương; đóng gói khoảng 500 g. Giá bán tham khảo theo kg.'),
    ('DEMO-SP-034', 'Đùi gà góc tư', 85000, 25, 'Đùi gà tươi; đóng gói khoảng 500 g. Giá bán tham khảo theo kg.'),
    ('DEMO-SP-035', 'Cá basa phi lê', 95000, 18, 'Phi lê cá basa; đóng gói khoảng 500 g, bảo quản lạnh. Giá bán tham khảo theo kg.'),
    ('DEMO-SP-036', 'Tôm thẻ tươi', 220000, 15, 'Tôm thẻ tươi; đóng gói khoảng 500 g. Giá bán tham khảo theo kg.'),
    ('DEMO-SP-037', 'Gạo ST25 túi 5 kg', 185000, 30, 'Túi 5 kg; gạo thơm ST25. Giá bán tham khảo.'),
    ('DEMO-SP-038', 'Gạo Jasmine túi 5 kg', 115000, 35, 'Túi 5 kg; gạo Jasmine. Giá bán tham khảo.'),
    ('DEMO-SP-039', 'Mì Hảo Hảo tôm chua cay 75 g', 4500, 200, 'Gói 75 g; mì ăn liền vị tôm chua cay. Giá bán tham khảo.'),
    ('DEMO-SP-040', 'Mì Omachi sườn hầm ngũ quả 80 g', 8000, 120, 'Gói 80 g; mì ăn liền vị sườn hầm. Giá bán tham khảo.'),
    ('DEMO-SP-041', 'Dầu ăn Tường An Cooking Oil 1 lít', 52000, 45, 'Chai 1 lít; dầu ăn thực vật. Giá bán tham khảo.'),
    ('DEMO-SP-042', 'Nước mắm Nam Ngư 500 ml', 28000, 55, 'Chai 500 ml; nước mắm dùng làm gia vị. Giá bán tham khảo.'),
    ('DEMO-SP-043', 'Nước tương Maggi 500 ml', 26000, 50, 'Chai 500 ml; nước tương dùng làm gia vị. Giá bán tham khảo.'),
    ('DEMO-SP-044', 'Đường tinh luyện Biên Hòa 1 kg', 29000, 45, 'Túi 1 kg; đường tinh luyện. Giá bán tham khảo.'),
    ('DEMO-SP-045', 'Muối i-ốt tinh khiết 500 g', 8000, 80, 'Gói 500 g; muối i-ốt dùng trong chế biến thực phẩm.'),
    ('DEMO-SP-046', 'Nước suối Aquafina 500 ml', 6000, 150, 'Chai 500 ml; nước uống đóng chai. Giá bán tham khảo.'),
    ('DEMO-SP-047', 'Trà xanh Không Độ 455 ml', 10000, 100, 'Chai 455 ml; trà xanh đóng chai. Giá bán tham khảo.'),
    ('DEMO-SP-048', 'Cà phê sữa đá Highlands 235 ml', 15000, 60, 'Lon 235 ml; cà phê sữa đóng lon. Giá bán tham khảo.'),
    ('DEMO-SP-049', 'Bánh mì sandwich tươi 250 g', 28000, 30, 'Túi 250 g; bánh mì sandwich đóng gói. Giá bán tham khảo.'),
    ('DEMO-SP-050', 'Yến mạch cán dẹt Quaker 500 g', 89000, 25, 'Hộp 500 g; yến mạch cán dẹt dùng nấu cháo hoặc ăn sáng. Giá bán tham khảo.');

COMMIT;

SELECT COUNT(*) AS seededCustomers
FROM tblCustomer c
JOIN tblMember m ON m.id = c.tblMemberId
WHERE m.username LIKE 'demo_customer_%';

SELECT COUNT(*) AS seededProducts
FROM tblProduct
WHERE productCode LIKE 'DEMO-SP-%';

DROP TEMPORARY TABLE seedCustomers;

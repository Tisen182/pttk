# Department Store System

Ứng dụng JSP/Java theo sơ đồ triển khai: trình duyệt → Apache Tomcat 9 → MySQL 8.
Phạm vi mã nguồn hiện tại tập trung vào tìm kiếm sản phẩm và đặt hàng trực tuyến.

## Cấu trúc package

- `view/`: trang JSP và CSS giao diện.
- `dao/`: truy cập dữ liệu và các truy vấn JDBC.
- `model/`: các lớp dữ liệu nghiệp vụ.
- `src/main/resources/db/`: schema và dữ liệu demo.
- `src/main/webapp/`: cấu hình web và JNDI cho Tomcat.

Tên package Java dùng chữ thường (`dao`, `model`) theo quy ước Java và sơ đồ package.
Cấu hình Maven đóng gói nội dung `view/` ở thư mục gốc WAR để giữ nguyên URL các trang.

## Yêu cầu

- JDK 8 trở lên
- Maven 3.8 trở lên
- Apache Tomcat 9.x (dùng `javax.servlet`, không tương thích trực tiếp với Tomcat 10)
- MySQL Server 8.x
- MySQL Workbench (tùy chọn, dùng để chạy schema và xem dữ liệu)

Máy phát triển hiện đã có JDK 24, Maven 3.9.16, MySQL Server 9.7 và MySQL Workbench
8.0. Apache Tomcat 9.0.124 được cài ở
`C:\Users\Acer\tools\apache-tomcat-9.0.124`. Maven tự tải Servlet API để biên dịch và
MySQL Connector/J để đóng gói vào WAR.

## Thiết lập cơ sở dữ liệu

Chạy `src/main/resources/db/schema.sql` bằng MySQL Workbench hoặc MySQL client.
Khởi động dịch vụ MySQL đã cài, rồi tạo tài khoản MySQL riêng cho ứng dụng và cấp
quyền `SELECT`, `INSERT`, `UPDATE` trên `DepartmentStoreDB`.

Để nạp dữ liệu demo, chạy tiếp `src/main/resources/db/seed.sql`. Script thêm 30 tài
khoản khách hàng hư cấu (email `example.test`, số điện thoại không định tuyến) và 50
mặt hàng phổ biến với giá tham khảo, không phải giá/stock được xác nhận từ cửa hàng
thời gian thực. Chạy script bằng tài khoản quản trị DB trong MySQL Workbench sau khi
chạy schema; tài khoản ứng dụng không cần quyền tạo temporary table. Chạy lại script
không tạo trùng tài khoản hoặc mã sản phẩm. Tài khoản demo `demo_customer_01` đến
`demo_customer_30` dùng chung mật khẩu `Demo2026!`; chỉ dùng trong môi trường phát
triển, không dùng dữ liệu này trên hệ thống thật.

Ví dụ chạy sau khi tạo schema; thay mật khẩu mẫu bằng mật khẩu riêng:

```sql
CREATE USER 'departmentstore_app'@'localhost' IDENTIFIED BY 'replace-this-password';
GRANT SELECT, INSERT, UPDATE ON DepartmentStoreDB.* TO 'departmentstore_app'@'localhost';
```

## Cấu hình Tomcat

`src/main/webapp/META-INF/context.xml` định nghĩa JNDI DataSource
`java:comp/env/jdbc/DepartmentStore`. Đặt ba system properties sau cho tiến trình
Tomcat (không lưu mật khẩu vào repository). Trên Windows, có thể khai báo chúng trong
tệp riêng `bin\setenv.bat` của Tomcat:

- `departmentstore.db.url`: ví dụ `jdbc:mysql://localhost:3306/DepartmentStoreDB?serverTimezone=UTC`
- `departmentstore.db.username`: tài khoản MySQL của ứng dụng
- `departmentstore.db.password`: mật khẩu tài khoản MySQL

Ví dụ nội dung `bin\setenv.bat` (thay mật khẩu mẫu; không đưa tệp này vào repository):

```bat
set "CATALINA_OPTS=%CATALINA_OPTS% -Ddepartmentstore.db.url=jdbc:mysql://localhost:3306/DepartmentStoreDB?serverTimezone=UTC -Ddepartmentstore.db.username=departmentstore_app -Ddepartmentstore.db.password=replace-this-password"
```

Sau đó khởi động lại Tomcat.

## Build và chạy

Từ thư mục dự án:

```powershell
mvn clean package
```

Chép `target/DepartmentStoreSystem.war` vào thư mục `webapps` của Tomcat 9, khởi động
Tomcat và mở `http://localhost:8080/DepartmentStoreSystem/CustomerHomeUI.jsp`.

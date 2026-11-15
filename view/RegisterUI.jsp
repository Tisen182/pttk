<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="_common.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    String error = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            Address4 address = new Address4(0,
                    request.getParameter("houseNumber"), request.getParameter("street"),
                    request.getParameter("ward"), request.getParameter("city"));
            Customer4 customer = new Customer4();
            customer.setUsername(request.getParameter("username"));
            customer.setPassword(request.getParameter("password"));
            customer.setFullname(request.getParameter("fullname"));
            customer.setDob(LocalDate.parse(request.getParameter("dob")));
            customer.setEmail(request.getParameter("email"));
            customer.setPhone(request.getParameter("phone"));
            customer.setNote("");
            customer.setAddress(address);

            try (Connection connection = openStoreConnection()) {
                new CustomerDAO(connection).registerCustomer(customer);
            }
            session.setAttribute("customer", customer);
            if (session.getAttribute("cart") instanceof Cart4) {
                ((Cart4) session.getAttribute("cart")).setCustomer(customer);
            }
            response.sendRedirect("CustomerHomeUI.jsp");
            return;
        } catch (IllegalArgumentException exception) {
            error = exception.getMessage() == null
                    ? "Vui lòng kiểm tra lại thông tin đăng ký." : exception.getMessage();
        } catch (NamingException | SQLException exception) {
            application.log("Customer registration failed.", exception);
            response.setStatus(503);
            error = "Không thể tạo tài khoản. Tên đăng nhập có thể đã được sử dụng.";
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng ký thành viên</title>
    <link rel="stylesheet" href="store.css">
</head>
<body>
<main class="page">
    <div class="toolbar">
        <a class="button button-secondary" href="CustomerHomeUI.jsp">‹ Trang chủ</a>
        <a href="LoginUI.jsp">Đã có tài khoản? Đăng nhập</a>
    </div>
    <h1 class="page-title">Đăng ký thành viên</h1>
    <% if (error != null) { %>
        <div class="notice notice-error" role="alert"><%= html(error) %></div>
    <% } %>
    <form class="account-form" method="post" action="RegisterUI.jsp">
        <label class="field">
            <span>Họ và tên</span>
            <input name="fullname" autocomplete="name" required>
        </label>
        <label class="field">
            <span>Ngày sinh</span>
            <input name="dob" type="date" required>
        </label>
        <label class="field">
            <span>Tên đăng nhập</span>
            <input name="username" autocomplete="username" minlength="3" required>
        </label>
        <label class="field">
            <span>Mật khẩu (ít nhất 8 ký tự)</span>
            <input name="password" type="password" autocomplete="new-password" minlength="8" required>
        </label>
        <label class="field">
            <span>Email</span>
            <input name="email" type="email" autocomplete="email" required>
        </label>
        <label class="field">
            <span>Số điện thoại</span>
            <input name="phone" type="tel" autocomplete="tel" required>
        </label>
        <label class="field">
            <span>Số nhà</span>
            <input name="houseNumber" autocomplete="address-line1" required>
        </label>
        <label class="field">
            <span>Đường</span>
            <input name="street" required>
        </label>
        <label class="field">
            <span>Phường / xã</span>
            <input name="ward" required>
        </label>
        <label class="field">
            <span>Tỉnh / thành phố</span>
            <input name="city" autocomplete="address-level1" required>
        </label>
        <div class="field field-wide">
            <button type="submit">Tạo tài khoản</button>
        </div>
    </form>
</main>
</body>
</html>

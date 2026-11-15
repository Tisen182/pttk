<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="_common.jspf" %>
<%
    Customer4 customer = session.getAttribute("customer") instanceof Customer4
            ? (Customer4) session.getAttribute("customer") : null;
    Cart4 cart = session.getAttribute("cart") instanceof Cart4
            ? (Cart4) session.getAttribute("cart") : null;
    int itemCount = 0;
    if (cart != null) {
        for (model.CartDetails4 detail : cart.getCartDetails()) {
            itemCount += detail.getQuantity();
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Cửa hàng bách hóa</title>
    <link rel="stylesheet" href="store.css">
</head>
<body>
<main class="page home-page">
    <h1 class="page-title">Cửa hàng bách hóa</h1>
    <div class="greeting">
        <% if (customer != null) { %>
            Xin chào <strong><%= html(customer.getFullname()) %></strong>
            (<%= html(customer.getPhone()) %>)!<br>
            Thành viên thân thiết
        <% } else { %>
            Xin chào quý khách!<br>
            Chào mừng bạn đến với cửa hàng bách hóa.
        <% } %>
    </div>
    <nav class="home-actions" aria-label="Chức năng khách hàng">
        <a class="button" href="ItemSearchUI.jsp">Tìm kiếm mặt hàng</a>
        <a class="button" href="CartUI.jsp">
            Đặt hàng / Xem giỏ hàng<% if (itemCount > 0) { %> (<%= itemCount %>)<% } %>
        </a>
    </nav>
    <div class="toolbar" style="margin-top: 36px">
        <% if (customer == null) { %>
            <a href="LoginUI.jsp">Đăng nhập</a>
            <a href="RegisterUI.jsp">Đăng ký thành viên</a>
        <% } else { %>
            <span class="muted">Tài khoản: <%= html(customer.getUsername()) %></span>
            <a href="LoginUI.jsp?action=logout">Đăng xuất</a>
        <% } %>
    </div>
</main>
</body>
</html>

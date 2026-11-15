<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="_common.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    if ("logout".equals(request.getParameter("action"))) {
        session.removeAttribute("customer");
        response.sendRedirect("CustomerHomeUI.jsp");
        return;
    }

    String error = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        try (Connection connection = openStoreConnection()) {
            Customer4 customer = new CustomerDAO(connection).authenticate(username, password);
            if (customer == null) {
                error = "Tên đăng nhập hoặc mật khẩu không chính xác.";
            } else {
                session.setAttribute("customer", customer);
                if (session.getAttribute("cart") instanceof Cart4) {
                    ((Cart4) session.getAttribute("cart")).setCustomer(customer);
                }
                response.sendRedirect("CustomerHomeUI.jsp");
                return;
            }
        } catch (NamingException | SQLException exception) {
            application.log("Customer login failed.", exception);
            response.setStatus(503);
            error = "Hiện chưa thể đăng nhập. Vui lòng thử lại sau.";
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng nhập</title>
    <link rel="stylesheet" href="store.css">
</head>
<body>
<main class="page">
    <div class="toolbar">
        <a class="button button-secondary" href="CustomerHomeUI.jsp">‹ Trang chủ</a>
        <a href="RegisterUI.jsp">Tạo tài khoản mới</a>
    </div>
    <h1 class="page-title">Đăng nhập thành viên</h1>
    <% if (error != null) { %>
        <div class="notice notice-error" role="alert"><%= html(error) %></div>
    <% } %>
    <form class="account-form" method="post" action="LoginUI.jsp">
        <label class="field field-wide">
            <span>Tên đăng nhập</span>
            <input name="username" autocomplete="username" required>
        </label>
        <label class="field field-wide">
            <span>Mật khẩu</span>
            <input name="password" type="password" autocomplete="current-password" required>
        </label>
        <div class="field field-wide">
            <button type="submit">Đăng nhập</button>
        </div>
    </form>
</main>
</body>
</html>

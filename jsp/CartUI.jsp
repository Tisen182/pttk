<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="_common.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    Cart4 cart = session.getAttribute("cart") instanceof Cart4
            ? (Cart4) session.getAttribute("cart") : new Cart4();
    Customer4 customer = session.getAttribute("customer") instanceof Customer4
            ? (Customer4) session.getAttribute("customer") : null;
    cart.setCustomer(customer);
    String error = null;
    String success = (String) session.getAttribute("orderSuccess");
    session.removeAttribute("orderSuccess");

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String action = request.getParameter("action");
        try {
            if ("quantity".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                try (Connection connection = openStoreConnection()) {
                    if (!new CartDAO(connection).updateQuantity(cart, productId, quantity)) {
                        error = "Không tìm thấy sản phẩm trong giỏ hàng.";
                    }
                }
                if (error != null) {
                    throw new IllegalArgumentException(error);
                }
                session.setAttribute("cart", cart);
                response.sendRedirect("CartUI.jsp");
                return;
            } else if ("remove".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                cart.removeProduct(productId);
                session.setAttribute("cart", cart);
                response.sendRedirect("CartUI.jsp");
                return;
            } else if ("submit".equals(action)) {
                if (customer == null) {
                    error = "Vui lòng đăng nhập hoặc đăng ký trước khi đặt hàng.";
                } else if (customer.getAddress() == null || customer.getAddress().getId() <= 0) {
                    error = "Tài khoản chưa có địa chỉ nhận hàng. Vui lòng cập nhật thông tin tài khoản.";
                } else if (cart.getCartDetails().isEmpty()) {
                    error = "Giỏ hàng đang trống.";
                } else {
                    String orderCode = "DH-" + UUID.randomUUID().toString()
                            .replace("-", "").substring(0, 10).toUpperCase(Locale.ROOT);
                    Receipt4 receipt = Receipt4.fromCart(cart, orderCode, LocalDate.now(),
                            "Thanh toán khi nhận hàng", customer.getAddress());
                    try (Connection connection = openStoreConnection()) {
                        new ReceiptDAO(connection).saveOrder(receipt);
                    }
                    session.removeAttribute("cart");
                    session.setAttribute("orderSuccess", orderCode);
                    response.sendRedirect("CartUI.jsp");
                    return;
                }
            }
        } catch (IllegalArgumentException exception) {
            error = exception.getMessage() == null
                    ? "Thông tin giỏ hàng không hợp lệ." : exception.getMessage();
        } catch (NamingException | SQLException exception) {
            application.log("Could not save the customer order.", exception);
            response.setStatus(503);
            error = "quantity".equals(action)
                    ? "Không thể cập nhật giỏ hàng lúc này. Vui lòng thử lại sau."
                    : "Không thể lưu đơn hàng lúc này. Vui lòng kiểm tra tồn kho và thử lại.";
        }
    }

    float total = cart.recalculateTotal();
    int itemCount = cart.getCartDetails().size();
    String deliveryAddress = customer == null ? "" : formatAddress(customer.getAddress());
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Giỏ hàng</title>
    <link rel="stylesheet" href="store.css">
</head>
<body>
<main class="page">
    <div class="toolbar">
        <a class="button button-secondary" href="CustomerHomeUI.jsp">‹ Quay lại</a>
        <% if (customer == null) { %>
            <a href="LoginUI.jsp">Đăng nhập để đặt hàng</a>
        <% } else { %>
            <span><strong>Họ tên:</strong> <%= html(customer.getFullname()) %>
                &nbsp; <strong>SĐT:</strong> <%= html(customer.getPhone()) %></span>
        <% } %>
    </div>
    <h1 class="page-title">Giỏ hàng</h1>

    <% if (success != null) { %>
        <div class="notice" role="status">
            Lưu đơn hàng thành công! Mã đơn hàng của bạn là
            <strong><%= html(success) %></strong>. Nhân viên sẽ sớm xác nhận đơn hàng.
        </div>
    <% } %>
    <% if (error != null) { %>
        <div class="notice notice-error" role="alert"><%= html(error) %></div>
    <% } %>

    <% if (customer != null) { %>
        <p><strong>Địa chỉ nhận hàng:</strong>
            <%= deliveryAddress.isEmpty() ? "Chưa cập nhật" : html(deliveryAddress) %>
        </p>
    <% } %>
    <p class="section-label">Các mặt hàng đã chọn:</p>

    <% if (itemCount == 0) { %>
        <p class="notice">Giỏ hàng của bạn chưa có sản phẩm nào.</p>
        <a class="button" href="ItemSearchUI.jsp">Tiếp tục mua hàng</a>
    <% } else { %>
        <div class="table-wrap">
            <table>
                <thead>
                <tr>
                    <th scope="col">STT</th>
                    <th scope="col">Mã SP</th>
                    <th scope="col">Tên SP</th>
                    <th scope="col">Đơn giá</th>
                    <th scope="col">Số lượng</th>
                    <th scope="col">Tổng</th>
                    <th scope="col">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <% int row = 0;
                   for (models.CartDetails4 detail : cart.getCartDetails()) {
                       Product4 product = detail.getProduct();
                       row++; %>
                    <tr>
                        <td><%= row %></td>
                        <td><%= html(product.getProductCode()) %></td>
                        <td><%= html(product.getProductName()) %></td>
                        <td><%= money(product.getUnitPrice()) %></td>
                        <td>
                            <form method="post" action="CartUI.jsp" class="quantity-controls">
                                <input type="hidden" name="action" value="quantity">
                                <input type="hidden" name="productId" value="<%= product.getId() %>">
                                <button type="submit" name="quantity"
                                        value="<%= detail.getQuantity() - 1 %>"
                                        <%= detail.getQuantity() <= 1 ? "disabled" : "" %>
                                        aria-label="Giảm số lượng">−</button>
                                <span><%= detail.getQuantity() %></span>
                                <button type="submit" name="quantity"
                                        value="<%= detail.getQuantity() + 1 %>"
                                        <%= detail.getQuantity() >= product.getStockQuantity()
                                                ? "disabled" : "" %>
                                        aria-label="Tăng số lượng">+</button>
                            </form>
                        </td>
                        <td><strong><%= money(detail.getSubtotal()) %></strong></td>
                        <td>
                            <form method="post" action="CartUI.jsp">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="productId" value="<%= product.getId() %>">
                                <button class="button-secondary" type="submit">Xóa</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <p class="cart-summary">Tổng cộng: <span class="price"><%= money(total) %></span></p>
        <div class="cart-actions">
            <a class="button button-secondary" href="ItemSearchUI.jsp">Tiếp tục mua hàng</a>
            <% if (customer == null) { %>
                <a class="button button-green" href="LoginUI.jsp">Đăng nhập để đặt hàng</a>
                <a class="button button-secondary" href="RegisterUI.jsp">Đăng ký</a>
            <% } else { %>
                <form method="post" action="CartUI.jsp">
                    <input type="hidden" name="action" value="submit">
                    <button class="button-green" type="submit">Lưu giỏ hàng / Đặt hàng</button>
                </form>
            <% } %>
        </div>
    <% } %>
</main>
</body>
</html>

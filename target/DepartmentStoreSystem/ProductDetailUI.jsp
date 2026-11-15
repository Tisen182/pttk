<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="_common.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    Product4 product = null;
    String error = null;
    String idValue = request.getParameter("id");
    boolean addingToCart = "POST".equalsIgnoreCase(request.getMethod())
            && "add".equals(request.getParameter("action"));

    try {
        int productId = Integer.parseInt(idValue == null ? "" : idValue);
        try (Connection connection = openStoreConnection()) {
            product = new ProductDAO(connection).getProductById(productId);
            if (product == null) {
                error = "Không tìm thấy sản phẩm này.";
            } else if (addingToCart) {
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                Cart4 cart = session.getAttribute("cart") instanceof Cart4
                        ? (Cart4) session.getAttribute("cart")
                        : new Cart4(0, "C-" + UUID.randomUUID(), null);
                Customer4 customer = session.getAttribute("customer") instanceof Customer4
                        ? (Customer4) session.getAttribute("customer") : null;
                cart.setCustomer(customer);
                if (!new CartDAO(connection).addItemToCart(cart, productId, quantity)) {
                    error = "Không tìm thấy sản phẩm này.";
                } else {
                    session.setAttribute("cart", cart);
                    response.sendRedirect("CartUI.jsp");
                    return;
                }
            }
        }
    } catch (NumberFormatException exception) {
        error = "Mã sản phẩm hoặc số lượng không hợp lệ.";
    } catch (IllegalArgumentException exception) {
        error = exception.getMessage();
    } catch (NamingException | SQLException exception) {
        application.log("Could not load product details or add it to the cart.", exception);
        response.setStatus(503);
        error = "Hiện chưa thể tải hoặc thêm sản phẩm vào giỏ hàng. Vui lòng thử lại sau.";
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chi tiết sản phẩm</title>
    <link rel="stylesheet" href="store.css">
</head>
<body>
<main class="page">
    <div class="toolbar">
        <a class="button button-secondary" href="ItemSearchUI.jsp">‹ Quay lại</a>
        <a href="CartUI.jsp">Giỏ hàng</a>
    </div>
    <h1 class="page-title">Chi tiết sản phẩm</h1>
    <% if (error != null) { %>
        <div class="notice notice-error" role="alert"><%= html(error) %></div>
    <% } else if (product != null) { %>
        <section class="detail-layout">
            <div class="product-photo" role="img" aria-label="Ảnh sản phẩm">Ảnh sản phẩm</div>
            <div class="detail-info">
                <p><strong>Mã SP:</strong> <%= html(product.getProductCode()) %></p>
                <h2><%= html(product.getProductName()) %></h2>
                <p class="price"><%= money(product.getUnitPrice()) %></p>
                <p>Số lượng trong kho: <strong><%= product.getStockQuantity() %></strong></p>
                <p><strong>Mô tả:</strong><br>
                    <%= product.getDescription() == null || product.getDescription().trim().isEmpty()
                            ? "Chưa có mô tả cho sản phẩm này."
                            : html(product.getDescription()) %>
                </p>
                <% if (product.getStockQuantity() > 0) { %>
                    <form method="post" action="ProductDetailUI.jsp">
                        <input type="hidden" name="id" value="<%= product.getId() %>">
                        <input type="hidden" name="action" value="add">
                        <label for="quantity">Số lượng:</label>
                        <div class="quantity-controls">
                            <input id="quantity" name="quantity" type="number" min="1"
                                   max="<%= product.getStockQuantity() %>" value="1" required>
                            <button class="button-yellow" type="submit">Thêm vào giỏ hàng</button>
                        </div>
                    </form>
                <% } else { %>
                    <p class="notice">Sản phẩm hiện đã hết hàng.</p>
                <% } %>
            </div>
        </section>
    <% } %>
</main>
</body>
</html>

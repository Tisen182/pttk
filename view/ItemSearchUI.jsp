<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="_common.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    String keyword = request.getParameter("keyword");
    Product4[] products = new Product4[0];
    String error = null;
    if (keyword != null && !keyword.trim().isEmpty()) {
        try (Connection connection = openStoreConnection()) {
            products = new ProductDAO(connection).searchProductByName(keyword);
        } catch (NamingException | SQLException exception) {
            application.log("Product search failed.", exception);
            response.setStatus(503);
            error = "Hiện chưa thể tìm kiếm sản phẩm. Vui lòng thử lại sau.";
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Tìm kiếm sản phẩm</title>
    <link rel="stylesheet" href="store.css">
</head>
<body>
<main class="page">
    <div class="toolbar">
        <a class="button button-secondary" href="CustomerHomeUI.jsp">‹ Quay lại</a>
        <a href="CartUI.jsp">Giỏ hàng</a>
    </div>
    <h1 class="page-title">Tìm kiếm sản phẩm</h1>
    <form class="search-form" method="get" action="ItemSearchUI.jsp">
        <label for="keyword">Nhập từ khóa:</label>
        <input id="keyword" name="keyword" type="search" value="<%= html(keyword) %>"
               placeholder="Tên mặt hàng cần tìm" required>
        <button type="submit">Tìm kiếm</button>
    </form>

    <% if (error != null) { %>
        <div class="notice notice-error" role="alert"><%= html(error) %></div>
    <% } else if (keyword != null && !keyword.trim().isEmpty()) { %>
        <p class="section-label">Kết quả tìm kiếm: “<%= html(keyword.trim()) %>”</p>
        <% if (products.length == 0) { %>
            <p class="notice">Không tìm thấy sản phẩm phù hợp.</p>
        <% } else { %>
            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th scope="col">STT</th>
                        <th scope="col">Ảnh</th>
                        <th scope="col">Mã SP</th>
                        <th scope="col">Tên SP</th>
                        <th scope="col">Giá bán</th>
                        <th scope="col">Chi tiết</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (int i = 0; i < products.length; i++) {
                        Product4 product = products[i]; %>
                        <tr>
                            <td><%= i + 1 %></td>
                            <td><div class="product-thumb" aria-label="Ảnh sản phẩm">▧</div></td>
                            <td><%= html(product.getProductCode()) %></td>
                            <td><%= html(product.getProductName()) %></td>
                            <td class="price"><%= money(product.getUnitPrice()) %></td>
                            <td><a href="ProductDetailUI.jsp?id=<%= product.getId() %>">Xem chi tiết</a></td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    <% } %>
</main>
</body>
</html>

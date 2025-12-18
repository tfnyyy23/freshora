<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, models.Product" %>

<%
    List<Product> products = (List<Product>) request.getAttribute("products");
%>

<%
if (products != null && !products.isEmpty()) {
    for (Product p : products) {
        request.setAttribute("product", p);
%>
    <div class="col-md-3 col-6">
        <jsp:include page="productCard.jsp" />
    </div>
<%
    }
} else {
%>
    <div class="col-12 text-center text-muted py-5">
        Produk tidak tersedia
    </div>
<%
}
%>

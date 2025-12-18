<%@ page import="models.Product" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.*" %>

<link rel="stylesheet" href="assets/css/productcard.css">
<link
  href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
  rel="stylesheet"
/>

<%
    // Mengambil objek produk yang dikirim dari dashboard
    Product p = (Product) request.getAttribute("product");
    boolean outOfStock = p.getStock() <= 0;

    String img = p.getImage();
    // Logika pengecekan apakah gambar dari URL atau file lokal
    boolean isUrl = img != null && (img.startsWith("http://") || img.startsWith("https://"));
%>

<div class="product-card <%= outOfStock ? "out-of-stock" : "" %>">
    <a href="${pageContext.request.contextPath}/detail?id=<%= p.getProductId() %>" class="text-decoration-none">
        <div class="product-image" style="position: relative;">
            <img src="<%= isUrl ? img : request.getContextPath() + "/assets/img/" + img %>"
                 alt="<%= p.getName() %>">

            <% if (outOfStock) { %>
                <div style="
                    position:absolute;
                    inset:0;
                    background:rgba(0,0,0,.6);
                    display:flex;
                    align-items:center;
                    justify-content:center;
                    color:white;
                    font-weight:600;">
                    Stok Habis
                </div>
            <% } %>
        </div>
    </a>

    <div class="product-body">
        <a href="${pageContext.request.contextPath}/detail?id=<%= p.getProductId() %>" class="text-decoration-none text-dark">
            <div class="product-title" ><%= p.getName() %></div>
        </a>

        <%
            NumberFormat rupiah = NumberFormat.getInstance(new Locale("id", "ID"));
        %>

        <p class="product-price" >
            Rp <%= rupiah.format(p.getPrice()) %>
        </p>

        <div class="product-rating" >
            <i class="bi bi-star-fill" style="color: #ffc107;"></i>
            <%= p.getRating() %> / 5
        </div>
        
        <% if (outOfStock) { %>
            <button  class="btn btn-secondary btn-sm w-100" disabled>
                Stok Habis
            </button>
        <% } else { %>
            <button type="button"
                    class="btn btn-tambah btn-sm w-100 add-to-cart"
                    
                    data-product-id="<%= p.getProductId() %>">
                <i class="bi bi-plus-lg me-1"></i> Tambah
            </button>
            
        <% } %>
    </div>
</div>

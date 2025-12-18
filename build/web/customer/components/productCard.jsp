<%@ page import="models.Product" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.*" %>

<link rel="stylesheet" href="assets/css/productcard.css">
<link
  href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
  rel="stylesheet"
/>


<%
    Product p = (Product) request.getAttribute("product");
    boolean outOfStock = p.getStock() <= 0;

    String img = p.getImage();
    boolean isUrl = img != null && (img.startsWith("http://") || img.startsWith("https://"));
%>

<div class="product-card <%= outOfStock ? "out-of-stock" : "" %>">
    <div class="product-image">
        <img src="<%= isUrl ? img : "../assets/img/" + img %>"
             alt="<%= p.getName() %>">

        <% if (p.getStock() == 0) { %>
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

    <div class="product-body">
        <div class="product-title"><%= p.getName() %></div>

        <%
            NumberFormat rupiah = NumberFormat.getInstance(new Locale("id", "ID"));
        %>

        <p class="product-price">
            Rp <%= rupiah.format(p.getPrice()) %>
        </p>

        <div class="product-rating">
            <i class="bi bi-star-fill"></i>
            <%= p.getRating() %> / 5
        </div>
        
        <% if (outOfStock) { %>
            <button style="border-radius: 8px;" class="btn btn-secondary btn-sm w-100" disabled>
                Stok Habis
            </button>
        <% } else { %>
            <a href="#"
               data-product-id="<%= p.getProductId() %>" 
               class="btn btn-tambah btn-sm w-100 add-to-cart"
               <%= p.getStock() == 0 ? "disabled" : "" %>>
               <i class="bi bi-plus-lg me-1"></i> Tambah
            </a>
        <% } %>
    </div>
</div>

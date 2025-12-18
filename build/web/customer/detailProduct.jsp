<%-- 
    Document   : detail-product
    Created on : 9 Des 2025, 00.24.27
    Author     : ASUS
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, java.text.NumberFormat, java.util.Locale" %>
<%
    // Ambil data dari ProductDetailServlet
    Map<String, Object> product = (Map<String, Object>) request.getAttribute("product");
    String categoryName = (String) request.getAttribute("categoryName");

    if (product == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    String img = (String) product.get("image");
    boolean isUrl = img != null && (img.startsWith("http://") || img.startsWith("https://"));
    
    // Format Harga ke Rupiah
    NumberFormat rupiah = NumberFormat.getInstance(new Locale("id", "ID"));
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= product.get("name") %> - Freshora</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/global.css">
    <style>
        body { background-color: #f8f9fa; }
        .product-img {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 15px;
        }
        .btn-tambah {
            background-color: #16a34a;
            color: white;
            border: none;
            border-radius: 15px;
            padding: 12px;
            font-weight: bold;
        }
        .btn-tambah:hover {
            background-color: #15803d;
            color: white;
        }
        .category-badge {
            background-color: #dcfce7;
            color: #16a34a;
            font-weight: 600;
            padding: 5px 15px;
            border-radius: 50px;
            display: inline-block;
        }
    </style>
</head>
<body>

    <!-- HEADER -->
        <nav class="navbar bg-white shadow-sm sticky-top">
            <div class="container">
                <a href="<%= request.getContextPath() %>/CustomerServlet"
                   class="text-decoration-none text-dark d-inline-flex align-items-center">
                    <i " class="bi bi-arrow-left-short fs-3"></i>
                    <span>Kembali</span>
                </a>
                   
                <a href="<%= request.getContextPath() %>/CartServlet" class="btn position-relative">
                    <i class="bi bi-cart fs-4"></i>
                    <span style="position: absolute; top: 5px; transform: none" class="badge rounded-pill bg-danger pt-1">
                        ${sessionScope.cartCount == null ? 0 : sessionScope.cartCount}
                    </span>
                </a> 
            </div>
        </nav>

    <div class="container py-5">
        <div class="card border-0 shadow-sm p-4" style="border-radius: 20px;">
            <div class="row g-5">
                
                <div class="col-md-6">
                    <img src="<%= isUrl ? img : request.getContextPath() + "/assets/img/" + img %>" 
                         class="product-img shadow-sm" alt="<%= product.get("name") %>">
                </div>

                <div class="col-md-6  flex-column justify-content-center">
                    <div class="category-badge mb-2">
                        <%= categoryName %>
                    </div>
                    
                    <h3 class="fw-bold mb-2"><%= product.get("name") %></h3>
                    
                    <%
                        // Mengambil nilai rating dari Map dan mengonversinya ke double
                        double ratingValue = 0.0;
                        Object ratingObj = product.get("rating");
                        if (ratingObj instanceof Double) {
                            ratingValue = (Double) ratingObj;
                        } else if (ratingObj instanceof Float) {
                            ratingValue = ((Float) ratingObj).doubleValue();
                        } else if (ratingObj instanceof Integer) {
                            ratingValue = ((Integer) ratingObj).doubleValue();
                        }

                        int fullStars = (int) ratingValue;
                        boolean hasHalfStar = (ratingValue - fullStars) >= 0.5;
                        int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
                    %>

                    <div class="d-flex align-items-center mb-3">
                        <div class="text-warning me-2">
                            <%-- Bintang Penuh --%>
                            <% for (int i = 0; i < fullStars; i++) { %>
                                <i class="bi bi-star-fill"></i>
                            <% } %>

                            <%-- Setengah Bintang --%>
                            <% if (hasHalfStar) { %>
                                <i class="bi bi-star-half"></i>
                            <% } %>

                            <%-- Bintang Kosong (Opsional, agar tetap ada 5 siluet bintang) --%>
                            <% for (int i = 0; i < emptyStars; i++) { %>
                                <i class="bi bi-star text-muted"></i>
                            <% } %>
                        </div>

                        <span style="font-weight: 200px;"><%= ratingValue %></span>
                        <span class="text-muted ms-1">/ 5</span>
                    </div>

                    <h5 style="color:#16a34a;" class=" fw-normal mb-4">
                        Rp <%= rupiah.format(product.get("price")) %>
                    </h5>

                    <div class="mb-4">
                        <h6 class="fw-bold">Deskripsi Produk</h6>
                        <p class="text-muted">
                            <%= product.get("description") %>
                        </p>
                    </div>

                    <div class="mb-5">
                        <h6 class="fw-bold">Stok Tersedia</h6>
                        <p class="mb-0"><%= product.get("stock") %> item</p>
                    </div>

                    <div class="d-grid gap-2">
                        <form action="<%= request.getContextPath() %>/CartServlet" method="GET">
                            <input type="hidden" name="add" value="<%= product.get("product_id") %>">
                            <button type="submit" class="btn btn-tambah w-100 py-3 shadow-sm" 
                                <%= (Integer)product.get("stock") <= 0 ? "disabled" : "" %>>
                                <i class="bi bi-cart fs-4 me-2 "></i> Tambah ke Keranjang
                            </button>
                        </form>
                        
                        <a href="dashboard.jsp" class="btn btn-outline-secondary py-3 mt-2" style="border-radius: 15px;">
                            Kembali ke Dashboard
                        </a>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
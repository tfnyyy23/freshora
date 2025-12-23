<%-- 
    Document   : detail-product
    Created on : 9 Des 2025, 00.24.27
    Author     : ASUS
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, java.text.NumberFormat, java.util.Locale" %>
<%
    Map<String, Object> product = (Map<String, Object>) request.getAttribute("product");
    String categoryName = (String) request.getAttribute("categoryName");

    if (product == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    String img = (String) product.get("image");
    boolean isUrl = img != null && (img.startsWith("http://") || img.startsWith("https://"));
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
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logoFreshora1031.png">
    <style>
        body { background-color: #f8f9fa; }
        .product-img {
            width: 100%;
            height: auto;
            max-height: 500px;
            object-fit: cover;
            border-radius: 15px;
        }
        .btn-custom {
            border-radius: 10px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            width: 100%; 
        }
        .btn-tambah {
            background-color: #16a34a;
            color: white;
            border: none;
        }
        .btn-tambah:hover {
            background-color: #15803d;
            color: white;
        }
        .category-badge {
            background-color: #dcfce7;
            color: #16a34a;
            font-weight: 500;
            padding: 5px 15px;
            border-radius: 50px;
            display: inline-block;
        }
        
        #cartToast {
            background-color: #f0fdf4;
            border: 1px solid #16a34a !important;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            min-width: 300px;
        }

        #cartToast .toast-body {
            color: #166534;
            font-weight: 500;
            display: flex;
            align-items: center;
            padding: 12px 16px;
        }

        #cartToast .bi-check-circle-fill {
            color: #22c55e;
            font-size: 1.2rem;
            margin-right: 12px;
        }
        
        /* Responsivitas untuk layar komputer */
        @media (min-width: 768px) {
            .btn-custom {
                width: 100%;
            }
        }
    </style>
</head>
<body>

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

    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-12 col-lg-10">
                <div class="card border-0 shadow-sm overflow-hidden" style="border-radius: 20px;">
                    <div class="row g-0">
                        
                        <div class="col-md-5">
                            <img src="<%= isUrl ? img : request.getContextPath() + "/assets/img/" + img %>" 
                                 class="product-img h-100" alt="<%= product.get("name") %>">
                        </div>

                        <div class="col-md-7 p-4 p-lg-5">
                            <div class="category-badge mb-3">
                                <%= categoryName %>
                            </div>
                            
                            <h2 class="mb-3 fw-bold text-dark"><%= product.get("name") %></h2>
                            
                            <%
                                double ratingValue = 0.0;
                                Object ratingObj = product.get("rating");
                                if (ratingObj instanceof Number) {
                                    ratingValue = ((Number) ratingObj).doubleValue();
                                }
                                int fullStars = (int) ratingValue;
                                boolean hasHalfStar = (ratingValue - fullStars) >= 0.5;
                            %>

                            <div class="d-flex align-items-center mb-3">
                                <div class="text-warning me-2 fs-5">
                                    <% for (int i = 0; i < fullStars; i++) { %> <i class="bi bi-star-fill"></i> <% } %>
                                    <% if (hasHalfStar) { %> <i class="bi bi-star-half"></i> <% } %>
                                    <% for (int i = 0; i < (5 - fullStars - (hasHalfStar ? 1 : 0)); i++) { %> <i class="bi bi-star text-muted"></i> <% } %>
                                </div>
                                <span class="fw-bold"><%= String.format("%.1f", ratingValue) %></span>
                                <span class="text-muted ms-1">/ 5</span>
                            </div>

                            <h3 class="fw-normal mb-4" style="color: #16a34a;">
                                Rp <%= rupiah.format(product.get("price")) %>
                            </h3>

                            <div class="mb-4">
                                <h6 class="fw-bold">Deskripsi Produk</h6>
                                <p class="text-muted"><%= product.get("description") %></p>
                            </div>

                            <div class="mb-4">
                                <h6 class="fw-bold">Stok Tersedia</h6>
                                <p class="text-muted"><%= product.get("stock") %> item</p>
                            </div>

                            <div class="row g-2">
                                <div class="col-12">
                                    <button type="button"
                                            class="btn btn-tambah btn-custom shadow-sm w-100"
                                            onclick="addToCart(<%= product.get("product_id")%>, '<%= product.get("name") %>')"
                                            <%= (Integer)product.get("stock") <= 0 ? "disabled" : "" %>>
                                        <i class="bi bi-cart-plus me-2 fs-5"></i> Tambah ke Keranjang
                                    </button>
                                </div>
                                <div class="col-12">
                                    <a href="<%= request.getContextPath() %>/CustomerServlet" 
                                       class="btn btn-outline-secondary btn-custom w-100">
                                        Kembali ke Dashboard
                                    </a>
                                </div>
                            </div>
                        </div> </div>
                </div>
            </div>
        </div>
    </div>

    <div class="toast-container position-fixed top-0 start-50 translate-middle-x p-3" style="z-index: 1060;">
        <div id="cartToast" class="toast align-items-center border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="bi bi-check-circle-fill"></i>
                    <span id="toastMessage">Produk ditambahkan ke keranjang</span>
                </div>
                <button type="button" class="btn-close me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function addToCart(productId, productName) {
            fetch("<%= request.getContextPath() %>/CartServlet?add=" + productId, {
                method: "GET",
                headers: { "X-Requested-With": "XMLHttpRequest" }
            })
            .then(res => res.json())
            .then(data => {
                // 1. Update Badge Keranjang
                document.querySelector(".badge.bg-danger").innerText = data.cartCount;

                // 2. Update Pesan Toast dengan Nama Produk
                document.getElementById('toastMessage').innerText = productName + " ditambahkan ke keranjang";

                // 3. Tampilkan Toast
                const toastEl = document.getElementById('cartToast');
                const toast = new bootstrap.Toast(toastEl, { delay: 3000 });
                toast.show();
            })
            .catch(err => console.error(err));
        }
    </script>
</body>
</html>
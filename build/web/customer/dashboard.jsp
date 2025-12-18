<%-- 
    Document   : dashboard
    Created on : 9 Des 2025, 00.24.15
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, models.Product, models.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Product> products = (List<Product>) request.getAttribute("products");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Customer Dashboard</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/dashboard.css">

        <style>
            body { background: #f9fafb; }

            .promo-slider {
                display: flex;
                gap: 15px;
                overflow-x: auto;
                scroll-snap-type: x mandatory;
            }

            .promo-card {
                min-width: 30%;
                max-width: 420px;
                height: 150px;
                color: white;
                border-radius: 16px;
                padding: 24px;
                flex-shrink: 0;
            }
        </style>
    </head>

    <body>

        <!-- ================= HEADER ================= -->
        <nav class="navbar bg-white shadow-sm sticky-top px-5">
            <div class="container d-flex justify-content-between align-items-center">

                <div class="d-flex align-items-center gap-2">
                    <img src="assets/img/logoFreshora1031.png" width="36" alt="Freshora Logo">
                    <span class="fw-bold text-primary-custom fs-4">Freshora</span>
                </div>

                <div class="d-flex align-items-center gap-3">
                    <a href="<%= request.getContextPath() %>/CartServlet" class="btn position-relative">
                        <i class="bi bi-cart fs-4"></i>
                        <span style="position: absolute; top: 5px; transform: none" class="badge rounded-pill bg-danger pt-1">
                            ${sessionScope.cartCount == null ? 0 : sessionScope.cartCount}
                        </span>
                    </a> 

                    <a href="profile.jsp" class="btn">
                        <i class="bi bi-person fs-3"></i>
                    </a>
                </div>
            </div>
        </nav>

        <div class="container py-4">

            <!-- ================= USER INFO ================= -->
            <div style="border-radius: 10px;" class="bg-white shadow-sm p-3 mb-2 d-flex align-items-center gap-3">
                <div class="avatar-circle">
                    <i class="bi bi-person"></i>
                </div>
                <div>
                    <h6 class="mb-0">Halo, <%= user.getUsername() %> 👋</h6>
                    <small class="text-muted">📍 <%= user.getAddress() %></small>
                </div>
            </div>

            <!-- ================= PROMO SLIDER ================= -->
            <div class="container my-5">
                <div class="promo-scroll d-flex" id="promoScroll">

                    <div class="promo-card" style="background: linear-gradient(to right, #22C55E, #10B981);">
                        <h4>Diskon Sayur 30%</h4>
                        <p>Hemat hingga 30% untuk semua sayuran segar</p>
                    </div>

                    <div class="promo-card" style="background: linear-gradient(to right, #3B82F6, #06B6D4);">
                        <h4>Gratis Ongkir</h4>
                        <p>Belanja minimal Rp 100.000 gratis ongkir</p>
                    </div>

                    <div class="promo-card" style="background: linear-gradient(to right, #F97316, #EF4444);">
                        <h4>Paket Hemat Keluarga</h4>
                        <p>Paket lengkap sayur & buah hanya Rp 99.000</p>
                    </div>

                </div>

                <!-- DOT -->
                <div class="text-center mt-3">
                    <span class="dot active"></span>
                    <span class="dot"></span>
                    <span class="dot"></span>
                </div>
            </div>

            <!-- ================= SEARCH ================= -->
            <form method="get" action="CustomerServlet" class="mb-4">
                <div style="height: 45px" class="input-group">
                    <span style="border-radius: 12px 0 0 12px; height: 45px;" class="input-group-text border-end-0 bg-white">
                        <i style="color: grey;" class="bi bi-search"></i>
                    </span>
                    <input style="border-radius: 0 12px 12px 0; height: 45px;"
                           type="text"
                           name="keyword"
                           class="form-control border-start-0"
                           value="<%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : "" %>"
                           autocomplete="off"
                           placeholder="Cari produk...">
                </div>
            </form>

            <!-- ================= PRODUK TERBARU ================= -->
            <div class="d-flex justify-content-between mb-3">
                <h4>Produk Terbaru</h4>
                <a style="color: #16a34a" href="ProductServlet" class="fw-semibold  d-inline-flex align-items-center text-decoration-none">
                    <span>Lihat Semua</span>
                    <i style="color: #16a34a" class="bi bi-arrow-right-short ms-1 fs-3"></i>
                </a>
            </div>

            <div class="row g-3">
                <%
                    if (products != null && !products.isEmpty()) {
                        for (Product p : products) {
                            request.setAttribute("product", p);
                %>
                    <div class="col-md-3 col-6">
                        <jsp:include page="components/productCard.jsp" />
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
            </div>

 
        <!-- ================= AUTO SLIDER SCRIPT ================= -->
        <script>
            const promo = document.getElementById('promoScroll');
            let index = 0;

            setInterval(() => {
                index++;
                if (index >= 5) index = 0;

                promo.scrollTo({
                    left: index * 475,
                    behavior: 'smooth'
                });

                document.querySelectorAll('.dot').forEach((d, i) => {
                    d.classList.toggle('active', i === index);
                });
            }, 4000);
        </script>
        
        <!-- ================= AJAX CART COUNT ================= -->    
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                const buttons = document.querySelectorAll(".add-to-cart");
                const cartBadge = document.querySelector(".btn.position-relative .badge");

                buttons.forEach(btn => {
                    btn.addEventListener("click", function(e) {
                        e.preventDefault();
                        const productId = this.getAttribute("data-product-id");

                        fetch("<%= request.getContextPath() %>/CartServlet?add=" + productId, {
                            headers: { "X-Requested-With": "XMLHttpRequest" }
                        })

                        .then(res => res.json())
                        .then(data => {
                            cartBadge.textContent = data.cartCount;
                        })
                        .catch(err => console.error(err));
                    });
                });
            });
        </script>

    </body>
</html>


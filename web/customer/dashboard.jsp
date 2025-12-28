<%-- 
    Document   : dashboard
    Created on : 9 Des 2025, 00.24.15
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, models.Product, models.User" %>

<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("../login.jsp");
    }
    
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
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logoFreshora1031.png">
    </head>

    <body>

        <!-- ================= HEADER ================= -->
        <nav class="navbar bg-white shadow-sm sticky-top px-5">
            <div class="container d-flex justify-content-between align-items-center">

                <div class="d-flex align-items-center gap-2">
                    <img src="assets/img/logoFreshora1031.png" width="36" alt="Freshora Logo">
                    <span class="fw-bold text-primary-custom fs-4" style="color: #16a34a;">Freshora</span>
                </div>

                <div class="d-flex align-items-center gap-3">
                    <a href="<%= request.getContextPath() %>/CartServlet" class="btn position-relative">
                        <i class="bi bi-cart fs-4"></i>
                        <span style="position: absolute; top: 5px; transform: none" class="badge rounded-pill bg-danger pt-1">
                            ${sessionScope.cartCount == null ? 0 : sessionScope.cartCount}
                        </span>
                    </a>

                    <a href="<%= request.getContextPath() %>/ProfileServlet" class="btn">
                        <i class="bi bi-person fs-3"></i>
                    </a>
                </div>
            </div>
        </nav>

        <div class="container py-4">

            <!-- ================= USER INFO ================= -->
            <div style="border-radius: 10px;" class="bg-white shadow-sm p-3 mb-2 d-flex align-items-center gap-3">
                <div class="avatar-placeholder">
                    <% 
                        String name = user.getName();
                        String initials = "";
                        if (name != null && !name.isEmpty()) {
                            String[] words = name.split("\\s+"); // Memecah berdasarkan spasi
                            for (int i = 0; i < Math.min(words.length, 2); i++) { // Ambil maksimal 2 kata
                                if (!words[i].isEmpty()) {
                                    initials += words[i].charAt(0);
                                }
                            }
                        }
                    %>
                    <%= initials.toUpperCase() %>
                </div>
                <div>
                    <h6 class="mb-0">Halo, <%= user.getUsername() %> 👋</h6>
                    <small class="text-muted">📍 <%= (user.getAddress() == null || user.getAddress().trim().isEmpty() || user.getAddress().equals("null")) ? "Alamat belum diisi" : user.getAddress() %></small>
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
                    
                    <div class="promo-card" style="background: linear-gradient(to right, #A855F7, #EC4899);">
                        <h4>Flash Sale Buah</h4>
                        <p>Diskon hingga 50% untuk buah-buahan impor pilihan</p>
                    </div>

                    <div class="promo-card" style="background: linear-gradient(to right, #EAB308, #F97316);">
                        <h4>Bonus Poin Member</h4>
                        <p>Dapatkan double poin untuk setiap transaksi hari ini</p>
                    </div>

                </div>

                <!-- DOT -->
                <div class="text-center mt-3">
                    <span class="dot active"></span>
                    <span class="dot"></span>
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
        </div>
            
        <div class="toast-container position-fixed top-0 start-50 translate-middle-x p-3" style="margin-top: 80px">
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

 
        <!-- ================= AUTO SLIDER SCRIPT ================= -->
        <script>
            const promo = document.getElementById('promoScroll');
            const dots = document.querySelectorAll('.dot');
            let index = 0;

            setInterval(() => {
                // Ambil semua kartu yang ada di dalam slider
                const cards = promo.querySelectorAll('.promo-card');
                const totalCards = cards.length;

                index++;
                if (index >= totalCards) index = 0;

                // Hitung lebar satu kartu + gap (asumsi gap 16px sesuai CSS promo-scroll Anda)
                // offsetWidth mengambil lebar asli kartu saat itu
                const cardWidth = cards[0].offsetWidth + 16; 

                // Geser slider
                promo.scrollTo({
                    left: index * cardWidth,
                    behavior: 'smooth'
                });

                // Update indikator titik (dots)
                dots.forEach((d, i) => {
                    d.classList.toggle('active', i === index);
                });
            }, 4000);
        </script>
    </body>
</html>


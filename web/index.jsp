<%-- 
    Document   : index
    Created on : 9 Des 2025, 00.21.43
    Author     : ASUS
--%>
<%@page import="java.sql.*"%>
<%@page import="classes.JDBC"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <title>Freshora</title>

        <!-- BOOTSTRAP -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- BOOTSTRAP ICON -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

        <!-- CSS -->
        <link rel="stylesheet" href="assets/css/index.css">

        <style>
            body {
                background: linear-gradient(to bottom, #ecfdf5, #ffffff);
            }

            .hero {
                padding: 80px 20px;
                text-align: center;
            }

            .promo-card {
                min-width: 100%;
                max-width: 420px;
                height: 180px;
                color: white;
                border-radius: 16px;
                padding: 24px;
                flex-shrink: 0;
            }

            .whatsapp-box {
                background: #22C55E;
                color: white;
                border-radius: 16px;
                padding: 32px;
            }
        </style>
    </head>

    <body>

        <!-- ================= NAVBAR ================= -->
        <nav class="navbar bg-white shadow-sm px-5 sticky-top">
            <div class="d-flex align-items-center gap-2">
                <img src="assets/img/logoFreshora1031.png" width="36">
                <span class="fw-bold text-primary-custom fs-4">Freshora</span>
            </div>
            <div class="d-flex gap-2">
                <a href="login.jsp" class="btn btn-outline-primary-custom">Login</a>
                <a href="register.jsp" class="btn btn-primary-custom">Register</a>
            </div>
        </nav>

        <!-- ================= HERO ================= -->
        <div class="hero container">
            <h2 class="text-primary-custom fw-bold mb-3">
                Freshora – Solusi Belanja Bahan Pangan Segar Langsung dari Petani & Peternak
            </h2>
            <p class="text-muted mb-4">
                Freshora memudahkan Anda mendapatkan produk segar berkualitas dengan harga terjangkau, langsung dari sumbernya.
            </p>
            <a href="register.jsp" class="btn btn-primary-custom px-4 py-2">
                Mulai Belanja Sekarang
            </a>
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

        <!-- ================= KEUNGGULAN ================= -->
        <div class="container my-5">
            <h4 class="text-center mb-4">Keunggulan Freshora</h4>
            <div class="row g-4">

                <div class="col-md-4">
                    <div class="card-custom p-4 text-center h-100">
                        <div class="mb-3 text-primary-custom fs-1">
                            <i class="bi bi-bag-check-fill"></i>
                        </div>
                        <h5>Segar & Berkualitas</h5>
                        <p class="text-muted">Produk langsung dari petani & peternak pilihan</p>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card-custom p-4 text-center h-100">
                        <div class="mb-3 text-primary-custom fs-1">
                            <i class="bi bi-star-fill"></i>
                        </div>
                        <h5>Harga Terjangkau</h5>
                        <p class="text-muted">Harga langsung dari sumber tanpa perantara</p>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card-custom p-4 text-center h-100">
                        <div class="mb-3 text-primary-custom fs-1">
                            <i class="bi bi-truck"></i>
                        </div>
                        <h5>Pengiriman Cepat</h5>
                        <p class="text-muted">Dikirim di hari yang sama untuk menjaga kesegaran</p>
                    </div>
                </div>

            </div>
        </div>

        <!-- ================= WHATSAPP ================= -->
        <div class="container my-5">
            <div class="whatsapp-box text-center">
                <i class="bi bi-whatsapp fs-1 mb-3"></i>
                <h5>Butuh Bantuan?</h5>
                <p>Hubungi kami via WhatsApp untuk informasi lebih lanjut</p>
                <a href="https://wa.me/6285702092095" target="_blank" class="btn btn-light mt-2">
                    Chat WhatsApp
                </a>
            </div>
        </div>

        <!-- ================= FOOTER ================= -->
        <footer class="bg-dark text-white py-4 mt-5">
            <div class="text-center">
                <div class="d-flex justify-content-center align-items-center gap-2 mb-2">
                    <img src="assets/img/logoFreshora1031.png" width="30">
                    <strong>Freshora</strong>
                </div>
                <small class="text-muted">
                    &copy; 2025 Freshora – Marketplace Bahan Pangan Segar
                </small>
            </div>
        </footer>

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

    </body>
</html>

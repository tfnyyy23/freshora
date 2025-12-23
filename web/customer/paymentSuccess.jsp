<%-- 
    Document   : paymentSuccess
    Created on : 22 Des 2025, 17.54.25
    Author     : ASUS
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Pembayaran Berhasil</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/global.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logoFreshora1031.png">
    <style>
        body {
            background-color: #f9fafb;
        }

        .success-toast {
            background-color: #ecfdf5;
            color: #166534;
            border: 1px solid #bbf7d0;
            border-radius: 12px;
            padding: 12px 18px;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
        }

        .success-card {
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            padding: 48px 32px;
        }

        .success-icon {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            border: 4px solid #16a34a;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 24px;
        }

        .success-icon i {
            font-size: 48px;
            color: #16a34a;
        }

        .btn-success-custom {
            background-color: #16a34a;
            border: none;
            border-radius: 12px;
            padding: 10px 28px;
            font-size: 15px;
        }

        .btn-success-custom:hover {
            background-color: #15803d;
        }
        
        #successToast {
            background-color: #f0fdf4;
            border: 1px solid #16a34a !important;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            min-width: 300px;
        }

        #successToast .toast-body {
            color: #166534;
            font-weight: 500;
            display: flex;
            align-items: center;
            padding: 12px 16px;
        }

        #successToast .bi-check-circle-fill {
            color: #22c55e;
            font-size: 1.2rem;
            margin-right: 12px;
        }
    </style>
</head>

<body>

    <!-- HEADER -->
    <nav class="navbar bg-white shadow-sm">
        <div class="container">
            <a href="<%= request.getContextPath() %>/CustomerServlet"
                class="text-decoration-none text-dark d-inline-flex align-items-center">
                <i " class="bi bi-arrow-left-short fs-3"></i>
                <span>Kembali</span>
            </a>
        </div>
    </nav>

    <!-- TOAST CONTAINER -->
<!--    <div class="toast-container position-fixed top-0 end-0 p-3">

        <div id="successToast"
             class="toast align-items-center show"
             role="alert"
             aria-live="assertive"
             aria-atomic="true"
             data-bs-delay="3000">

            <div class="toast-body d-flex align-items-center gap-2"
                 style="background:#ecfdf5; color:#166534; border-radius:12px;">
                <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                <span>Pembayaran Berhasil, Pesanan Anda Sedang Diproses</span>
            </div>

        </div>
    </div>-->
    
    <div class="toast-container position-fixed top-0 start-50 translate-middle-x p-3" style="z-index: 1060;">
        <div id="successToast" class="toast align-items-center border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="bi bi-check-circle-fill"></i>
                    <span id="toastMessage">Pembayaran Berhasil, Pesanan Anda Sedang Diproses</span>
                </div>
                <button type="button" class="btn-close me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    </div>


    <!-- CONTENT -->
    <div class="container d-flex justify-content-center align-items-center"
         style="min-height: calc(100vh - 180px);">

        <div class="success-card text-center" style="max-width: 520px; width: 100%;">

            <div class="success-icon">
                <i class="bi bi-check-lg"></i>
            </div>

            <h5 class="fw-semibold mb-2">Pembayaran Berhasil!</h5>
            <p class="text-muted mb-4">
                Pesanan Anda sedang diproses
            </p>

            <a href="<%= request.getContextPath() %>/ProfileServlet"
               class="btn btn-success-custom text-white">
                Lihat Riwayat Pesanan
            </a>
        </div>

    </div>
               
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
               
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const toastEl = document.getElementById('successToast');
            const toast = new bootstrap.Toast(toastEl, { delay: 3000 });
            toast.show();
        });
    </script>
    
<!--    <script>
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
    </script>-->
</body>
</html>


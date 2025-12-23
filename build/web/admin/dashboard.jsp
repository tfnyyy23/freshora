<%-- 
    Document   : dashboard
    Created on : 9 Des 2025, 00.25.25
    Author     : ASUS
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.NumberFormat" %>
<%
    // Mengambil data statistik dari AdminServlet (jika ada)
    // Untuk sementara kita beri nilai default sesuai video jika data belum dikirim
    int totalProduk = (request.getAttribute("totalProduk") != null) ? (int)request.getAttribute("totalProduk") : 12;
    int totalCustomer = (request.getAttribute("totalCustomer") != null) ? (int)request.getAttribute("totalCustomer") : 0;
    int totalPesanan = (request.getAttribute("totalPesanan") != null) ? (int)request.getAttribute("totalPesanan") : 0;
    int totalPendapatan = (request.getAttribute("totalPendapatan") != null) ? (int)request.getAttribute("totalPendapatan") : 0;

    NumberFormat rupiah = NumberFormat.getInstance(new Locale("id", "ID"));
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - Freshora</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Inter', sans-serif; }
        .sidebar { width: 240px; height: 100vh; position: fixed; background: white; border-right: 1px solid #eee; }
        .main-content { margin-left: 240px; padding: 30px; }
        .nav-link { color: #666; padding: 12px 20px; border-radius: 8px; margin-bottom: 5px; }
        .nav-link:hover, .nav-link.active { background-color: #f0fdf4; color: #16a34a; }
        .stat-card { border: none; border-radius: 15px; transition: transform 0.2s; }
        .stat-card:hover { transform: translateY(-5px); }
        .icon-box { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 24px; }
    </style>
</head>
<body>

    <div class="sidebar p-3">
        <div class="d-flex align-items-center mb-4 px-3">
            <img src="../assets/img/logoFreshora1031.png" width="32" alt="Freshora Logo" class="me-2">
            <h4 class="fw-bold mb-0" style="color: #16a34a; font-family: 'Inter', sans-serif;">Freshora</h4>
        </div>
        
        <nav class="nav flex-column">
            <a class="nav-link active" href="dashboard.jsp"><i class="bi bi-grid me-2"></i> Dashboard</a>
            <a class="nav-link" href="products.jsp">
                <i class="bi bi-box-seam me-2"></i> Produk</a>
            <a class="nav-link" href="orders.jsp"><i class="bi bi-cart me-2"></i> Pesanan</a>
            <a class="nav-link" href="customers.jsp"><i class="bi bi-people me-2"></i> Customer</a>
            <a class="nav-link" href="reports.jsp"><i class="bi bi-bar-chart-line me-2"></i> Laporan</a>
            <hr>
            <a class="nav-link text-danger" href="../logout"><i class="bi bi-box-arrow-left me-2"></i> Logout</a>
        </nav>
    </div>

    <div class="main-content">
        <div class="mb-4">
            <h3 class="fw-bold">Dashboard Admin</h3>
            <p class="text-muted">Selamat datang kembali, Admin Freshora</p>
        </div>

        <div class="row g-4 mb-5">
            <div class="col-md-3">
                <div class="card stat-card shadow-sm p-3">
                    <div class="icon-box bg-primary bg-opacity-10 text-primary mb-3">
                        <i class="bi bi-box"></i>
                    </div>
                    <p class="text-muted small mb-1">Total Produk</p>
                    <h4 class="fw-bold mb-0"><%= totalProduk %></h4>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card shadow-sm p-3">
                    <div class="icon-box bg-success bg-opacity-10 text-success mb-3">
                        <i class="bi bi-people"></i>
                    </div>
                    <p class="text-muted small mb-1">Total Customer</p>
                    <h4 class="fw-bold mb-0"><%= totalCustomer %></h4>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card shadow-sm p-3">
                    <div class="icon-box bg-warning bg-opacity-10 text-warning mb-3">
                        <i class="bi bi-bag"></i>
                    </div>
                    <p class="text-muted small mb-1">Total Pesanan</p>
                    <h4 class="fw-bold mb-0"><%= totalPesanan %></h4>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card shadow-sm p-3">
                    <div class="icon-box bg-danger bg-opacity-10 text-danger mb-3">
                        <i class="bi bi-currency-dollar"></i>
                    </div>
                    <p class="text-muted small mb-1">Total Pendapatan</p>
                    <h4 class="fw-bold mb-0">Rp <%= rupiah.format(totalPendapatan) %></h4>
                </div>
            </div>
        </div>

        <div class="card border-0 shadow-sm p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="fw-bold mb-0">Pesanan Terbaru</h5>
                <a href="orders.jsp" class="text-success text-decoration-none small">Lihat semua pesanan &rarr;</a>
            </div>
            <div class="text-center py-5">
                <img src="../assets/img/empty-box.png" alt="No Orders" style="width: 150px; opacity: 0.5;" onerror="this.src='https://cdn-icons-png.flaticon.com/512/7486/7486744.png'">
                <p class="text-muted mt-3">Belum ada pesanan masuk hari ini.</p>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
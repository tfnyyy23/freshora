<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.NumberFormat, java.util.*" %>
<%
    // Ambil data dari Servlet
    Object revObj = request.getAttribute("revenue");
    Object transObj = request.getAttribute("transactions");
    Object topObj = request.getAttribute("topProducts");

    int revenue = (revObj != null) ? (Integer) revObj : 0;
    int transactions = (transObj != null) ? (Integer) transObj : 0;
    
    NumberFormat rupiah = NumberFormat.getInstance(new Locale("id", "ID"));
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laporan - Freshora Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logoFreshora1031.png">
    <link rel="stylesheet" href="assets/css/global.css">
    <style>
        :root { --primary-green: #16a34a; }
        body { background-color: #f8f9fa;}
        .sidebar { width: 240px; height: 100vh; position: fixed; background: white; border-right: 1px solid #eee; z-index: 1000; }
        .main-content { margin-left: 240px; padding: 30px; }
        .nav-link { color: #666; padding: 12px 20px; border-radius: 8px; margin-bottom: 5px; }
        .nav-link:hover, .nav-link.active { background-color: #f0fdf4; color: #16a34a; }
        .product-img { width: 50px; height: 50px; object-fit: cover; border-radius: 8px; }
        .card-table { border: none; border-radius: 12px; overflow: hidden; }
        .btn-add { background-color: #16a34a; color: white; font-weight: 500; border: none; padding: 10px 20px; border-radius: 10px; }
        .btn-add:hover { background-color: #15803d; color: white; }
        
        /* Main Content */
        /*.main-content { margin-left: 260px; padding: 40px; }*/
        .stat-card { border: none; border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); transition: transform 0.2s; }
        .stat-card:hover { transform: translateY(-5px); }
        .icon-box { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 24px; }
    </style>
</head>
<body>

    <div class="sidebar p-3">
        <div class="d-flex align-items-center mb-4 px-3">
            <img src="${pageContext.request.contextPath}/assets/img/logoFreshora1031.png" width="32" alt="Freshora Logo" class="me-2">
            <span class="fw-bold text-primary-custom fs-4" style="color: #16a34a;">Freshora</span>
        </div>
        
        <nav class="nav flex-column">
            <a class="nav-link" href="${pageContext.request.contextPath}/AdminServlet">
                <i class="bi bi-grid me-2"></i> Dashboard
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/ProductServlet">
                <i class="bi bi-box-seam me-2"></i> Produk
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/OrderServlet">
                <i class="bi bi-cart me-2"></i> Pesanan
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/ManageUserServlet">
                <i class="bi bi-people me-2"></i> Pengguna
            </a>
            <a class="nav-link active" href="${pageContext.request.contextPath}/ReportServlet">
                <i class="bi bi-bar-chart-line me-2"></i> Laporan
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="nav-link text-danger">
                <i class="bi bi-box-arrow-left me-2"></i> Logout
            </a>
        </nav>
    </div>

    <div class="main-content">
        <div class="mb-4">
            <h3 class="fw-bold">Laporan Transaksi</h3>
            <p class="text-muted">Pantau performa bisnis Anda secara real-time</p>
        </div>

        <div class="row g-4 mb-5">
            <div class="col-md-6">
                <div class="card stat-card p-4">
                    <div class="d-flex align-items-center">
                        <div class="icon-box bg-success bg-opacity-10 text-success me-3">
                            <i class="bi bi-currency-dollar"></i>
                        </div>
                        <div>
                            <p class="text-muted small mb-0">Total Pendapatan</p>
                            <h3 class="fw-bold mb-0">Rp <%= rupiah.format(revenue) %></h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card stat-card p-4">
                    <div class="d-flex align-items-center">
                        <div class="icon-box bg-primary bg-opacity-10 text-primary me-3">
                            <i class="bi bi-receipt"></i>
                        </div>
                        <div>
                            <p class="text-muted small mb-0">Total Transaksi</p>
                            <h3 class="fw-bold mb-0"><%= transactions %></h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card stat-card p-4 border-0">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="fw-bold mb-0">Produk Terlaris</h5>
                <span class="badge bg-light text-dark px-3 py-2 rounded-pill">Top 5 Produk</span>
            </div>
            
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-3">Nama Produk</th>
                            <th class="text-center">Total Terjual</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (topObj instanceof List) {
                                List<Map<String, Object>> items = (List<Map<String, Object>>) topObj;
                                if (items != null && !items.isEmpty()) {
                                    for (Map<String, Object> item : items) {
                        %>
                            <tr>
                                <td class="ps-3 fw-medium text-dark"><%= item.get("name") %></td>
                                <td class="text-center">
                                    <span class="badge bg-success bg-opacity-10 text-success px-3 py-2">
                                        <%= item.get("sold") %> Pcs
                                    </span>
                                </td>
                            </tr>
                        <% 
                                    }
                                } else {
                        %>
                            <tr><td colspan="2" class="text-center py-5 text-muted">Belum ada data penjualan hari ini.</td></tr>
                        <%
                                }
                            } else {
                        %>
                            <tr><td colspan="2" class="text-center py-5 text-danger">Gagal memuat data dari database.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
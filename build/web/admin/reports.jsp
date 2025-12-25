<%-- 
    Document   : reports
    Created on : 9 Des 2025, 00.26.32
    Author     : ASUS
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.NumberFormat, java.util.*" %>
<%
    int revenue = (request.getAttribute("revenue") != null) ? (int)request.getAttribute("revenue") : 0;
    int transactions = (request.getAttribute("transactions") != null) ? (int)request.getAttribute("transactions") : 0;
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
    <style>
        body { background-color: #f8f9fa; font-family: 'Inter', sans-serif; }
        .sidebar { width: 240px; height: 100vh; position: fixed; background: white; border-right: 1px solid #eee; }
        .main-content { margin-left: 240px; padding: 30px; }
        .nav-link { color: #666; padding: 12px 20px; border-radius: 8px; margin-bottom: 5px; }
        .nav-link:hover, .nav-link.active { background-color: #f0fdf4; color: #16a34a; }
        .stat-card { border: none; border-radius: 15px; }
        .icon-box { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 24px; }
    </style>
</head>
<body>

     <div class="sidebar p-3">
        <div class="d-flex align-items-center mb-4 px-3">
            <img src="${pageContext.request.contextPath}/assets/img/logoFreshora1031.png" width="32" alt="Freshora Logo" class="me-2">
            <h4 class="fw-bold mb-0" style="color: #16a34a; font-family: 'Inter', sans-serif;">Freshora</h4>
        </div>
        
        <nav class="nav flex-column">
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                <i class="bi bi-grid me-2"></i> Dashboard
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/ProductServlet">
                <i class="bi bi-box-seam me-2"></i> Produk
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/OrderServlet">
                <i class="bi bi-cart me-2"></i> Pesanan
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/ManageCustomerServlet">
                <i class="bi bi-people me-2"></i> Customer
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
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold">Laporan Transaksi</h3>
                <p class="text-muted">Ikhtisar performa penjualan Freshora</p>
            </div>
            <select class="form-select w-auto border-0 shadow-sm">
                <option>Harian</option>
                <option>Mingguan</option>
                <option>Bulanan</option>
            </select>
        </div>

        <div class="row g-4 mb-4">
            <div class="col-md-6">
                <div class="card stat-card shadow-sm p-4">
                    <div class="d-flex align-items-center">
                        <div class="icon-box bg-success bg-opacity-10 text-success me-3">
                            <i class="bi bi-graph-up-arrow"></i>
                        </div>
                        <div>
                            <p class="text-muted small mb-0">Total Pendapatan</p>
                            <h3 class="fw-bold mb-0">Rp <%= rupiah.format(revenue) %></h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card stat-card shadow-sm p-4">
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

        <div class="card border-0 shadow-sm p-4 mb-4">
            <h5 class="fw-bold mb-4">Produk Terlaris</h5>
            <div class="text-center py-5">
                <p class="text-muted">Belum ada data penjualan hari ini.</p>
            </div>
        </div>
    </div>
</body>
</html>
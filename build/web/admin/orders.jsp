<%-- 
    Document   : orders
    Created on : 9 Des 2025, 00.25.57
    Author     : ASUS
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pesanan - Freshora Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Inter', sans-serif; }
        .sidebar { width: 240px; height: 100vh; position: fixed; background: white; border-right: 1px solid #eee; }
        .main-content { margin-left: 240px; padding: 30px; }
        .nav-link { color: #666; padding: 12px 20px; border-radius: 8px; margin-bottom: 5px; }
        .nav-link:hover, .nav-link.active { background-color: #f0fdf4; color: #16a34a; }
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
            <a class="nav-link active" href="${pageContext.request.contextPath}/OrderServlet">
                <i class="bi bi-cart me-2"></i> Pesanan
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/ManageCustomerServlet">
                <i class="bi bi-people me-2"></i> Customer
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/ReportServlet">
                <i class="bi bi-bar-chart-line me-2"></i> Laporan
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="nav-link text-danger">
                <i class="bi bi-box-arrow-left me-2"></i> Logout
            </a>
        </nav>
    </div>

    <div class="main-content">
        <div class="mb-4">
            <h3 class="fw-bold">Manajemen Pesanan</h3>
            <p class="text-muted">Kelola semua transaksi masuk pelanggan</p>
        </div>

        <div class="card border-0 shadow-sm p-4">
            <% 
                List<Map<String, Object>> orders = (List<Map<String, Object>>) request.getAttribute("orderList");
                if (orders == null || orders.isEmpty()) { 
            %>
                <div class="text-center py-5">
                    <img src="https://cdn-icons-png.flaticon.com/512/7486/7486744.png" alt="No Orders" style="width: 150px; opacity: 0.5;">
                    <p class="text-muted mt-3 fs-5">Belum ada pesanan masuk.</p>
                </div>
            <% } else { %>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Order ID</th>
                                <th>Customer</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th>Tanggal</th>
                                <th>Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, Object> o : orders) { %>
                            <tr>
                                <td class="fw-bold">#<%= o.get("orderId") %></td>
                                <td><%= o.get("customerName") %></td>
                                <td>Rp <%= String.format("%,d", (int)o.get("total")) %></td>
                                <td><span class="badge bg-success bg-opacity-10 text-success px-3"><%= o.get("status") %></span></td>
                                <td class="small text-muted"><%= o.get("date") %></td>
                                <td><button class="btn btn-sm btn-outline-success">Detail</button></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
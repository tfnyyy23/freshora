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
    <title>Manajemen Pesanan - Freshora Admin</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/global.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logoFreshora1031.png">

    <style>
        body { background-color: #f8f9fa; }

        .sidebar {
            width: 240px;
            height: 100vh;
            position: fixed;
            background: white;
            border-right: 1px solid #eee;
            z-index: 1000;
        }

        .main-content {
            margin-left: 240px;
            padding: 30px;
        }

        .nav-link {
            color: #666;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 5px;
        }

        .nav-link:hover,
        .nav-link.active {
            background-color: #f0fdf4;
            color: #16a34a;
        }

        .order-card {
            background: #fff;
            border-radius: 14px;
            padding: 20px 24px;
            margin-bottom: 16px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .order-left { display: flex; flex-direction: column; gap: 6px; }
        .order-id { font-weight: 600; }
        .order-date { font-size: 13px; color: #888; }

        .status-select {
            border: none;
            background: #FFF3CD;
            color: #856404;
            padding: 5px 3px 5px 3px;
            border-radius: 8px;
            font-weight: 400;
            cursor: pointer;
            text-align: center;
            text-align-last: center;
        }

        .order-right {
            font-weight: normal;
            font-size: 16px;
            color: #222;
        }
    </style>
</head>

<body>

<!-- ===== SIDEBAR ===== -->
<div class="sidebar p-3">
    <div class="d-flex align-items-center mb-4 px-3">
        <img src="assets/img/logoFreshora1031.png" width="32" class="me-2">
        <span class="fw-bold fs-4" style="color:#16a34a;">Freshora</span>
    </div>

    <nav class="nav flex-column">
        <a class="nav-link" href="${pageContext.request.contextPath}/AdminServlet">
            <i class="bi bi-grid me-2"></i> Dashboard
        </a>
        <a class="nav-link" href="${pageContext.request.contextPath}/ProductServlet">
            <i class="bi bi-box-seam me-2"></i> Produk
        </a>
        <a class="nav-link active" href="${pageContext.request.contextPath}/OrderServlet">
            <i class="bi bi-cart me-2"></i> Pesanan
        </a>
        <a class="nav-link" href="${pageContext.request.contextPath}/ManageUserServlet">
            <i class="bi bi-people me-2"></i> Pengguna
        </a>
        <a class="nav-link" href="${pageContext.request.contextPath}/ReportServlet">
            <i class="bi bi-bar-chart-line me-2"></i> Laporan
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-link text-danger">
            <i class="bi bi-box-arrow-left me-2"></i> Logout
        </a>
    </nav>
</div>

<!-- ===== MAIN ===== -->
<div class="main-content">

    <h3 class="fw-bold mb-1">Manajemen Pesanan</h3>
    <p class="text-muted mb-4">Kelola semua transaksi masuk pelanggan</p>

    <%
        List<Map<String,Object>> orders = (List<Map<String,Object>>) request.getAttribute("orders");
    %>

    <% if (orders == null || orders.isEmpty()) { %>

        <div class="text-center py-5">
            <img src="https://cdn-icons-png.flaticon.com/512/7486/7486744.png" alt="No Orders" style="width: 150px; opacity: 0.5;">
            <p class="text-muted mt-3 fs-5">Belum ada pesanan masuk.</p>
        </div>

    <% } else { %>

        <% for (Map<String, Object> o : orders) { %>
        <div class="order-card">
            <div class="order-left">
                <div class="order-id">Order ID: <%= o.get("orderId") %></div>
                <div>Customer: <%= o.get("customerName") %></div>
                <div class="order-date"><%= o.get("date") %></div>

                <form action="OrderServlet" method="post">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="orderId" value="<%= o.get("orderId") %>">

                    <select name="order_status" class="status-select"
                            onchange="this.form.submit()">
                        <option value="Diproses" <%= "Diproses".equals(o.get("order_status")) ? "selected" : "" %>>
                            Diproses
                        </option>
                        <option value="Dikirim" <%= "Dikirim".equals(o.get("order_status")) ? "selected" : "" %>>
                            Dikirim
                        </option>
                        <option value="Selesai" <%= "Selesai".equals(o.get("order_status")) ? "selected" : "" %>>
                            Selesai
                        </option>
                    </select>
                </form>

            </div>

            <div class="order-right">
                Rp <%= String.format("%,d", (int) o.get("total")) %>
            </div>
        </div>
        <% } %>

    <% } %>
</div>

</body>
</html>

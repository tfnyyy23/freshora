<%-- 
    Document   : customers
    Created on : 9 Des 2025, 00.26.18
    Author     : ASUS
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, models.User" %>
<%
    // Mengambil data customer dari servlet (Pastikan hanya user dengan role 'customer' yang dikirim)
    List<User> customerList = (List<User>) request.getAttribute("customerList");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manajemen Customer - Freshora Admin</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Inter', sans-serif; }
        .sidebar { width: 240px; height: 100vh; position: fixed; background: white; border-right: 1px solid #eee; }
        .main-content { margin-left: 240px; padding: 30px; }
        .nav-link { color: #666; padding: 12px 20px; border-radius: 8px; margin-bottom: 5px; }
        .nav-link:hover, .nav-link.active { background-color: #f0fdf4; color: #16a34a; }
        

        /* Stats Card Styling */
        .stat-card {
            border: none;
            border-radius: 16px;
            padding: 20px;
            background: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        .card-table { 
            border: none; 
            border-radius: 16px; 
            box-shadow: 0 1px 3px rgba(0,0,0,0.1); 
            overflow: hidden;
        }

        .avatar-placeholder {
            width: 40px;
            height: 40px;
            background-color: #f0fdf4;
            color: #16a34a;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="sidebar p-3">
        <div class="d-flex align-items-center mb-4 px-3">
            <img src="../assets/img/logoFreshora1031.png" width="32" alt="Freshora Logo" class="me-2">
            <h4 class="fw-bold mb-0" style="color: #16a34a; font-family: 'Inter', sans-serif;">Freshora</h4>
        </div>
        
        <nav class="nav flex-column">
            <a class="nav-link" href="dashboard.jsp"><i class="bi bi-grid me-2"></i> Dashboard</a>
            <a class="nav-link" href="products.jsp">
                <i class="bi bi-box-seam me-2"></i> Produk</a>
            <a class="nav-link" href="orders.jsp"><i class="bi bi-cart me-2"></i> Pesanan</a>
            <a class="nav-link active" href="customers.jsp"><i class="bi bi-people me-2"></i> Customer</a>
            <a class="nav-link" href="reports.jsp"><i class="bi bi-bar-chart-line me-2"></i> Laporan</a>
            <hr>
            <a class="nav-link text-danger" href="../logout"><i class="bi bi-box-arrow-left me-2"></i> Logout</a>
        </nav>
    </div>

<div class="main-content">
    <div class="mb-4">
        <h3 class="fw-bold mb-0">Manajemen Customer</h3>
    </div>

    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="stat-card">
                <small class="text-muted d-block mb-1">Total Customer</small>
                <h3 class="fw-bold mb-0"><%= (customerList != null) ? customerList.size() : 0 %></h3>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <small class="text-muted d-block mb-1">Rata-rata Pesanan</small>
                <h3 class="fw-bold mb-0">0</h3>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <small class="text-muted d-block mb-1">Rata-rata Belanja</small>
                <h3 class="fw-bold mb-0">Rp 0</h3>
            </div>
        </div>
    </div>

    <div class="card card-table">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light">
                        <tr>
                            <th class="ps-4">Nama</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>No. Phone</th>
                            <th>Alamat</th>
                            <th class="text-center">Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (customerList != null && !customerList.isEmpty()) { 
                            for (User u : customerList) { %>
                        <tr>
                            <td class="ps-4">
                                <div class="d-flex align-items-center">
                                    <div class="avatar-placeholder me-3">
                                        <%= u.getName().substring(0,1).toUpperCase() %>
                                    </div>
                                    <span class="fw-semibold"><%= u.getName() %></span>
                                </div>
                            </td>
                            <td>@<%= u.getUsername() %></td>
                            <td><%= u.getEmail() %></td>
                            <td><%= u.getPhone() %></td>
                            <td class="text-truncate" style="max-width: 200px;"><%= u.getAddress() %></td>
                            <td class="text-center">
                                <button class="btn btn-sm text-primary border-0"><i class="bi bi-pencil"></i></button>
                                <button class="btn btn-sm text-danger border-0"><i class="bi bi-trash"></i></button>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted">Belum ada customer</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
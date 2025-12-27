<%-- 
    Document   : editProfile
    Created on : 27 Des 2025, 00.27.48
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%
    Map<String, Object> userData = (Map<String, Object>) request.getAttribute("userData");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Profile</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logoFreshora1031.png">
        <link rel="stylesheet" href="assets/css/global.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            body { background-color: #f9fafb;}
            .card { border: none; border-radius: 15px; }
            .profile-circle {
                width: 70px; height: 70px;
                background-color: #e8fcf1; color: #28a745;
                display: flex; align-items: center; justify-content: center;
                border-radius: 50%; margin-bottom: 20px;
            }
            .form-control {
                padding: 10px 15px;
                border-radius: 8px; border: 1px solid #e9ecef;
            }
            .btn-simpan { background-color: #16a34a; color: white; border-radius: 8px; padding: 8px 25px; }
            .btn-simpan:hover { background-color: #15803d; color: white; }
            .btn-batal { background-color: #d1d5db; color: #4b5563; border-radius: 8px; padding: 8px 25px; }
        </style>
    </head>
    <body>
        <nav class="navbar bg-white shadow-sm sticky-top">
            <div class="container">
                <a href="<%= request.getContextPath() %>/ProfileServlet"
                    class="text-decoration-none text-dark d-inline-flex align-items-center">
                    <i " class="bi bi-arrow-left-short fs-3"></i>
                    <span>Kembali</span>
                </a>
        </nav>

        <div class="container py-5" style="max-width: 850px;">
            <p class="text-muted mb-4">Profil Saya</p>
            <div class="card shadow-sm mb-4 p-4">
                <form action="ProfileServlet" method="POST">
                    <input type="hidden" name="action" value="update">
                    <div class="d-flex justify-content-between align-items-start mb-1">
                        <h5 class="fw-bold mb-0">Informasi Profil</h5>
                        <div>
                            <button type="submit" class="btn btn-simpan me-2">Simpan</button>
                            <a href="ProfileServlet" class="btn btn-batal">Batal</a>
                        </div>
                    </div>
                    <div class="profile-circle"><i class="bi bi-person fs-1"></i></div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="small text-muted mb-1">Nama Lengkap</label>
                            <input type="text" name="name" class="form-control" value="<%= userData.get("name") %>">
                        </div>
                        <div class="col-md-6">
                            <label class="small text-muted mb-1">Username</label>
                            <input type="text" name="username" class="form-control" value="<%= userData.get("username") %>">
                        </div>
                        <div class="col-md-6">
                            <label class="small text-muted mb-1">Email</label>
                            <input type="email" name="email" class="form-control" value="<%= userData.get("email") %>">
                        </div>
                        <div class="col-md-6">
                            <label class="small text-muted mb-1">Nomor Telepon</label>
                            <input type="text" name="phone" class="form-control" value="<%= userData.get("phone") %>">
                        </div>
                        <div class="col-12">
                            <label class="small text-muted mb-1">Alamat</label>
                            <textarea name="address" class="form-control" rows="3"><%= userData.get("address") %></textarea>
                        </div>
                        <div class="col-12 mt-4">
                            <label class="small text-muted mb-1">Kata Sandi Baru (opsional)</label>
                            <input type="password" name="password" class="form-control" placeholder="Kosongkan jika tidak ingin mengubah">
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

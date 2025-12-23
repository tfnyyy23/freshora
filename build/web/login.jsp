<%-- 
    Document   : login
    Created on : 9 Des 2025, 00.23.36
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login Freshora</title>

    <!-- BOOTSTRAP -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- ICON -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- CSS -->
    <link rel="stylesheet" href="assets/css/global.css">
    
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logoFreshora1031.png">
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #dcfce7, #a7f3d0);
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 16px;
            font-family: Arial, sans-serif;
        }

        .login-box {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            padding: 32px;
            width: 100%;
            max-width: 420px;
        }

        .logo {
            width: 64px;
            height: 64px;
            margin-bottom: 12px;
        }

        .btn-green {
            background-color: #22C55E;
            color: white;
        }

        .btn-green:hover {
            background-color: #16a34a;
        }

        .text-green {
            color: #22C55E;
        }

        .error-box {
            background: #fee2e2;
            border: 1px solid #fecaca;
            border-radius: 10px;
            padding: 12px;
            color: #dc2626;
            margin-bottom: 16px;
        }
    </style>
</head>

<body>

<div class="login-box">

    <!-- HEADER -->
    <div class="text-center mb-4">
        <img src="assets/img/logoFreshora1031.png" class="logo" alt="Freshora Logo">
        <h4 class="mb-1">Login ke Freshora</h4>
        <p class="text-muted">Masuk untuk melanjutkan belanja</p>
    </div>

    <!-- ERROR MESSAGE -->
    <%
        String error = request.getParameter("error");
        if (error != null) {
    %>
        <div class="error-box d-flex align-items-center gap-2">
            <i class="bi bi-exclamation-circle"></i>
            <span>
                <%= error.equals("1") ? "Username atau password salah" : "Terjadi kesalahan pada server" %>
            </span>
        </div>
    <%
        }
    %>

    <!-- FORM LOGIN -->
    <form action="LoginServlet" method="POST">

        <div class="mb-3">
            <label class="form-label">Username</label>
            <input style="border-radius: 10px; height: 50px" type="text" name="username" class="form-control" placeholder="Masukkan username" required>
        </div>

        <div class="mb-4">
            <label class="form-label">Kata Sandi</label>
            <input style="border-radius: 10px; height: 50px" type="password" name="password" class="form-control" placeholder="Masukkan kata sandi" required>
        </div>

        <button style="border-radius: 10px;" type="submit" class="btn btn-green w-100 py-2">
            <i class="bi bi-box-arrow-in-right"></i> Login
        </button>

    </form>

    <!-- REGISTER -->
    <div class="text-center mt-4">
        <p class="text-muted">
            Belum punya akun?
            <a href="register.jsp" class="text-green text-decoration-none fw-normal">Register</a>
        </p>
    </div>

    <!-- KEMBALI -->
    <div class="text-center mt-1">
        <a href="index.jsp" class="text-muted text-decoration-none d-inline-flex align-items-center gap-1">
            <i class="bi bi-arrow-left-short fs-4"></i>
            <span>Kembali ke Beranda</span>
        </a>
    </div>

</div>

</body>
</html>


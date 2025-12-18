<%-- 
    Document   : register
    Created on : 9 Des 2025, 00.23.49
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register Freshora</title>

    <!-- BOOTSTRAP -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- ICON -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- CSS -->
    <link rel="stylesheet" href="assets/css/global.css">
    
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #dcfce7, #a7f3d0);
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 16px;
        }

        .register-box {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            padding: 32px;
            width: 100%;
            max-width: 720px;
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

        .error-text {
            color: #dc2626;
            font-size: 13px;
            margin-top: 4px;
        }

        .success-box {
            background: #dcfce7;
            border: 1px solid #86efac;
            border-radius: 10px;
            padding: 12px;
            color: #16a34a;
            margin-bottom: 16px;
        }
    </style>
</head>

<body>

<div class="register-box">

    <!-- HEADER -->
    <div class="text-center mb-4">
        <img src="assets/img/logoFreshora1031.png" class="logo">
        <h4>Daftar ke Freshora</h4>
        <p class="text-muted">Buat akun baru untuk mulai berbelanja</p>
    </div>

    <!-- SUCCESS MESSAGE -->
    <%
        String success = request.getParameter("success");
        if (success != null) {
    %>
        <div class="success-box d-flex align-items-center gap-2">
            <i class="bi bi-check-circle"></i>
            Registrasi berhasil! Silakan login...
        </div>
        <script>
            setTimeout(() => {
                window.location.href = "login.jsp";
            }, 1500);
        </script>
    <%
        }
    %>

    <!-- FORM -->
    <form action="RegisterServlet" method="POST" onsubmit="return validateForm()">

        <div class="row g-3 mb-3">
            <div class="col-md-6">
                <label>Nama Lengkap</label>
                <input style="border-radius: 10px; height: 50px" type="text" name="name" id="name" class="form-control" placeholder="Masukkan nama lengkap">
                <div id="errName" class="error-text"></div>
            </div>

            <div class="col-md-6">
                <label>Username</label>
                <input style="border-radius: 10px; height: 50px" type="text" name="username" id="username" class="form-control" placeholder="Masukkan username">
                <div id="errUsername" class="error-text"></div>
            </div>
        </div>

        <div class="row g-3 mb-3">
            <div class="col-md-6">
                <label>Email</label>
                <input style="border-radius: 10px; height: 50px" type="email" name="email" id="email" class="form-control" placeholder="nama@example.com">
                <div id="errEmail" class="error-text"></div>
            </div>

            <div class="col-md-6">
                <label>Nomor Telepon</label>
                <input style="border-radius: 10px; height: 50px" type="text" name="phone" id="phone" class="form-control" placeholder="081234567890">
                <div id="errPhone" class="error-text"></div>
            </div>
        </div>

        <div class="mb-3">
            <label>Alamat</label>
            <textarea style="border-radius: 10px;" name="address" id="address" class="form-control" rows="3" placeholder="Masukkan alamat lengkap"></textarea>
            <div id="errAddress" class="error-text"></div>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-md-6">
                <label>Kata Sandi</label>
                <input style="border-radius: 10px; height: 50px" type="password" name="password" id="password" class="form-control" placeholder="Minimal 8 karakter">
                <div id="errPassword" class="error-text"></div>
            </div>

            <div class="col-md-6">
                <label>Konfirmasi Kata Sandi</label>
                <input style="border-radius: 10px; height: 50px" type="password" name="confirmPassword" id="confirmPassword" class="form-control" placeholder="Ulangi kata sandi">
                <div id="errConfirm" class="error-text"></div>
            </div>
        </div>

        <button style="border-radius: 10px;" type="submit" class="btn btn-green w-100 py-2">
            <i class="bi bi-person-plus"></i> Daftar Sekarang
        </button>

    </form>

    <!-- LOGIN -->
    <div class="text-center mt-4">
        <p class="text-muted">
            Sudah punya akun?
            <a href="login.jsp" class="text-green fw-normal text-decoration-none">Login</a>
        </p>
    </div>

    <!-- BACK -->
    <div class="text-center mt-3">
        <a href="index.jsp" class="text-muted text-decoration-none">
            ← Kembali ke Beranda
        </a>
    </div>

</div>

<script>
    function validateForm() {
        let valid = true;

        const name = document.getElementById("name").value;
        const username = document.getElementById("username").value;
        const email = document.getElementById("email").value;
        const phone = document.getElementById("phone").value;
        const address = document.getElementById("address").value;
        const password = document.getElementById("password").value;
        const confirm = document.getElementById("confirmPassword").value;

        document.querySelectorAll(".error-text").forEach(e => e.innerText = "");

        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (!name) { errName.innerText = "Nama wajib diisi"; valid = false; }
        if (!username) { errUsername.innerText = "Username wajib diisi"; valid = false; }
        if (!email || !emailRegex.test(email)) { errEmail.innerText = "Email tidak valid"; valid = false; }
        if (!phone || isNaN(phone)) { errPhone.innerText = "Nomor hanya angka"; valid = false; }
        if (!address) { errAddress.innerText = "Alamat wajib diisi"; valid = false; }
        if (!password || password.length < 8) { errPassword.innerText = "Minimal 8 karakter"; valid = false; }
        if (password !== confirm) { errConfirm.innerText = "Password tidak sama"; valid = false; }

        return valid;
    }
</script>

</body>
</html>


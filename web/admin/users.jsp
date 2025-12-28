<%-- 
    Document   : users
    Created on : 9 Des 2025, 00.26.18
    Author     : ASUS
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, models.User, java.text.NumberFormat" %>
<%
    // Mengambil data customer dari servlet (Pastikan hanya user dengan role 'customer' yang dikirim)
    List<User> customerList = (List<User>) request.getAttribute("customerList");
    double avgOrder = (request.getAttribute("avgOrder") != null) ? (double) request.getAttribute("avgOrder") : 0.0;
    double avgSpend = (request.getAttribute("avgSpend") != null) ? (double) request.getAttribute("avgSpend") : 0.0;
    NumberFormat rupiah = NumberFormat.getInstance(new Locale("id", "ID"));
%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manajemen User - Freshora Admin</title>
        <link rel="stylesheet" href="assets/css/global.css">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logoFreshora1031.png">
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
                min-width: 45px;
                min-height: 45px;
                background-color: #f0fdf4;
                color: #16a34a;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 50%;
                font-weight: bold;
                font-size: 1.1rem;
            }
            
            .btn-add { background-color: #16a34a; color: white; font-weight: 500; border: none; padding: 10px 20px; border-radius: 10px; }
            .btn-add:hover { background-color: #15803d; color: white; }
        </style>
    </head>
    <body>
         <div class="sidebar p-3">
            <div class="d-flex align-items-center mb-4 px-3">
                <img src="assets/img/logoFreshora1031.png" width="32" alt="Freshora Logo" class="me-2">
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
                <a class="nav-link active" href="${pageContext.request.contextPath}/ManageUserServlet">
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

        <div class="main-content">
            <div class="mb-4">
                <h3 class="fw-bold mb-0">Manajemen User</h3>
            </div>

            <div class="row g-4 mb-5">
                <div class="col-md-4">
                    <div class="stat-card">
                        <small class="text-muted d-block mb-1">Total Customer</small>
                        <h3 class="fw-bold mb-0"><%= (request.getAttribute("totalCustomer") != null) ? request.getAttribute("totalCustomer") : 0 %></h3>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <small class="text-muted d-block mb-1">Rata-rata Pesanan</small>
                        <h3 class="fw-bold mb-0"><%= avgOrder %></h3>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <small class="text-muted d-block mb-1">Rata-rata Belanja</small>
                        <h3 class="fw-bold mb-0">Rp <%= rupiah.format(avgSpend) %></h3>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-end align-items-center mb-4">
                <button class="btn btn-add" data-bs-toggle="modal" data-bs-target="#modalAddUser">
                    <i class="bi bi-plus-lg me-2"></i> Tambah User
                </button>
            </div>
            <div class="card card-table">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-light">
                                <tr>
                                    <th class="ps-4" style="background-color: #16a34a; color: white;">Nama</th>
                                    <th style="background-color: #16a34a; color: white;">Username</th>
                                    <th style="background-color: #16a34a; color: white;">Email</th>
                                    <th style="background-color: #16a34a; color: white;">No. Phone</th>
                                    <th style="background-color: #16a34a; color: white;">Alamat</th>
                                    <th style="background-color: #16a34a; color: white;">Role</th>
                                    <th class="text-center" style="background-color: #16a34a; color: white;">Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (customerList != null && !customerList.isEmpty()) { 
                                    for (User u : customerList) { %>
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-placeholder me-2">
                                                <% 
                                                    String name = u.getName();
                                                    String initials = "";
                                                    if (name != null && !name.isEmpty()) {
                                                        String[] words = name.split("\\s+"); // Memecah berdasarkan spasi
                                                        for (int i = 0; i < Math.min(words.length, 2); i++) { // Ambil maksimal 2 kata
                                                            if (!words[i].isEmpty()) {
                                                                initials += words[i].charAt(0);
                                                            }
                                                        }
                                                    }
                                                %>
                                                <%= initials.toUpperCase() %>
                                            </div>
                                            <span class="fw-semibold"><%= u.getName() %></span>
                                        </div>
                                    </td>
                                    <td>@<%= u.getUsername() %></td>
                                    <td><%= u.getEmail() %></td>
                                    <td><%= u.getPhone() %></td>
                                    <td class="text-truncate" style="max-width: 150px;"><%= u.getAddress() %></td>
                                    <td><%= u.getRole() %></td>
                                    <td class="text-center" style="min-width: 85px;">
                                        <button type="button" class="btn btn-sm btn-outline-primary border-0 me-0" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#modalEditUser"
                                                onclick="editUser(
                                                    '<%= u.getUserId() %>', 
                                                    '<%= u.getName().replace("'", "\\'") %>', 
                                                    '<%= u.getUsername().replace("'", "\\'") %>', 
                                                    '<%= u.getEmail() %>', 
                                                    '<%= u.getPhone() != null ? u.getPhone() : "" %>', 
                                                    '<%= u.getAddress() != null ? u.getAddress().replace("'", "\\'") : "" %>', 
                                                    '<%= u.getRole() %>'
                                                )">
                                            <i class="bi bi-pencil-square"></i>
                                        </button>

                                        <a href="${pageContext.request.contextPath}/ManageUserServlet?action=delete&id=<%= u.getUserId() %>" 
                                           class="btn btn-sm btn-outline-danger border-0" 
                                           onclick="return confirm('Yakin ingin menghapus user ini?')">
                                            <i class="bi bi-trash"></i>
                                        </a>
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

        <div class="modal fade" id="modalAddUser" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow">
                    <div class="modal-header border-0">
                        <h5 class="modal-title fw-bold">Tambah User Baru</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/ManageUserServlet" method="POST">
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Nama Lengkap</label>
                                <input type="text" name="name" class="form-control" required>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label small fw-bold">Role User</label>
                                    <select name="role" class="form-select" required>
                                        <option value="customer">Customer</option>
                                        <option value="admin">Admin</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label small fw-bold">Username</label>
                                    <input type="text" name="username" class="form-control" required>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label small fw-bold">Email</label>
                                    <input type="email" name="email" class="form-control" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label small fw-bold">No Telepon</label>
                                    <input type="phone" name="phone" class="form-control" required>
                                </div>
                            </div>
                            <div class="">
                                <label class="form-label small fw-bold">Alamat</label>
                                <!--<input type="address" name="address" class="form-control" required>-->
                                <textarea name="address" id="address" class="form-control" rows="3"></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Password</label>
                                <div class="input-group">
                                    <input type="password" name="password" class="form-control" placeholder="Masukkan password">
                                </div>
                                <small class="text-muted">Kosongkan untuk menggunakan default: <b>Freshora123</b></small>
                            </div>
                        </div>
                        <div class="modal-footer border-0">
                            <button type="button" class="btn btn-light px-4" data-bs-dismiss="modal">Batal</button>
                            <button type="submit" class="btn px-4" style="background-color: #16a34a; color: white;">Simpan User</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <div class="modal fade" id="modalEditUser" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold">Edit User</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="ManageUserServlet" method="POST">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" id="edit_id">
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Nama Lengkap</label>
                                <input type="text" name="name" id="edit_name" class="form-control" required>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label small fw-bold">Username</label>
                                    <input type="text" name="username" id="edit_username" class="form-control" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label small fw-bold">Role</label>
                                    <select name="role" id="edit_role" class="form-select">
                                        <option value="customer">Customer</option>
                                        <option value="admin">Admin</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label small fw-bold">Email</label>
                                    <input type="email" name="email" id="edit_email" class="form-control" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label small fw-bold">No Telepon</label>
                                    <input type="text" name="phone" id="edit_phone" class="form-control">
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Alamat</label>
                                <textarea name="address" id="edit_address" class="form-control" rows="2"></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Ganti Password (Opsional)</label>
                                <div class="input-group">
                                    <input type="password" name="password" id="edit_password" class="form-control" placeholder="Isi jika ingin ganti">
                                </div>
                                <small class="text-muted">Biarkan kosong jika tidak ingin mengubah password.</small>
                            </div>
                        </div>
                        <div class="modal-footer border-0">
                            <button type="submit" class="btn btn-primary w-100">Simpan Perubahan</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function editUser(id, name, username, email, phone, address, role) {
                document.getElementById('edit_id').value = id;
                document.getElementById('edit_name').value = name;
                document.getElementById('edit_username').value = username;
                document.getElementById('edit_email').value = email;
                document.getElementById('edit_phone').value = (phone === "null") ? "" : phone;
                document.getElementById('edit_address').value = (address === "null") ? "" : address;
                document.getElementById('edit_role').value = role;

                new bootstrap.Modal(document.getElementById('modalEditUser')).show();
            }
        </script>
    </body>
</html>
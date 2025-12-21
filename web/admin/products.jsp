<%-- 
    Document   : products
    Created on : 9 Des 2025, 00.25.35
    Author     : ASUS
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, models.Product, java.text.NumberFormat" %>
<%
    // Mengambil data produk yang dikirim oleh ProductServlet
    List<Product> productList = (List<Product>) request.getAttribute("productList");
    
    // Format mata uang Rupiah sesuai standar Indonesia
    NumberFormat rupiah = NumberFormat.getInstance(new Locale("id", "ID"));
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manajemen Produk - Freshora Admin</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Inter', sans-serif; }
        .sidebar { width: 240px; height: 100vh; position: fixed; background: white; border-right: 1px solid #eee; }
        .main-content { margin-left: 240px; padding: 30px; }
        .nav-link { color: #666; padding: 12px 20px; border-radius: 8px; margin-bottom: 5px; }
        .nav-link:hover, .nav-link.active { background-color: #f0fdf4; color: #16a34a; }
        

        /* Styling Tabel & Gambar */
        .product-img { width: 50px; height: 50px; object-fit: cover; border-radius: 8px; }
        .card-table { border: none; border-radius: 12px; overflow: hidden; }
        .btn-add { background-color: #16a34a; color: white; font-weight: 500; border: none; padding: 10px 20px; border-radius: 10px; }
        .btn-add:hover { background-color: #15803d; color: white; }
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
            <a class="nav-link active" href="products.jsp">
                <i class="bi bi-box-seam me-2"></i> Produk</a>
            <a class="nav-link" href="orders.jsp"><i class="bi bi-cart me-2"></i> Pesanan</a>
            <a class="nav-link" href="customers.jsp"><i class="bi bi-people me-2"></i> Customer</a>
            <a class="nav-link" href="reports.jsp"><i class="bi bi-bar-chart-line me-2"></i> Laporan</a>
            <hr>
            <a class="nav-link text-danger" href="../logout"><i class="bi bi-box-arrow-left me-2"></i> Logout</a>
        </nav>
    </div>

<div class="main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold mb-0">Manajemen Produk</h3>
        <button class="btn btn-add" data-bs-toggle="modal" data-bs-target="#modalTambah">
            <i class="bi bi-plus-lg me-2"></i> Tambah Produk
        </button>
    </div>

    <div class="card card-table shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th class="ps-4">Gambar</th>
                            <th>Nama Produk</th>
                            <th>Kategori</th>
                            <th>Harga</th>
                            <th>Stok</th>
                            <th>Rating</th>
                            <th class="text-center">Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        if (productList != null && !productList.isEmpty()) { 
                            for (Product p : productList) { 
                                // Cek apakah gambar URL atau lokal
                                String img = p.getImage();
                                boolean isUrl = img != null && (img.startsWith("http"));
                        %>
                        <tr>
                            <td class="ps-4">
                                <img src="<%= isUrl ? img : request.getContextPath() + "/assets/img/" + img %>" 
                                    class="product-img shadow-sm" alt="produk">
                            </td>
                            <td><span class=" text-dark"><%= p.getName() %></span></td>
                            <td>
                                <span class=" text-dark">
                                    <% 
                                        int cid = p.getCategoryId();
                                        String cname = (cid == 1) ? "Sayur" : (cid == 2) ? "Buah" : (cid == 3) ? "Daging" : "Lainnya";
                                    %>
                                    <%= cname %>
                                </span>
                            </td>
                            <td class="fw-bold text-success">
                                Rp <%= rupiah.format(p.getPrice()) %>
                            </td>
                            <td>
                                <span class="<%= p.getStock() <= 10 ? "text-danger fw-bold" : "text-dark" %>">
                                    <%= p.getStock() %>
                                </span>
                            </td>
                            <td>
                                <i class="bi bi-star-fill text-warning me-1"></i>
                                <%= p.getRating() %>
                            </td>
                            <td class="text-center">
                                <button class="btn btn-sm btn-outline-primary border-0 me-1">
                                    <i class="bi bi-pencil-square"></i>
                                </button>
                                <button class="btn btn-sm btn-outline-danger border-0">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </td>
                        </tr>
                        <% 
                            } 
                        } else { 
                        %>
                        <tr>
                            <td colspan="7" class="text-center py-5 text-muted">
                                <i class="bi bi-box-seam display-4 d-block mb-3"></i>
                                Belum ada data produk tersedia.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

                
<div class="modal fade" id="modalTambah" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content shadow border-0" style="border-radius: 15px;">
            <div class="modal-header border-0">
                <h5 class="modal-title fw-bold">Tambah Produk</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <%-- Form POST ke ProductServlet --%>
            <form action="<%= request.getContextPath() %>/ProductServlet" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Nama Produk</label>
                        <input type="text" name="name" class="form-control" placeholder="Masukkan nama produk" required>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label small fw-bold">Kategori</label>
                            <select name="category_id" class="form-select">
                                <option value="1">Sayur</option>
                                <option value="2">Buah</option>
                                <option value="3">Daging</option>
                                <option value="4">Telur</option>
                                <option value="5">Susu & Olahan</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label small fw-bold">Harga (Rp)</label>
                            <input type="number" name="price" class="form-control" placeholder="0" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-12 mb-3">
                            <label class="form-label small fw-bold">Stok</label>
                            <input type="number" name="stock" class="form-control" placeholder="0" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-bold">Deskripsi</label>
                        <textarea name="description" class="form-control" rows="3" placeholder="Deskripsi produk..."></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-bold">URL Gambar</label>
                        <input type="text" name="image" class="form-control" placeholder="https://example.com/image.jpg">
                        <div class="form-text mt-1" style="font-size: 0.75rem;">Masukkan link gambar atau nama file di folder assets.</div>
                    </div>
                </div>
                <div class="modal-footer border-0 p-3">
                    <button type="submit" class="btn btn-success w-100 py-2 fw-bold" style="border-radius: 8px;">Tambah Produk</button>
                    <button type="button" class="btn btn-light w-100 py-2 fw-bold" data-bs-dismiss="modal">Batal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
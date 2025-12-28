<%-- 
    Document   : products
    Created on : 9 Des 2025, 00.25.35
    Author     : ASUS
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, models.Product, java.text.NumberFormat" %>
<%
    List<Product> productList = (List<Product>) request.getAttribute("productList");
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
    <link rel="stylesheet" href="assets/css/global.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logoFreshora1031.png">
    <style>
        body { background-color: #f8f9fa;}
        .sidebar { width: 240px; height: 100vh; position: fixed; background: white; border-right: 1px solid #eee; z-index: 1000; }
        .main-content { margin-left: 240px; padding: 30px; }
        .nav-link { color: #666; padding: 12px 20px; border-radius: 8px; margin-bottom: 5px; }
        .nav-link:hover, .nav-link.active { background-color: #f0fdf4; color: #16a34a; }
        .product-img { width: 50px; height: 50px; object-fit: cover; border-radius: 8px; }
        .card-table { border: none; border-radius: 12px; overflow: hidden; }
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
            <a class="nav-link active" href="${pageContext.request.contextPath}/ProductServlet">
                <i class="bi bi-box-seam me-2"></i> Produk
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/OrderServlet">
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
                                <th class="ps-4" style="background-color: #16a34a; color: white;">Gambar</th>
                                <th style="background-color: #16a34a; color: white;">Nama Produk</th>
                                <th style="background-color: #16a34a; color: white;">Kategori</th>
                                <th style="background-color: #16a34a; color: white;">Harga</th>
                                <th style="background-color: #16a34a; color: white;">Stok</th>
                                <th style="background-color: #16a34a; color: white;">Rating</th>
                                <th class="text-center" style="background-color: #16a34a; color: white;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (productList != null) { 
                                for (Product p : productList) { 
                                    String img = p.getImage();
                                    boolean isUrl = img != null && (img.startsWith("http"));
                            %>
                            <tr>
                                <td class="ps-4">
                                    <img src="<%= isUrl ? img : request.getContextPath() + "/assets/img/" + img %>" class="product-img shadow-sm">
                                </td>
                                <td><%= p.getName() %></td>
                                <td>
                                    <% 
                                        int cid = p.getCategoryId();
                                        String cname = (cid == 1) ? "Sayur" : (cid == 2) ? "Buah" : (cid == 3) ? "Daging" : "Lainnya";
                                    %>
                                    <%= cname %>
                                </td>
                                <td class="fw-normal" style="color: #16a34a;">Rp <%= rupiah.format(p.getPrice()) %></td>
                                <td><span class="<%= p.getStock() <= 10 ? "text-danger fw-bold" : "" %>"><%= p.getStock() %></span></td>
                                <td><i class="bi bi-star-fill text-warning me-1"></i><%= p.getRating() %></td>
                                <td class="text-center">
                                    <button type="button" class="btn btn-sm btn-outline-primary border-0 me-1" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#modalEdit"
                                            onclick="isiModalEdit('<%= p.getProductId() %>', '<%= p.getName().replace("'", "\\'") %>', '<%= p.getCategoryId() %>', '<%= p.getPrice() %>', '<%= p.getStock() %>', '<%= p.getDescription() != null ? p.getDescription().replace("'", "\\'") : "" %>', '<%= p.getImage() %>')">
                                        <i class="bi bi-pencil-square"></i>
                                    </button>

                                    <a href="${pageContext.request.contextPath}/ProductServlet?action=delete&id=<%= p.getProductId() %>" 
                                       class="btn btn-sm btn-outline-danger border-0" 
                                       onclick="return confirm('Hapus produk ini?')">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalTambah" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow" style="border-radius: 15px;">
                <form action="<%= request.getContextPath() %>/ProductServlet" method="POST" enctype="multipart/form-data">
                    <div class="modal-header border-0">
                        <h5 class="modal-title fw-bold">Tambah Produk Baru</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Nama Produk</label>
                            <input type="text" name="name" class="form-control" required>
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
                                <input type="number" name="price" class="form-control" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Stok</label>
                            <input type="number" name="stock" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Deskripsi</label>
                            <textarea name="description" class="form-control" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Gambar Produk (Pilih salah satu)</label>
                            <div class="row g-2">
                                <div class="col-md-6">
                                    <input type="text" name="image_url" id="add_image_url" 
                                           class="form-control" placeholder="Masukkan URL Gambar"
                                           oninput="toggleImageInput('url')">
                                </div>
                                <div class="col-md-6">
                                    <input type="file" name="image_file" id="add_image_file" 
                                           class="form-control" accept="image/*"
                                           onchange="toggleImageInput('file')">
                                </div>
                            </div>
                            <small class="text-muted" style="font-size: 0.75rem;">*Isi URL atau pilih file.</small>
                        </div>
                    </div>
                    <div class="modal-footer border-0">
                        <button type="submit" class="btn w-100 py-2 fw-normal" style="background-color: #16a34a; color: white;">Tambah Produk</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalEdit" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow" style="border-radius: 15px;">
                <form action="<%= request.getContextPath() %>/ProductServlet" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="edit_id">
                    <input type="hidden" name="image_old" id="edit_image_old">
                    <div class="modal-header border-0">
                        <h5 class="modal-title fw-bold">Edit Produk</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Nama Produk</label>
                            <input type="text" name="name" id="edit_name" class="form-control" required>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label small fw-bold">Kategori</label>
                                <select name="category_id" id="edit_category" class="form-select">
                                    <option value="1">Sayur</option>
                                    <option value="2">Buah</option>
                                    <option value="3">Daging</option>
                                    <option value="4">Telur</option>
                                    <option value="5">Susu & Olahan</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label small fw-bold">Harga (Rp)</label>
                                <input type="number" name="price" id="edit_price" class="form-control" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Stok</label>
                            <input type="number" name="stock" id="edit_stock" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Deskripsi</label>
                            <textarea name="description" id="edit_description" class="form-control" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Ubah Gambar (Kosongkan jika tidak ingin diubah)</label>
                            <div class="row g-2">
                                <div class="col-md-6">
                                    <input type="text" name="image_url" id="edit_image_url" 
                                           class="form-control" placeholder="URL Baru"
                                           oninput="toggleEditImageInput('url')">
                                </div>
                                <div class="col-md-6">
                                    <input type="file" name="image_file" id="edit_image_file" 
                                           class="form-control" accept="image/*"
                                           onchange="toggleEditImageInput('file')">
                                </div>
                            </div>
                            <div class="mt-2 text-center">
                                <p class="small text-muted mb-1">Gambar saat ini:</p>
                                <img id="edit_preview" src="" class="product-img shadow-sm" style="width: 80px; height: 80px;">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0">
                        <button type="submit" class="btn btn-primary w-100 py-2 fw-normal">Simpan Perubahan</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function isiModalEdit(id, name, catId, price, stock, desc, img) {
            document.getElementById('edit_id').value = id;
            document.getElementById('edit_name').value = name;
            document.getElementById('edit_category').value = catId;
            document.getElementById('edit_price').value = price;
            document.getElementById('edit_stock').value = stock;
            document.getElementById('edit_description').value = desc;

            // Simpan gambar lama ke hidden input
            document.getElementById('edit_image_old').value = img;

            // Tampilkan preview gambar saat ini
            const previewImg = document.getElementById('edit_preview');
            const path = img.startsWith('http') ? img : '<%= request.getContextPath() %>/assets/img/' + img;
            previewImg.src = path;

            // Reset input file dan URL agar kosong setiap kali buka modal baru
            document.getElementById('edit_image_url').value = '';
            document.getElementById('edit_image_file').value = '';
            document.getElementById('edit_image_url').disabled = false;
            document.getElementById('edit_image_file').disabled = false;
        }
        
        function toggleEditImageInput(type) {
            const urlInput = document.getElementById('edit_image_url');
            const fileInput = document.getElementById('edit_image_file');

            if (type === 'url') {
                fileInput.disabled = urlInput.value.length > 0;
            } else if (type === 'file') {
                urlInput.disabled = fileInput.files.length > 0;
            }
        }
        
        function toggleImageInput(type) {
            const urlInput = document.getElementById('add_image_url');
            const fileInput = document.getElementById('add_image_file');

            if (type === 'url') {
                // Jika URL diisi, matikan File
                fileInput.disabled = urlInput.value.length > 0;
            } else if (type === 'file') {
                // Jika File dipilih, matikan URL
                urlInput.disabled = fileInput.files.length > 0;
            }
        }
    </script>
</body>
</html>
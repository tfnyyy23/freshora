<%-- 
    Document   : profile
    Created on : 9 Des 2025, 00.25.08
    Author     : ASUS
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, java.text.NumberFormat" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile Saya</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/global.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logoFreshora1031.png">
    <style>
        body { background-color: #f9fafb;}
        .card { border: none; border-radius: 15px; }
        .profile-circle {
            width: 70px; height: 70px;
            background-color: #e8fcf1; color: #28a745;
            display: flex; align-items: center; justify-content: center;
            border-radius: 50%; margin-bottom: 20px;
        }
        .form-control-plaintext {
            background-color: #f1f3f5; padding: 10px 15px;
            border-radius: 8px; border: 1px solid #e9ecef;
        }
        .order-item-card { border: 1px solid #f1f3f5; border-radius: 12px; }
        .btn-logout { background-color: #ff3b3b; color: white; border-radius: 10px; border: none; padding: 12px; transition: 0.3s; }
        .btn-logout:hover { background-color: #e63535; color: white; opacity: 0.9; }
        
        /* Star Rating Style */
        /* Star Rating Style: Default Kosong */
    .star-rating { 
        display: flex; 
        flex-direction: row-reverse; 
        justify-content: center; 
        gap: 10px; 
    }
    .star-rating input { display: none; }
    .star-rating label { 
        font-size: 2.5rem; 
        color: #e9ecef; /* Warna abu-abu saat kosong */
        cursor: pointer; 
        transition: color 0.2s; 
    }
    
    /* Warna saat di-hover atau dipilih */
    .star-rating input:checked ~ label,
    .star-rating label:hover,
    .star-rating label:hover ~ label { 
        color: #ffc107; 
    }
    
    .modal-content { border-radius: 20px; border: none; }
    .btn-kirim { 
        background-color: #28a745; 
        color: white; 
        border-radius: 10px; 
        padding: 10px; 
        border: none;
    }
        .modal-header { border-bottom: none; padding-top: 25px; }
        .modal-footer { border-top: none; padding-bottom: 25px; }
    </style>
</head>
<body>

    <nav class="navbar bg-white shadow-sm sticky-top">
        <div class="container">
            <a href="<%= request.getContextPath() %>/CustomerServlet"
                class="text-decoration-none text-dark d-inline-flex align-items-center">
                <i " class="bi bi-arrow-left-short fs-3"></i>
                <span>Kembali</span>
            </a>
    </nav>

    <div class="container py-5" style="max-width: 850px;">
        <p class="text-muted mb-4">Profil Saya</p>

        <div class="card shadow-sm mb-4 p-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold mb-0">Informasi Profil</h5>
                <a href="#" class="text-decoration-none fw-medium" style="color: #16a34a;">Edit</a>
            </div>
            <div class="profile-circle"><i class="bi bi-person fs-1"></i></div>
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="small text-muted mb-1">Nama Lengkap</label>
                    <div class="form-control-plaintext">${user.name}</div>
                </div>
                <div class="col-md-6">
                    <label class="small text-muted mb-1">Username</label>
                    <div class="form-control-plaintext">${user.username != null ? user.username : 'jenoyaa'}</div>
                </div>
                <div class="col-md-6">
                    <label class="small text-muted mb-1">Email</label>
                    <div class="form-control-plaintext">${user.email}</div>
                </div>
                <div class="col-md-6">
                    <label class="small text-muted mb-1">Nomor Telepon</label>
                    <div class="form-control-plaintext">${user.phone != null ? user.phone : '081234567890'}</div>
                </div>
                <div class="col-12">
                    <label class="small text-muted mb-1">Alamat</label>
                    <div class="form-control-plaintext" style="min-height: 80px;">${user.address != null ? user.address : 'Seoul, South Korea'}</div>
                </div>
            </div>
        </div>

        <form action="LogoutServlet" method="post" class="mb-5">
            <button type="submit" class="btn btn-logout w-100 fw-normal">
                <i class="bi bi-box-arrow-right me-2"></i> Logout
            </button>
        </form>

        <div class="card shadow-sm mb-4 p-4">
            <h5 class="fw-bold mb-4">Riwayat Pesanan</h5>
            <%
                List<Map<String,Object>> orders = (List<Map<String,Object>>) request.getAttribute("orders");
                if (orders == null || orders.isEmpty()) {
            %>
                <p class="text-center text-muted py-3">Belum ada riwayat pesanan</p>
            <% 
                } else {
                    for (Map<String,Object> order : orders) {
                        String status = (String) order.get("status");
            %>
                <div class="order-item-card p-3 mb-3">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div>
                            <span class="small text-muted d-block">Order ID: <%= order.get("id") %></span>
                            <span class="small text-muted fw-light"><%= order.get("date") %></span>
                        </div>
                        <%
                            String style = "background-color: #fff9db; color: #f08c00; font-weight: normal;"; 
                            if ("Dikirim".equals(status)) style = "background-color: #e7f5ff; color: #1c7ed6; font-weight: normal;";
                            else if ("Selesai".equals(status)) style = "background-color: #ebfbee; color: #2b8a3e; font-weight: normal;";
                        %>
                        <span class="badge rounded-pill px-3 py-2" style="<%= style %>"><%= status %></span>
                    </div>

                    <div class="border-bottom pb-2 mb-2">
                        <% 
                            List<Map<String,Object>> items = (List<Map<String,Object>>) order.get("items");
                            for (Map<String,Object> item : items) {
                        %>
                            <div class="d-flex justify-content-between mb-1 small">
                                <span><%= item.get("name") %> x <%= item.get("quantity") %></span>
                                <span class="text-muted">Rp <%= String.format("%,d", (Integer)item.get("quantity") * (Integer)item.get("price")) %></span>
                            </div>
                        <% } %>
                    </div>

                    <div class="d-flex justify-content-between align-items-center">
                        <div class="fw-normal">
                            <span class="text-muted small">Total:</span> 
                            <span class="ms-1">Rp <%= String.format("%,d", order.get("total")) %></span>
                        </div>
                        
                        <% 
                            Object isRatedObj = order.get("is_rated");
                            boolean isRated = (isRatedObj != null && (Boolean)isRatedObj);
                            
                            if ("Selesai".equals(status)) { 
                                if (!isRated) { 
                        %>
                                    <button class="btn btn-sm text-white px-3" 
                                            style="border-radius: 8px; background-color: #16a34a; border: none;"
                                            data-bs-toggle="modal" 
                                            data-bs-target="#ratingModal_<%= order.get("id") %>">
                                        <i class="bi bi-star-fill me-1"></i> Beri Rating
                                    </button>

                                    <div class="modal fade" id="ratingModal_<%= order.get("id") %>" tabindex="-1">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <form action="<%= request.getContextPath() %>/ReviewServlet" method="post" class="modal-content shadow-lg">
                                                <div class="modal-header border-0 pt-4 px-4">
                                                    <h5 class="modal-title fw-bold">Beri Rating Produk</h5>
                                                    <button type="button" class="btn-close ms-0" data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body p-4">
                                                    <input type="hidden" name="order_id" value="<%= order.get("id") %>">
                                                    <p class="text-muted small mb-2 text-center">Berikan penilaian Anda untuk pesanan ini</p>

                                                    <div class="star-rating mb-4">
                                                        <input type="radio" id="star5_<%= order.get("id") %>" name="rating" value="5" required/>
                                                        <label for="star5_<%= order.get("id") %>"><i class="bi bi-star-fill"></i></label>

                                                        <input type="radio" id="star4_<%= order.get("id") %>" name="rating" value="4"/>
                                                        <label for="star4_<%= order.get("id") %>"><i class="bi bi-star-fill"></i></label>

                                                        <input type="radio" id="star3_<%= order.get("id") %>" name="rating" value="3"/>
                                                        <label for="star3_<%= order.get("id") %>"><i class="bi bi-star-fill"></i></label>

                                                        <input type="radio" id="star2_<%= order.get("id") %>" name="rating" value="2"/>
                                                        <label for="star2_<%= order.get("id") %>"><i class="bi bi-star-fill"></i></label>

                                                        <input type="radio" id="star1_<%= order.get("id") %>" name="rating" value="1"/>
                                                        <label for="star1_<%= order.get("id") %>"><i class="bi bi-star-fill"></i></label>
                                                    </div>

                                                </div>
                                                <div class="modal-footer px-4">
                                                    <button type="button" class="btn btn-light w-100 py-2" data-bs-dismiss="modal" style="border-radius: 10px;">Batal</button>
                                                    <button type="submit" class="btn btn-success w-100 py-2" style="border-radius: 10px; background-color: #28a745;">Kirim Rating</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                            <%
                                } else {
                            %>
                                    <span class="badge bg-light border-0 px-3 py-2" style="font-weight: normal; color: #16a34a">
                                        <i class="bi bi-check-circle-fill me-1"></i> Sudah dinilai
                                    </span>
                        <% 
                                }
                            }
                        %>
                    </div>
                </div>
            <% 
                    }
                } 
            %>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
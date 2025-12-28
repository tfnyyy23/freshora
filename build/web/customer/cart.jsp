<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    List<Map<String, Object>> cartItems = (List<Map<String, Object>>) request.getAttribute("cartItems");
    if (cartItems == null) cartItems = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Keranjang Belanja</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/global.css">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logoFreshora1031.png">
        <style>
            body { background: #f9fafb; }
            .cart-item { background: white; padding: 8px; border-radius: 12px; margin-bottom: 10px; box-shadow: 0 1px 3px rgba(0,0,0,.1); }
            .cart-item img { width: 120px; height: 120px; object-fit: cover; border-radius: 8px; }
            #deleteToast {
                background-color: #fef2f2;
                border: 1px solid #ef4444 !important;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
                min-width: 300px;
            }

            #deleteToast .toast-body {
                color: #991b1b;
                font-weight: 500;
                display: flex;
                align-items: center;
                padding: 12px 16px;
            }

            #deleteToast .bi-exclamation-circle-fill {
                color: #ef4444; 
                font-size: 1.2rem;
            }
            
            .toast-container {
                z-index: 2000;
            }
        </style>
    </head>
    <body>
        
        <!-- HEADER -->
        <nav class="navbar bg-white shadow-sm sticky-top">
            <div class="container">
                <a href="<%= request.getContextPath() %>/CustomerServlet"
                   class="text-decoration-none text-dark d-inline-flex align-items-center">
                    <i " class="bi bi-arrow-left-short fs-3"></i>
                    <span>Kembali</span>
                </a>
            </div>
        </nav>

        <div class="container py-4">
            <h5 class="mb-4">Keranjang Belanja</h5>

            <% if (cartItems.isEmpty()) { %>
                <div class="text-center p-5 bg-white rounded shadow-sm">
                    <p class="text-muted mb-3">Keranjang Anda masih kosong</p>
                    <a style="background-color: #16a34a; color: white; width: 200px;" href="<%= request.getContextPath() %>/ProductServlet" class="btn">Mulai Belanja</a>
                </div>
            <% } else { %>

                <% int totalItems = 0; int totalPrice = 0; %>
                <div class="mb-4">
                    <% for (Map<String, Object> item : cartItems) { 
                           int productId = (int) item.get("productId");
                           String name = (String) item.get("name");
                           int price = (int) item.get("price");
                           int stock = (int) item.get("stock");
                           int quantity = (int) item.get("quantity");
                           String image = (String) item.get("image");
                           totalItems += quantity;
                           totalPrice += price * quantity;
                    %>
                    <div class="cart-item d-flex gap-3 align-items-center">
                        <img src="<%= image %>" alt="<%= name %>">
                        <div class="flex-grow-1">
                            <h6><%= name %></h6>
                            <p style="font-size: 15px; color: #16a34a !important;">Rp <%= String.format("%,d", price) %></p>
                            <div class="d-flex align-items-center gap-2">
                                <form action="CartServlet" method="post" class="d-inline">
                                    <input type="hidden" name="update" value="<%= productId %>">
                                    <input type="hidden" name="quantity" value="<%= quantity - 1 %>">
                                    <button type="submit" class="btn btn-sm btn-light mt-0" <%= quantity <= 1 ? "disabled" : "" %>>
                                        <i class="bi bi-dash"></i>
                                    </button>
                                </form>
                                <span style="font-size: 15px" class="px-2 mt-0"><%= quantity %></span>
                                
                                <form action="CartServlet" method="post" class="d-inline">
                                    <input type="hidden" name="update" value="<%= productId %>">
                                    <input type="hidden" name="quantity" value="<%= quantity + 1 %>">
                                    <button type="submit" class="btn btn-sm btn-light mt-0" <%= quantity >= stock ? "disabled" : "" %>>
                                        <i class="bi bi-plus"></i>
                                    </button>
                                </form>
                                <form id="deleteForm-<%= productId %>" action="CartServlet" method="post" class="d-inline ms-auto">
                                    <input type="hidden" name="delete" value="<%= productId %>">
                                    <button type="button" class="btn btn-sm" onclick="confirmDelete('<%= productId %>', '<%= name %>')">
                                        <i style="color: #dc3545; font-size: 20px;" class="bi bi-trash"></i>
                                    </button>
                                </form>
                            </div>
                            <small class="text-muted">Stok tersedia: <%= stock %></small>
                        </div>
                    </div>
                    <% } %>
                </div>

                <div class="bg-white p-4 rounded shadow-sm">
                    <h6>Ringkasan Belanja</h6>
                    <div style="font-size: 15px;" class="d-flex justify-content-between">
                        <span>Total Barang</span>
                        <span><%= totalItems %> item</span>
                    </div>
                    <div  style="font-size: 15px;" class="d-flex justify-content-between">
                        <span>Total Harga</span>
                        <span>Rp <%= String.format("%,d", totalPrice) %></span>
                    </div>
                    <hr>
                    <div style="font-size: 15px; font-weight: 300px; color: #16a34a" class="d-flex justify-content-between">
                        <span>Total Belanja</span>
                        <span>Rp <%= String.format("%,d", totalPrice) %></span>
                    </div>
                    <form action="<%= request.getContextPath() %>/OrderServlet" method="post">
                        <input type="hidden" name="action" value="checkout">
                        <button class="btn w-100 mt-3"
                                style="background-color:#16a34a;color:white;">
                            Checkout
                        </button>
                    </form>
                </div>

            <% } %>
        </div>
        
        <div class="toast-container position-fixed top-0 start-50 translate-middle-x p-3" style="z-index: 1060;">
            <div id="deleteToast" class="toast align-items-center border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body">
                        <i class="bi bi-exclamation-circle-fill me-2"></i>
                        <span id="deleteToastMessage">Produk dihapus dari keranjang</span>
                    </div>
                    <button type="button" class="btn-close me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            </div>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            function confirmDelete(productId, productName) {
                // 1. Update pesan toast
                document.getElementById('deleteToastMessage').innerText = productName + " dihapus dari keranjang";

                // 2. Tampilkan Toast Merah
                const toastEl = document.getElementById('deleteToast');
                const toast = new bootstrap.Toast(toastEl, { delay: 3000 });
                toast.show();

                // 3. Submit form setelah delay agar toast terlihat
                setTimeout(() => {
                    document.getElementById('deleteForm-' + productId).submit();
                }, 1500); 
            }
        </script>

    </body>
</html>

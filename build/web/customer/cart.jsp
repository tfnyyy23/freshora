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
        <style>
            body { background: #f9fafb; }
            .cart-item { background: white; padding: 8px; border-radius: 12px; margin-bottom: 10px; box-shadow: 0 1px 3px rgba(0,0,0,.1); }
            .cart-item img { width: 120px; height: 120px; object-fit: cover; border-radius: 8px; }
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
                    <a style="background-color: #16a34a; color: white;" href="<%= request.getContextPath() %>/ProductServlet" class="btn w-25">Mulai Belanja</a>
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
                                <form action="CartServlet" method="post" class="d-inline ms-auto">
                                    <input type="hidden" name="delete" value="<%= productId %>">
                                    <button type="submit" class="btn btn-sm"><i style="color: red; font-size: 20px;" class="bi bi-trash"></i></button>
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
                    <a style="background-color: #16a34a; color: white" href="checkout.jsp" class="btn w-100 mt-3">Checkout</a>
                </div>

            <% } %>
        </div>

    </body>
</html>

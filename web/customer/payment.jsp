<%-- 
    Document   : payment
    Created on : 9 Des 2025, 00.25.00
    Author     : ASUS
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, java.util.Locale" %>

<%
    Integer orderId = (Integer) session.getAttribute("order_id");
//    Integer total = (Integer) session.getAttribute("order_total");

    List<Map<String,Object>> orderItems =
        (List<Map<String,Object>>) request.getAttribute("orderItems");
    int total = 0;
    int voucher = 0;
    int kirim = 0;
    
//    if (orderId == null || total == null) {
//        response.sendRedirect(request.getContextPath() + "/CartServlet");
//        return;
//    }

//    NumberFormat rupiah = NumberFormat.getCurrencyInstance(new Locale("id","ID"));
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Halaman Pembayaran</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" href="assets/css/global.css">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logoFreshora1031.png">
        <style>
            body { background:#f9fafb; }

            .payment-card {
                background:white;
                border-radius:16px;
                box-shadow:0 2px 8px rgba(0,0,0,.08);
            }

            .payment-method {
                border:1px solid #e5e7eb;
                border-radius:12px;
                padding:8px;
                display:flex;
                align-items:center;
                gap:15px;
                cursor:pointer;
                transition:.2s;
            }

            .payment-method:hover {
                background:#f9fafb;
            }

            .payment-method.active {
                border-color:#16a34a;
                background:#ecfdf5;
            }

            .payment-method img {
                width:40px;
                height:40px;
                object-fit:contain;
            }
        </style>
    </head>

    <body>

        <!-- HEADER -->
        <nav class="navbar bg-white shadow-sm sticky-top">
            <div class="container">
                <button type="button"
                        onclick="openCancelConfirm()"
                        class="btn btn-link text-decoration-none text-dark d-inline-flex align-items-center p-0">
                    <i class="bi bi-arrow-left-short fs-3"></i>
                    <span>Kembali</span>
                </button>
            </div>
        </nav>


        <div class="container py-4" style="max-width:720px;">

            <h5 class="mb-3">Pembayaran</h5>

            <!-- RINCIAN -->
            <div class="payment-card p-4 mb-4">
                <h6 class="mb-2">Rincian Belanja</h6>
                <!-- LIST PRODUK -->
                <div class="mb-3">
                    <% for (Map<String,Object> item : orderItems) {
                        int price = (int) item.get("price");
                        int qty = (int) item.get("quantity");
                        int subtotal = price * qty;
                        total += subtotal;
                    %>
                    <div style="font-size: 15px;" class="d-flex justify-content-between mb-2 text-muted">
                        <span>
                            <%= item.get("name") %> - 
                            Rp <%= String.format("%,d", price) %> x <%= qty %>
                        </span>
                        <span>
                            Rp <%= String.format("%,d", subtotal) %>
                        </span>
                    </div>
                    <% } %>
                </div>

                <!-- GARIS -->
                <hr class="text-secondary">

                <!-- VOUCHER & ONGKIR -->
                <div style="font-size: 15px;" class="d-flex justify-content-between mb-2 text-muted">
                    <span>Voucher</span>
                    <span>Rp <%= String.format("%,d", voucher) %></span>
                </div>

                <div style="font-size: 15px;" class="d-flex justify-content-between mb-2 text-muted">
                    <span>Ongkos Kirim</span>
                    <span>Rp <%= String.format("%,d", kirim) %></span>
                </div>

                <!-- GARIS -->
                <hr class="text-secondary">

                <!-- TOTAL -->
                <div class="d-flex justify-content-between mb-2">
                    <h6>Total Belanja</h6>
                    <span style="color: #16a34a;">
                        Rp <%= String.format("%,d", total) %>
                    </span>
                </div>
            </div>

            <!-- FORM PAYMENT -->
            <form action="<%= request.getContextPath() %>/PaymentServlet" method="post">

                <input type="hidden" name="order_id" value="<%= orderId %>">
                <input type="hidden" name="amount" value="<%= total %>">

                <div class="payment-card p-4 mb-4">
                    <h6 class="mb-3">Metode Pembayaran</h6>

                    <div class="d-grid gap-2">

                        <label class="payment-method">
                            <input type="radio" name="paymentMethod" value="GoPay" required>
                            <img src="assets/img/gopay.png">
                            <span style="font-size: 15px;">GoPay</span>
                        </label>

                        <label class="payment-method">
                            <input type="radio" name="paymentMethod" value="ShopeePay">
                            <img src="assets/img/shopeepay.png">
                            <span style="font-size: 15px;">ShopeePay</span>
                        </label>

                        <label class="payment-method">
                            <input type="radio" name="paymentMethod" value="DANA">
                            <img src="assets/img/dana.png">
                            <span style="font-size: 15px;">DANA</span>
                        </label>

                        <label class="payment-method">
                            <input type="radio" name="paymentMethod" value="BCA Virtual Account">
                            <img src="assets/img/bca.png">
                            <span style="font-size: 15px;">Bank BCA</span>
                        </label>

                        <label class="payment-method">
                            <input type="radio" name="paymentMethod" value="BRI Virtual Account">
                            <img src="assets/img/bri.png">
                            <span style="font-size: 15px;">Bank BRI</span>
                        </label>

                        <label class="payment-method">
                            <input type="radio" name="paymentMethod" value="Mandiri Virtual Account">
                            <img src="assets/img/mandiri.png">
                            <span style="font-size: 15px;">Bank Mandiri</span>
                        </label>

                        <label class="payment-method">
                            <input type="radio" name="paymentMethod" value="Transfer Bank Lainnya">
                            <i style="font-size: 25px;" class="bi bi-bank2 text-primary"></i>
                            <span style="font-size: 15px;">Transfer Bank Lainnya (via Mandiri)</span>
                        </label>

                    </div>
                </div>

                <button type="submit"
                        class="btn w-100 text-white"
                        style="background-color:#16a34a; height: 40px; border-radius: 12px">
                    Bayar Sekarang
                </button>
            </form>

        </div>
                
        <!-- MODAL KONFIRMASI BATAL -->
        <div class="modal fade" id="cancelModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content rounded-4">
                    <div class="modal-header border-0">
                        <h5 class="modal-title">Batalkan Pesanan?</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p class="mb-0 text-muted">
                            Apakah Anda yakin akan membatalkan pesanan ini?
                        </p>
                    </div>
                    <div class="modal-footer border-0">
                        <!-- TETAP DI PAYMENT -->
                        <button type="button"
                                class="btn btn-outline-secondary"
                                data-bs-dismiss="modal">
                            Tidak
                        </button>

                        <!-- BATAL ORDER -->
                        <form method="post"
                              action="<%= request.getContextPath() %>/PaymentServlet">
                            <input type="hidden" name="action" value="cancel">
                            <button type="submit" class="btn btn-danger">
                                Ya, Batalkan
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script>
            const methods = document.querySelectorAll('.payment-method');
            methods.forEach(m => {
                m.addEventListener('click', () => {
                    methods.forEach(x => x.classList.remove('active'));
                    m.classList.add('active');
                    m.querySelector('input').checked = true;
                });
            });
        </script>
        
        <script>
            function openCancelConfirm() {
                const modal = new bootstrap.Modal(
                    document.getElementById('cancelModal')
                );
                modal.show();
            }
        </script>
    </body>
</html>

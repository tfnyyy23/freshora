<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="models.Product" %>
<%@ page import="models.Category" %>

<%
    List<Product> products = (List<Product>) request.getAttribute("products");
    List<Category> categories = (List<Category>) request.getAttribute("categories");

    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String sortBy = (String) request.getAttribute("sortBy");

    if (selectedCategory == null) selectedCategory = "Semua";
    if (sortBy == null) sortBy = "none";
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Semua Produk</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/global.css">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logoFreshora1031.png">
        <style>
            body { background: #f9fafb; }

            .category-btn {
                border: 1px solid #d1d5db;
                background: white;
                color: #374151;
                transition: all .2s ease;
                white-space: nowrap;
            }

            .category-btn:hover {
                background: #f3f4f6;
            }

            .category-btn.active {
                background: #16a34a !important;
                border-color: #16a34a !important;
                color: white !important;
            }
            
            .filter-input-group .input-group-text,
            .filter-input-group .form-select,
            .filter-input-group .form-control {
                height: 48px;             
                border-radius: 12px;
            }

            .filter-input-group .input-group-text {
                border-right: none;
            }
            
            .filter-input-group .form-select,
            .filter-input-group .form-control {
                border-left: none;
            }
            
            #cartToast {
                background-color: #f0fdf4;
                border: 1px solid #16a34a !important;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
                min-width: 300px;
            }

            #cartToast .toast-body {
                color: #166534;
                font-weight: 500;
                display: flex;
                align-items: center;
                padding: 12px 16px;
            }

            #cartToast .bi-check-circle-fill {
                color: #22c55e;
                font-size: 1.2rem;
                margin-right: 12px;
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
                   
                <a href="<%= request.getContextPath() %>/CartServlet" class="btn position-relative">
                    <i class="bi bi-cart fs-4"></i>
                    <span style="position: absolute; top: 5px; transform: none" class="badge rounded-pill bg-danger pt-1">
                        ${sessionScope.cartCount == null ? 0 : sessionScope.cartCount}
                    </span>
                </a> 
            </div>
        </nav>

        <div class="container py-4">

            <h4 class="mb-4">Semua Produk</h4>

            <!-- ================= CATEGORIES ================= -->
            <div class="mb-4 d-flex gap-2 overflow-auto">
                <% for (Category c : categories) {
                    String cid = String.valueOf(c.getId());
                    boolean isActive = cid.equals(selectedCategory);
                %>

                    <a href="<%= request.getContextPath() %>/ProductServlet?category=<%= cid %>&sort=<%= sortBy %>"
                       class="btn category-btn <%= isActive ? "active" : "" %>">

                        <%= c.getName() %>
                    </a>

                <% } %>
            </div>

            <!-- ================= SORT & SEARCH ================= -->
            <form id="filterForm"
                method="get"
                action="<%= request.getContextPath() %>/ProductServlet"
                class="bg-white p-3 rounded shadow-sm mb-4">

              <input type="hidden" name="category" value="<%= selectedCategory %>">

              <div class="row g-3 align-items-center">

                  <!-- SORT -->
                  <div class="col-md-4">
                      <div class="input-group filter-input-group">
                          <span class="input-group-text bg-white">
                              <i class="bi bi-sliders"></i>
                          </span>
                          <select name="sort"
                                  class="form-select"
                                  onchange="document.getElementById('filterForm').submit()">
                              <option value="none">No Filter</option>
                              <option value="price-low" <%= "price-low".equals(sortBy) ? "selected" : "" %>>
                                  Harga Termurah
                              </option>
                              <option value="price-high" <%= "price-high".equals(sortBy) ? "selected" : "" %>>
                                  Harga Termahal
                              </option>
                              <option value="rating" <%= "rating".equals(sortBy) ? "selected" : "" %>>
                                  Rating Tertinggi
                              </option>
                          </select>
                      </div>
                  </div>

                  <!-- SEARCH -->
                  <div class="col-md-8">
                      <div class="input-group filter-input-group">
                          <span class="input-group-text bg-white">
                              <i class="bi bi-search text-muted"></i>
                          </span>
                          <input type="text"
                                 name="keyword"
                                 value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>"
                                 class="form-control"
                                 placeholder="Cari produk..."
                                 onkeypress="if(event.key==='Enter'){this.form.submit()}">
                      </div>
                  </div>

              </div>
            </form>


            <!-- ================= PRODUCT GRID ================= -->
            <% if (products != null && !products.isEmpty()) { %>
                <div class="row g-3">
                    <% for (Product p : products) {
                        request.setAttribute("product", p);
                    %>
                        <div class="col-6 col-md-4 col-lg-3">
                            <jsp:include page="components/productCard.jsp" />
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="bg-white p-5 text-center rounded">
                    <p class="text-muted">Tidak ada produk dalam kategori ini</p>
                </div>
            <% } %>

        </div>
          
        <div class="toast-container position-fixed top-0 start-50 translate-middle-x p-3" style="z-index: 1060;">
            <div id="cartToast" class="toast align-items-center border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body">
                        <i class="bi bi-check-circle-fill"></i>
                        <span id="toastMessage">Produk ditambahkan ke keranjang</span>
                    </div>
                    <button type="button" class="btn-close me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function addToCart(productId, productName) {
                fetch("<%= request.getContextPath() %>/CartServlet?add=" + productId, {
                    method: "GET",
                    headers: { "X-Requested-With": "XMLHttpRequest" }
                })
                .then(res => res.json())
                .then(data => {
                    // 1. Update Badge Keranjang
                    document.querySelector(".badge.bg-danger").innerText = data.cartCount;

                    // 2. Update Pesan Toast dengan Nama Produk
                    document.getElementById('toastMessage').innerText = productName + " ditambahkan ke keranjang";

                    // 3. Tampilkan Toast
                    const toastEl = document.getElementById('cartToast');
                    const toast = new bootstrap.Toast(toastEl, { delay: 3000 });
                    toast.show();
                })
                .catch(err => console.error(err));
            }
        </script>

    </body>
</html>

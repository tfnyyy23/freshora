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
            
        
        <!-- ================= AJAX CART COUNT ================= -->    
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                const buttons = document.querySelectorAll(".add-to-cart");
                const cartBadge = document.querySelector(".btn.position-relative .badge");

                buttons.forEach(btn => {
                    btn.addEventListener("click", function(e) {
                        e.preventDefault();
                        const productId = this.getAttribute("data-product-id");

                        fetch("<%= request.getContextPath() %>/CartServlet?add=" + productId, {
                            headers: { "X-Requested-With": "XMLHttpRequest" }
                        })

                        .then(res => res.json())
                        .then(data => {
                            cartBadge.textContent = data.cartCount;
                        })
                        .catch(err => console.error(err));
                    });
                });
            });
        </script>
    </body>
</html>

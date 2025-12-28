/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;

import models.Product;
import models.Category;
import classes.JDBC;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import models.User;

import java.sql.*;
import javax.servlet.http.*;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.annotation.MultipartConfig;
import java.io.File;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "ProductServlet", urlPatterns = {"/ProductServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 100   // 100MB
)
public class ProductServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if(user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        // ================== DELETE PRODUK (KHUSUS ADMIN) ==================
        if ("delete".equals(action) && idStr != null && "admin".equals(user.getRole())) {
            JDBC db = new JDBC();
            try {
                db.connect();
                PreparedStatement ps = db.getConnection().prepareStatement("DELETE FROM products WHERE product_id = ?");
                ps.setInt(1, Integer.parseInt(idStr));
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                db.disconnect();
            }
            response.sendRedirect(request.getContextPath() + "/ProductServlet");
            return;
        }
        
        /* ===== AMBIL DATA ===== */
        JDBC db = new JDBC();
     
        List<Product> products = new ArrayList<>();
        List<Category> categories = new ArrayList<>();

        String categoryParam = request.getParameter("category");
        String sort = request.getParameter("sort");
        String keyword = request.getParameter("keyword");
        
        if (categoryParam == null) categoryParam = "0";
        if (sort == null) sort = "none";
        if (keyword == null) keyword = "";
        
        int userId = user.getUserId();
        int cartCount = 0;
        
        try {
            db.connect();
            Connection con = db.getConnection();

            // ================== CATEGORIES ==================
            categories.add(new Category(0, "Semua"));

            ResultSet rsCat = con.createStatement()
                    .executeQuery("SELECT category_id, name FROM categories");

            while (rsCat.next()) {
                categories.add(new Category(
                        rsCat.getInt("category_id"),
                        rsCat.getString("name")
                ));
            }
                
            // ================== PRODUCTS ==================
            StringBuilder sql = new StringBuilder(
                "SELECT * FROM products WHERE 1=1"
            );
            
            // FILTER KATEGORI
            if (!"0".equals(categoryParam)) {
                sql.append(" AND category_id = ").append(categoryParam);
            }

            // SEARCH NAMA PRODUK
            if (!keyword.isEmpty()) {
                sql.append(" AND name LIKE '%").append(keyword).append("%'");
            }

            // SORT
            switch (sort) {
                case "price-low":
                    sql.append(" ORDER BY price ASC");
                    break;
                case "price-high":
                    sql.append(" ORDER BY price DESC");
                    break;
                case "rating":
                    sql.append(" ORDER BY rating DESC");
                    break;
            }

            ResultSet rs = con.createStatement().executeQuery(sql.toString());

            while (rs.next()) {
                products.add(new Product(
                        rs.getInt("product_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getInt("price"),
                        rs.getInt("stock"),
                        rs.getString("image"),
                        rs.getDouble("rating"),
                        rs.getInt("category_id")
                ));
            }
            
            // ================== CART COUNT CUSTOMER ==================
            if (!"admin".equals(user.getRole())) {
                PreparedStatement ps = con.prepareStatement(
                "SELECT SUM(quantity) AS total FROM cart_items c JOIN carts ca ON c.cart_id=ca.cart_id WHERE ca.user_id=?");
                ps.setInt(1, userId);
                ResultSet rse = ps.executeQuery();
                if (rse.next()) cartCount = rse.getInt("total");
                session.setAttribute("cartCount", cartCount);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        } finally {
            db.disconnect();
        }

        // ================== KIRIM KE VIEW BERDASARKAN ROLE ==================
        request.setAttribute("categories", categories);
        request.setAttribute("selectedCategory", categoryParam);
        request.setAttribute("sortBy", sort);
        request.setAttribute("products", products);
        request.setAttribute("productList", products);

        if ("admin".equals(user.getRole())) {
            request.getRequestDispatcher("admin/products.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("customer/allProduct.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String name  = request.getParameter("name");
        int catId    = Integer.parseInt(request.getParameter("category_id"));
        int stock    = Integer.parseInt(request.getParameter("stock"));
        String desc  = request.getParameter("description");
        
        String img = "";
        String imageUrl = request.getParameter("image_url"); 
        String imageOld = request.getParameter("image_old");
        Part filePart = request.getPart("image_file");

        if (filePart != null && filePart.getSize() > 0) {
            // PRIORITAS 1: Jika ada upload file baru dari laptop
            String fileName = System.currentTimeMillis() + "_" + getFileName(filePart);
            String uploadPath = getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "img";

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            filePart.write(uploadPath + File.separator + fileName);
            img = fileName; 
        } else if (imageUrl != null && !imageUrl.isEmpty()) {
            // PRIORITAS 2: Jika tidak ada file, tapi URL diisi
            img = imageUrl;
        } else {
            // PRIORITAS 3: Jika dua-duanya kosong (saat edit), pakai gambar lama
            img = imageOld;
        }

        int price;
        try {
            price = Integer.parseInt(request.getParameter("price"));
        } catch (Exception e) {
            price = 0;
        }

        JDBC db = new JDBC();
        try {
            db.connect();
            Connection con = db.getConnection();

            if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                PreparedStatement ps = con.prepareStatement(
                    "UPDATE products SET name=?, category_id=?, price=?, stock=?, description=?, image=? " +
                    "WHERE product_id=?"
                );
                ps.setString(1, name);
                ps.setInt(2, catId);
                ps.setInt(3, price);
                ps.setInt(4, stock);
                ps.setString(5, desc);
                ps.setString(6, img);
                ps.setInt(7, id);
                ps.executeUpdate();

            } else {
                PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO products (name, category_id, price, stock, description, image, rating) " +
                    "VALUES (?, ?, ?, ?, ?, ?, 0.0)"
                );
                ps.setString(1, name);
                ps.setInt(2, catId);
                ps.setInt(3, price);
                ps.setInt(4, stock);
                ps.setString(5, desc);
                ps.setString(6, img);
                ps.executeUpdate();
            }

        } catch (SQLException e) {
            throw new ServletException(e);
        } finally {
            db.disconnect();
        }

        response.sendRedirect(request.getContextPath() + "/ProductServlet");
    }
    
    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return "default.jpg";
    }
}

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
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ProductServlet", urlPatterns = {"/ProductServlet"})
public class ProductServlet extends HttpServlet {

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

        // ================== LOGIKA HAPUS (KHUSUS ADMIN) ==================
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

        // ================== LOGIKA TAMPIL DATA ==================
        JDBC db = new JDBC();
        db.connect();
        List<Product> products = new ArrayList<>();
        List<Category> categories = new ArrayList<>();
        
        try {
            Connection con = db.getConnection();
            
            // Ambil Kategori
            categories.add(new Category(0, "Semua"));
            ResultSet rsCat = con.createStatement().executeQuery("SELECT * FROM categories");
            while (rsCat.next()) {
                categories.add(new Category(rsCat.getInt("category_id"), rsCat.getString("name")));
            }

            // Ambil Produk
            String categoryParam = (request.getParameter("category") == null) ? "0" : request.getParameter("category");
            StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1");
            if (!"0".equals(categoryParam)) sql.append(" AND category_id = ").append(categoryParam);
            
            ResultSet rs = con.createStatement().executeQuery(sql.toString());
            while (rs.next()) {
                products.add(new Product(
                    rs.getInt("product_id"), rs.getString("name"), rs.getString("description"),
                    rs.getInt("price"), rs.getInt("stock"), rs.getString("image"),
                    rs.getDouble("rating"), rs.getInt("category_id")
                ));
            }

            // Hitung Cart jika User adalah Customer
            if (!"admin".equals(user.getRole())) {
                PreparedStatement ps = con.prepareStatement("SELECT SUM(quantity) AS total FROM cart_items c JOIN carts ca ON c.cart_id=ca.cart_id WHERE ca.user_id=?");
                ps.setInt(1, user.getUserId());
                ResultSet rse = ps.executeQuery();
                if (rse.next()) session.setAttribute("cartCount", rse.getInt("total"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }

        request.setAttribute("categories", categories);
        request.setAttribute("productList", products); // Untuk Admin
        request.setAttribute("products", products);    // Untuk Customer

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
        String name = request.getParameter("name");
        int catId = Integer.parseInt(request.getParameter("category_id"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        String desc = request.getParameter("description");
        String img = request.getParameter("image");

        // VALIDASI HARGA AGAR TIDAK ERROR 500 LAGI
        int price = 0;
        try {
            String priceStr = request.getParameter("price");
            // Cek jika angka terlalu panjang untuk Integer
            if (priceStr.length() > 9) {
                price = 999999999; // Set ke batas maksimal aman jika input ngawur
            } else {
                price = Integer.parseInt(priceStr);
            }
        } catch (Exception e) {
            price = 0;
        }

        JDBC db = new JDBC();
        try {
            db.connect();
            Connection con = db.getConnection();
            if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String sql = "UPDATE products SET name=?, category_id=?, price=?, stock=?, description=?, image=? WHERE product_id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, name); ps.setInt(2, catId); ps.setInt(3, price);
                ps.setInt(4, stock); ps.setString(5, desc); ps.setString(6, img); ps.setInt(7, id);
                ps.executeUpdate();
            } else {
                String sql = "INSERT INTO products (name, category_id, price, stock, description, image, rating) VALUES (?, ?, ?, ?, ?, ?, 0.0)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, name); ps.setInt(2, catId); ps.setInt(3, price);
                ps.setInt(4, stock); ps.setString(5, desc); ps.setString(6, img);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }
        response.sendRedirect(request.getContextPath() + "/ProductServlet");
    }
}
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

@WebServlet(name = "ProductServlet", urlPatterns = {"/ProductServlet"})
public class ProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        JDBC db = new JDBC();
        db.connect();

        if (!db.isConnected()) {
            throw new ServletException("DB connection failed: " + db.getMessage());
        }

        List<Product> products = new ArrayList<>();
        List<Category> categories = new ArrayList<>();

        String categoryParam = request.getParameter("category");
        String sort = request.getParameter("sort");

        if (categoryParam == null) categoryParam = "0";
        if (sort == null) sort = "none";

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if(user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int userId = user.getUserId();

        int cartCount = 0;
        
        try {
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
            String keyword = request.getParameter("keyword");
            if (keyword == null) keyword = "";

            StringBuilder sql = new StringBuilder(
                "SELECT * FROM products WHERE 1=1"
            );
            
            if (!"0".equals(categoryParam)) {
                sql.append(" AND category_id = ").append(categoryParam);
            }

            if (!keyword.isEmpty()) {
                sql.append(" AND name LIKE '%").append(keyword).append("%'");
            }

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
            
            // ================== CART ==================
            // Hanya jalankan query cart jika user adalah customer
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

        // ================== SEND TO VIEW BERDASARKAN ROLE ==================
        request.setAttribute("categories", categories);
        request.setAttribute("selectedCategory", categoryParam);
        request.setAttribute("sortBy", sort);

        if (user != null && "admin".equals(user.getRole())) {
            // Nama attribute disesuaikan dengan loop di admin/products.jsp
            request.setAttribute("productList", products); 
            request.getRequestDispatcher("admin/products.jsp").forward(request, response);
        } else {
            // Default untuk customer
            request.setAttribute("products", products);
            request.getRequestDispatcher("customer/allProduct.jsp").forward(request, response);
        }
    }
}
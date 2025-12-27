/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;

import classes.JDBC;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import models.User;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "ProfileServlet", urlPatterns = {"/ProfileServlet"})
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = user.getUserId();
        
        JDBC db = new JDBC();
        db.connect();

        try {
            Connection conn = db.getConnection();

            /* ================= USER INFO ================= */
            PreparedStatement psUser = conn.prepareStatement(
                "SELECT user_id, name, username, email, phone, address " +
                "FROM users WHERE user_id=?"
            );
            psUser.setInt(1, userId);

            ResultSet rsUser = psUser.executeQuery();
            if (rsUser.next()) {
                Map<String, Object> userData = new HashMap<>();
                userData.put("name", rsUser.getString("name"));
                userData.put("username", rsUser.getString("username"));
                userData.put("email", rsUser.getString("email"));
                userData.put("phone", rsUser.getString("phone"));
                userData.put("address", rsUser.getString("address"));

                request.setAttribute("userData", userData);
            }
            
            if ("edit".equals(action)) {
                request.getRequestDispatcher("/customer/editProfile.jsp").forward(request, response);
            } else {

                /* ================= ORDER HISTORY ================= */
                PreparedStatement psOrder = conn.prepareStatement(
                    "SELECT order_id, total, status, order_status, order_date, is_rated " + // Tambahkan is_rated di sini
                    "FROM orders WHERE user_id=? ORDER BY order_date DESC"
                );
                psOrder.setInt(1, userId);
                ResultSet rsOrder = psOrder.executeQuery();

                List<Map<String, Object>> orders = new ArrayList<>();

                while (rsOrder.next()) {
                    Map<String, Object> order = new HashMap<>();

                    int orderId = rsOrder.getInt("order_id");

                    order.put("id", orderId);
                    order.put("total", rsOrder.getInt("total"));
                    order.put("paymentStatus", rsOrder.getString("status"));       // paid/pending
                    order.put("status", rsOrder.getString("order_status"));        // Diproses/Dikirim/Selesai
                    order.put("date", rsOrder.getTimestamp("order_date"));
                    order.put("is_rated", rsOrder.getBoolean("is_rated"));

                    /* ================= ORDER ITEMS ================= */
                    PreparedStatement psItem = conn.prepareStatement(
                        "SELECT p.name, oi.quantity, oi.price " +
                        "FROM order_items oi " +
                        "JOIN products p ON oi.product_id = p.product_id " +
                        "WHERE oi.order_id=?"
                    );
                    psItem.setInt(1, orderId);

                    ResultSet rsItem = psItem.executeQuery();
                    List<Map<String, Object>> items = new ArrayList<>();

                    while (rsItem.next()) {
                        Map<String, Object> item = new HashMap<>();
                        item.put("name", rsItem.getString("name"));
                        item.put("quantity", rsItem.getInt("quantity"));
                        item.put("price", rsItem.getInt("price"));
                        items.add(item);
                    }

                    order.put("items", items);
                    orders.add(order);
                }

                request.setAttribute("orders", orders);

                request.getRequestDispatcher("/customer/profile.jsp")
                       .forward(request, response);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        } finally {
            db.disconnect();
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) { response.sendRedirect("login.jsp"); return; }

        // Tangkap data dari form
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");

        JDBC db = new JDBC();
        db.connect();
        try {
            Connection conn = db.getConnection();
            String sql;
            
            // Logika: Jika password diisi, update password juga
            if (password != null && !password.isEmpty()) {
                sql = "UPDATE users SET name=?, username=?, email=?, phone=?, address=?, password=? WHERE user_id=?";
            } else {
                sql = "UPDATE users SET name=?, username=?, email=?, phone=?, address=? WHERE user_id=?";
            }

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, username);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, address);
            
            if (password != null && !password.isEmpty()) {
                ps.setString(6, password);
                ps.setInt(7, user.getUserId());
            } else {
                ps.setInt(6, user.getUserId());
            }

            int rowsUpdated = ps.executeUpdate();
            if (rowsUpdated > 0) {
                // Update object user di session agar nama di navbar langsung berubah
                user.setName(name);
                session.setAttribute("user", user);
                
                // Redirect kembali ke profile dengan pesan sukses (bisa ditambah toast)
                response.sendRedirect("ProfileServlet"); 
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        } finally {
            db.disconnect();
        }
    }
}
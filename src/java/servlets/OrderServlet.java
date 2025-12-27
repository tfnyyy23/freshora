/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;

import classes.JDBC;
import models.User;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "OrderServlet", urlPatterns = {"/OrderServlet"})
public class OrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Proteksi: Cek login
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Map<String, Object>> orders = new ArrayList<>();
        JDBC db = new JDBC();
        
        try {
            db.connect();
            Connection con = db.getConnection();

            // Query untuk mendapatkan data pesanan + Nama Customer
            // Sesuaikan nama tabel 'orders' dan 'users' di DB kamu
            String sql = "SELECT o.order_id, u.name as customer_name, o.total_price, o.status, o.order_date " +
                         "FROM orders o " +
                         "JOIN users u ON o.user_id = u.user_id " +
                         "ORDER BY o.order_date DESC";

            ResultSet rs = con.createStatement().executeQuery(sql);

            while (rs.next()) {
                Map<String, Object> order = new HashMap<>();
                order.put("orderId", rs.getInt("order_id"));
                order.put("customerName", rs.getString("customer_name"));
                order.put("total", rs.getInt("total_price"));
                order.put("status", rs.getString("status"));
                order.put("date", rs.getTimestamp("order_date"));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }

        request.setAttribute("orderList", orders);
        
        // Cek Role: Admin ke halaman manajemen, Customer ke riwayat belanja (jika ada)
        if ("admin".equals(user.getRole())) {
            request.getRequestDispatcher("admin/orders.jsp").forward(request, response);
        } else {
            // Halaman riwayat pesanan untuk customer (opsional)
            request.getRequestDispatcher("ProfileServlet").forward(request, response);
        }
    }
}
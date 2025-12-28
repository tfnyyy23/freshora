package servlets;

import classes.JDBC;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;

@WebServlet(name = "AdminServlet", urlPatterns = {"/AdminServlet"})
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        JDBC db = new JDBC();
        db.connect();
        List<Map<String, Object>> orders = new ArrayList<>();

        try {
            Connection conn = db.getConnection();

            // 1. STATISTIK
            // Gunakan statement yang berbeda atau tutup RS setelah dipakai
            ResultSet rsStat = conn.createStatement().executeQuery("SELECT COUNT(*) FROM products");
            if (rsStat.next()) request.setAttribute("totalProduk", rsStat.getInt(1));

            rsStat = conn.createStatement().executeQuery("SELECT COUNT(*) FROM users WHERE role='customer'");
            if (rsStat.next()) request.setAttribute("totalCustomer", rsStat.getInt(1));

            rsStat = conn.createStatement().executeQuery("SELECT COUNT(*) FROM orders");
            if (rsStat.next()) request.setAttribute("totalPesanan", rsStat.getInt(1));

            rsStat = conn.createStatement().executeQuery("SELECT SUM(total) FROM orders WHERE status='paid'");
            if (rsStat.next()) request.setAttribute("totalPendapatan", rsStat.getInt(1));
            
            rsStat.close();

            // 2. PESANAN TERBARU (Hanya gunakan satu Query yang paling tepat)
            // Query ini mengambil 3 pesanan terbaru yang statusnya Paid dan Sedang diproses/dikirim
            String sqlOrders = 
                "SELECT o.order_id, u.name AS customer_name, o.total, o.order_status, o.order_date " +
                "FROM orders o " +
                "JOIN users u ON o.user_id = u.user_id " +
                "WHERE o.status = 'paid' " +
                "AND o.order_status IN ('Diproses','Dikirim') " +
                "ORDER BY o.order_date DESC " +
                "LIMIT 3";
            
            PreparedStatement ps = conn.prepareStatement(sqlOrders);
            ResultSet rsO = ps.executeQuery();
            
            while (rsO.next()) {
                Map<String, Object> o = new HashMap<>();
                o.put("orderId", rsO.getInt("order_id"));
                o.put("customerName", rsO.getString("customer_name"));
                o.put("total", rsO.getInt("total"));
                o.put("order_status", rsO.getString("order_status"));
                o.put("date", rsO.getTimestamp("order_date"));
                orders.add(o);
            }
            rsO.close();
            ps.close();

            request.setAttribute("orders", orders);
            
            // Forward ke JSP
            request.getRequestDispatcher("admin/dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            // Jika error, kirim pesan ke dashboard agar tidak blank
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("admin/dashboard.jsp").forward(request, response);
        } finally {
            db.disconnect();
        }
    }
}
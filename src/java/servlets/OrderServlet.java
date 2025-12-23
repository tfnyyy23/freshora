/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;

import models.User;
import classes.JDBC;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "OrderServlet", urlPatterns = {"/OrderServlet"})
public class OrderServlet extends HttpServlet {

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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = user.getUserId();

        JDBC db = new JDBC();
        db.connect();

        try {
            Connection con = db.getConnection();
            con.setAutoCommit(false);

            // Ambil cart user
            int cartId = 0;
            PreparedStatement psCart = con.prepareStatement(
                    "SELECT cart_id FROM carts WHERE user_id=?");
            psCart.setInt(1, userId);
            ResultSet rsCart = psCart.executeQuery();
            if (rsCart.next()) {
                cartId = rsCart.getInt("cart_id");
            } else {
                response.sendRedirect(request.getContextPath() + "/CartServlet");
                return;
            }

            // Ambil item cart
            PreparedStatement psItems = con.prepareStatement(
                    "SELECT ci.product_id, ci.quantity, p.price " +
                    "FROM cart_items ci JOIN products p ON ci.product_id = p.product_id " +
                    "WHERE ci.cart_id=?");
            psItems.setInt(1, cartId);
            ResultSet rsItems = psItems.executeQuery();

            List<Map<String, Object>> items = new ArrayList<>();
            int total = 0;

            while (rsItems.next()) {
                int productId = rsItems.getInt("product_id");
                int qty = rsItems.getInt("quantity");
                int price = rsItems.getInt("price");

                total += qty * price;

                Map<String, Object> item = new HashMap<>();
                item.put("productId", productId);
                item.put("quantity", qty);
                item.put("price", price);
                items.add(item);
            }

            if (items.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/CartServlet");
                return;
            }

            // Insert orders
            PreparedStatement psOrder = con.prepareStatement(
                    "INSERT INTO orders (user_id, total, status) VALUES (?, ?, 'pending')",
                    Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, userId);
            psOrder.setInt(2, total);
            psOrder.executeUpdate();

            ResultSet rsOrder = psOrder.getGeneratedKeys();
            rsOrder.next();
            int orderId = rsOrder.getInt(1);

            // Insert order_items
            PreparedStatement psItem = con.prepareStatement(
                    "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?,?,?,?)");

            for (Map<String, Object> item : items) {
                psItem.setInt(1, orderId);
                psItem.setInt(2, (int) item.get("productId"));
                psItem.setInt(3, (int) item.get("quantity"));
                psItem.setInt(4, (int) item.get("price"));
                psItem.addBatch();
            }
            psItem.executeBatch();

            // Kosongkan Cart
            PreparedStatement psClear = con.prepareStatement(
                    "DELETE FROM cart_items WHERE cart_id=?");
            psClear.setInt(1, cartId);
            psClear.executeUpdate();

            con.commit();

            // Simpan order ke session
            session.setAttribute("order_id", orderId);
            session.setAttribute("order_total", total);

            response.sendRedirect(request.getContextPath() + "/PaymentServlet");

        } catch (SQLException e) {
            throw new ServletException(e);
        } finally {
            db.disconnect();
        }
    }
    
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
            request.getRequestDispatcher("customer/myOrders.jsp").forward(request, response);
        }
    }
}
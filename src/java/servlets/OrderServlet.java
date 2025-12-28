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

    // =========================
    // GET → MENAMPILKAN DATA
    // =========================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Map<String, Object>> orders = new ArrayList<>();
        JDBC db = new JDBC();

        try {
            db.connect();
            Connection con = db.getConnection();

            String sql;
            PreparedStatement ps;

            if ("admin".equalsIgnoreCase(user.getRole())) {
                sql =
                    "SELECT o.order_id, u.name AS customer_name, o.total, o.status, " +
                    "o.order_status, o.order_date " +
                    "FROM orders o JOIN users u ON o.user_id = u.user_id " +
                    "WHERE o.status = 'paid' " +
                    "ORDER BY o.order_date DESC";
                ps = con.prepareStatement(sql);
            } else {
                sql =
                    "SELECT o.order_id, o.total, o.status, o.order_status, o.order_date " +
                    "FROM orders o WHERE o.user_id = ? " +
                    "ORDER BY o.order_date DESC";
                ps = con.prepareStatement(sql);
                ps.setInt(1, user.getUserId());
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> o = new HashMap<>();
                o.put("orderId", rs.getInt("order_id"));
                o.put("customerName", rs.getString("customer_name"));
                o.put("total", rs.getInt("total"));
                o.put("status", rs.getString("status"));
                o.put("order_status", rs.getString("order_status"));
                o.put("date", rs.getTimestamp("order_date"));
                orders.add(o);
            }

            request.setAttribute("orders", orders);

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }

        if ("admin".equalsIgnoreCase(user.getRole())) {
            request.getRequestDispatcher("admin/orders.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("customer/myOrders.jsp").forward(request, response);
        }
    }

    // =========================
    // POST → UPDATE STATUS / CHECKOUT
    // =========================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        // =========================
        // ADMIN → UPDATE ORDER STATUS
        // =========================
        if ("updateStatus".equals(action) && "admin".equalsIgnoreCase(user.getRole())) {

            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String orderStatus = request.getParameter("order_status");

            JDBC db = new JDBC();
            try {
                db.connect();
                Connection con = db.getConnection();

                PreparedStatement ps = con.prepareStatement(
                    "UPDATE orders SET order_status=? WHERE order_id=?");
                ps.setString(1, orderStatus);
                ps.setInt(2, orderId);
                ps.executeUpdate();

            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                db.disconnect();
            }

            // ⬅️ KEMBALI KE HALAMAN ORDER ADMIN
            response.sendRedirect("OrderServlet");
            return;
        }

        // =========================
        // CUSTOMER → CHECKOUT
        // =========================
        if ("checkout".equals(action)) {
            JDBC db = new JDBC();
            db.connect();
            try {
                Connection con = db.getConnection();
                con.setAutoCommit(false);

                // 1. Cari Cart ID
                int cartId = 0;
                PreparedStatement psCart = con.prepareStatement("SELECT cart_id FROM carts WHERE user_id=?");
                psCart.setInt(1, user.getUserId());
                ResultSet rsCart = psCart.executeQuery();
                if (rsCart.next()) cartId = rsCart.getInt("cart_id");

                // 2. Ambil Item dari Cart
                PreparedStatement psItems = con.prepareStatement(
                    "SELECT ci.product_id, ci.quantity, p.price FROM cart_items ci " +
                    "JOIN products p ON ci.product_id = p.product_id WHERE ci.cart_id=?");
                psItems.setInt(1, cartId);
                ResultSet rsItems = psItems.executeQuery();

                List<Map<String, Object>> items = new ArrayList<>();
                int total = 0;
                while (rsItems.next()) {
                    int price = rsItems.getInt("price");
                    int qty = rsItems.getInt("quantity");
                    total += (price * qty);

                    Map<String, Object> item = new HashMap<>();
                    item.put("pid", rsItems.getInt("product_id"));
                    item.put("qty", qty);
                    item.put("prc", price);
                    items.add(item);
                }

                if (items.isEmpty()) {
                    response.sendRedirect("CartServlet");
                    return;
                }

                // 3. Simpan ke tabel Orders
                PreparedStatement psOrder = con.prepareStatement(
                    "INSERT INTO orders (user_id, total, status, order_status) VALUES (?, ?, 'pending', 'Diproses')", 
                    Statement.RETURN_GENERATED_KEYS);
                psOrder.setInt(1, user.getUserId());
                psOrder.setInt(2, total);
                psOrder.executeUpdate();

                ResultSet rsGen = psOrder.getGeneratedKeys();
                rsGen.next();
                int orderId = rsGen.getInt(1);

                // 4. Simpan ke tabel Order_items
                PreparedStatement psOI = con.prepareStatement(
                    "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?,?,?,?)");
                for (Map<String, Object> i : items) {
                    psOI.setInt(1, orderId);
                    psOI.setInt(2, (int) i.get("pid"));
                    psOI.setInt(3, (int) i.get("qty"));
                    psOI.setInt(4, (int) i.get("prc"));
                    psOI.addBatch();
                }
                psOI.executeBatch();

                // 5. Kosongkan Keranjang
                PreparedStatement psDel = con.prepareStatement("DELETE FROM cart_items WHERE cart_id=?");
                psDel.setInt(1, cartId);
                psDel.executeUpdate();

                con.commit();

                session.setAttribute("order_id", orderId);
                session.setAttribute("order_total", total);
                response.sendRedirect("PaymentServlet");

            } catch (SQLException e) {
                e.printStackTrace();
                throw new ServletException(e);
            } finally {
                db.disconnect();
            }
        }
    }
}

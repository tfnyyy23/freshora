/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;

import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import payments.*;
import classes.JDBC;
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
@WebServlet(name = "PaymentServlet", urlPatterns = {"/PaymentServlet"})
public class PaymentServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
     // TAMPILKAN HALAMAN PAYMENT
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer orderId = (Integer) request.getSession().getAttribute("order_id");
        if (orderId == null) {
            response.sendRedirect("customer/cart.jsp");
            return;
        }

        JDBC db = new JDBC();
        db.connect();

        try {
            PreparedStatement ps = db.getConnection().prepareStatement(
                "SELECT p.name, oi.quantity, oi.price " +
                "FROM order_items oi " +
                "JOIN products p ON oi.product_id = p.product_id " +
                "WHERE oi.order_id=?");
            ps.setInt(1, orderId);

            ResultSet rs = ps.executeQuery();
            List<Map<String, Object>> items = new ArrayList<>();

            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("name", rs.getString("name"));
                item.put("quantity", rs.getInt("quantity"));
                item.put("price", rs.getInt("price"));
                items.add(item);
            }

            request.setAttribute("orderItems", items);

            request.getRequestDispatcher("customer/payment.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(e);
        } finally {
            db.disconnect();
        }
    }

    // PROSES PEMBAYARAN / BATAL
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        JDBC db = new JDBC();
        db.connect();

        Connection conn = null;
        boolean success = false;

        try {
            conn = db.getConnection();
            conn.setAutoCommit(false);

            // ================= CANCEL =================
            if ("cancel".equals(action)) {
                Integer orderId = (Integer) request.getSession().getAttribute("order_id");

                if (orderId != null) {
                    PreparedStatement ps = conn.prepareStatement(
                        "UPDATE orders SET status='CANCELLED' WHERE order_id=?"
                    );
                    ps.setInt(1, orderId);
                    ps.executeUpdate();
                }

                conn.commit();
                request.getSession().removeAttribute("order_id");
                response.sendRedirect(request.getContextPath() + "/CartServlet");
                return;
            }

            // ================= PAYMENT =================
            int orderId = (int) request.getSession().getAttribute("order_id");
            int amount = Integer.parseInt(request.getParameter("amount"));
            String method = request.getParameter("paymentMethod");

            Payable payment;
            switch (method) {
                case "GoPay": payment = new GoPayPayment(); break;
                case "ShopeePay": payment = new ShopeePayPayment(); break;
                case "DANA": payment = new DanaPayment(); break;
                case "BCA Virtual Account": payment = new VirtualAccountPayment("BCA"); break;
                case "BRI Virtual Account": payment = new VirtualAccountPayment("BRI"); break;
                case "Mandiri Virtual Account": payment = new VirtualAccountPayment("Mandiri"); break;
                case "Transfer Bank Lainnya": payment = new BankTransferPayment("Mandiri"); break;
                default: throw new ServletException("Metode tidak valid");
            }

            success = payment.pay(orderId, amount);

            // INSERT PAYMENT
            PreparedStatement psPay = conn.prepareStatement(
                "INSERT INTO payments (order_id, method, payment_status) VALUES (?, ?, ?)"
            );
            psPay.setInt(1, orderId);
            psPay.setString(2, payment.getMethod());
            psPay.setString(3, success ? "success" : "failed");
            psPay.executeUpdate();

            if (success) {
                // UPDATE ORDER
                PreparedStatement psOrder = conn.prepareStatement(
                    "UPDATE orders SET status='paid', order_status='Diproses' WHERE order_id=?"
                );
                psOrder.setInt(1, orderId);
                psOrder.executeUpdate();

                // UPDATE STOCK
                PreparedStatement psItems = conn.prepareStatement(
                    "SELECT product_id, quantity FROM order_items WHERE order_id=?"
                );
                psItems.setInt(1, orderId);
                ResultSet rs = psItems.executeQuery();

                while (rs.next()) {
                    int productId = rs.getInt("product_id");
                    int qty = rs.getInt("quantity");

                    PreparedStatement psStock = conn.prepareStatement(
                        "UPDATE products SET stock = stock - ? WHERE product_id=? AND stock >= ?"
                    );
                    psStock.setInt(1, qty);
                    psStock.setInt(2, productId);
                    psStock.setInt(3, qty);

                    int updated = psStock.executeUpdate();
                    if (updated == 0) {
                        throw new SQLException("Stok tidak cukup");
                    }
                }
            }

            conn.commit();
            request.getSession().removeAttribute("order_id");

            response.sendRedirect(
                request.getContextPath() +
                (success ? "/customer/paymentSuccess.jsp" : "/customer/payment.jsp?error=true")
            );

        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ignored) {}
            throw new ServletException(e);
        } finally {
            db.disconnect();
        }
    }     
}
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;

import models.User;
import classes.JDBC;
import java.sql.*;
import javax.servlet.*;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "ReviewServlet", urlPatterns = {"/ReviewServlet"})
public class ReviewServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String orderIdStr = request.getParameter("order_id");
        String ratingStr  = request.getParameter("rating");

        if (orderIdStr == null || ratingStr == null) {
            response.sendRedirect("ProfileServlet?error=invalid");
            return;
        }

        int orderId = Integer.parseInt(orderIdStr);
        int rating  = Integer.parseInt(ratingStr);

        JDBC db = new JDBC();
        db.connect();

        try {
            Connection conn = db.getConnection();

            /* ================= CEK SUDAH PERNAH RATING ATAU BELUM ================= */
            PreparedStatement check = conn.prepareStatement(
                "SELECT COUNT(*) FROM reviews WHERE order_id=? AND user_id=?"
            );
            check.setInt(1, orderId);
            check.setInt(2, user.getUserId());

            ResultSet rsCheck = check.executeQuery();
            if (rsCheck.next() && rsCheck.getInt(1) > 0) {
                response.sendRedirect("ProfileServlet?error=already_rated");
                return;
            }

            /* ================= AMBIL PRODUCT_ID DARI ORDER ================= */
            PreparedStatement psProduct = conn.prepareStatement(
                "SELECT product_id FROM order_items WHERE order_id=?"
            );
            psProduct.setInt(1, orderId);
            ResultSet rsProduct = psProduct.executeQuery();

            while (rsProduct.next()) {
                int productId = rsProduct.getInt("product_id");

                /* ================= INSERT REVIEW ================= */
                PreparedStatement psInsert = conn.prepareStatement(
                    "INSERT INTO reviews (order_id, product_id, user_id, rating) VALUES (?, ?, ?, ?)"
                );
                psInsert.setInt(1, orderId);
                psInsert.setInt(2, productId);
                psInsert.setInt(3, user.getUserId());
                psInsert.setInt(4, rating);
                psInsert.executeUpdate();

                /* ================= UPDATE AVG RATING PRODUCT ================= */
                PreparedStatement psUpdateRating = conn.prepareStatement(
                    "UPDATE products p SET rating = (" +
                    "SELECT AVG(r.rating) FROM reviews r WHERE r.product_id = p.product_id" +
                    ") WHERE p.product_id = ?"
                );
                psUpdateRating.setInt(1, productId);
                psUpdateRating.executeUpdate();
            }

            /* ================= TANDAI ORDER SUDAH DIRATING ================= */
            PreparedStatement psOrder = conn.prepareStatement(
                "UPDATE orders SET is_rated = true WHERE order_id=?"
            );
            psOrder.setInt(1, orderId);
            psOrder.executeUpdate();

            response.sendRedirect("ProfileServlet?success=rating");

        } catch (SQLException e) {
            throw new ServletException(e);
        } finally {
            db.disconnect();
        }
    }
}

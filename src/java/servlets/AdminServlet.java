/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;

import classes.JDBC;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
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
@WebServlet(name = "AdminServlet", urlPatterns = {"/AdminServlet"})
public class AdminServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        JDBC db = new JDBC();
        db.connect();
        try {
            Connection conn = db.getConnection();
            
            // 1. Hitung Total Produk
            ResultSet rs1 = conn.createStatement().executeQuery("SELECT COUNT(*) FROM products");
            if(rs1.next()) request.setAttribute("totalProduk", rs1.getInt(1));

            // 2. Hitung Total Customer
            ResultSet rs2 = conn.createStatement().executeQuery("SELECT COUNT(*) FROM users WHERE role='customer'");
            if(rs2.next()) request.setAttribute("totalCustomer", rs2.getInt(1));

            // 3. Hitung Total Pesanan
            ResultSet rs3 = conn.createStatement().executeQuery("SELECT COUNT(*) FROM orders");
            if(rs3.next()) request.setAttribute("totalPesanan", rs3.getInt(1));

            // 4. Hitung Total Pendapatan
            ResultSet rs4 = conn.createStatement().executeQuery("SELECT SUM(total) FROM orders WHERE status='paid'");
            if(rs4.next()) request.setAttribute("totalPendapatan", rs4.getInt(1));

            // Forward ke halaman JSP
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }
    }
}
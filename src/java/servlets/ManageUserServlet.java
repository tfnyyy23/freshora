/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;

import classes.JDBC;
import models.User;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "ManageUserServlet", urlPatterns = {"/ManageUserServlet"})
public class ManageUserServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        // Logika Hapus
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            JDBC db = new JDBC();
            try {
                db.connect();
                PreparedStatement ps = db.getConnection().prepareStatement("DELETE FROM users WHERE user_id = ?");
                ps.setInt(1, id);
                ps.executeUpdate();
            } catch (Exception e) { e.printStackTrace(); }
            finally { db.disconnect(); }
            response.sendRedirect("ManageUserServlet");
            return;
        }
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User admin = (User) session.getAttribute("user");
        if (!"admin".equals(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        List<User> customerList = new ArrayList<>();
        JDBC db = new JDBC();

        try {
            db.connect();
            Connection conn = db.getConnection(); // Ambil koneksi sekali saja

            // --- 1. AMBIL DATA LIST User ---
            String sql = "SELECT * FROM users ORDER BY user_id DESC";
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setName(rs.getString("name"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setAddress(rs.getString("address"));
                u.setRole(rs.getString("role"));
                customerList.add(u);
            }

            // --- 2. HITUNG STATISTIK RATA-RATA (DILUAR WHILE) ---
            String sql_avg = "SELECT " +
                         "IFNULL((SELECT COUNT(*) FROM orders) / NULLIF(COUNT(*), 0), 0) as avg_order, " +
                         "IFNULL((SELECT AVG(total) FROM orders WHERE status='paid'), 0) as avg_spend " +
                         "FROM users WHERE role='customer'";

            PreparedStatement psAvg = conn.prepareStatement(sql_avg);
            ResultSet rsAvg = psAvg.executeQuery();
            
            // Query khusus menghitung user dengan role customer
            String sqlCustomer = "SELECT COUNT(*) FROM users WHERE role = 'customer'";
            ResultSet rsCust = conn.createStatement().executeQuery(sqlCustomer);

            int totalCustomerOnly = 0;
            if (rsCust.next()) {
                totalCustomerOnly = rsCust.getInt(1);
            }

            // Kirim data ke JSP
            request.setAttribute("totalCustomer", totalCustomerOnly);

            rsCust.close();
            
            if (rsAvg.next()) {
                request.setAttribute("avgOrder", rsAvg.getDouble("avg_order"));
                request.setAttribute("avgSpend", rsAvg.getDouble("avg_spend"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }

        request.setAttribute("customerList", customerList);
        request.getRequestDispatcher("admin/users.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action"); // 'add' atau 'update'
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String role = request.getParameter("role");
        String password = request.getParameter("password");

        JDBC db = new JDBC();
        try {
            db.connect();
            Connection conn = db.getConnection();

            if ("update".equals(action)) {
                // Jika password diisi, update password juga. Jika tidak, abaikan password.
                String sql;
                PreparedStatement ps;
                if (password != null && !password.trim().isEmpty()) {
                    sql = "UPDATE users SET name=?, username=?, email=?, phone=?, address=?, role=?, password=? WHERE user_id=?";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, name); ps.setString(2, username); ps.setString(3, email);
                    ps.setString(4, phone); ps.setString(5, address); ps.setString(6, role);
                    ps.setString(7, password);
                    ps.setInt(8, Integer.parseInt(id));
                } else {
                    sql = "UPDATE users SET name=?, username=?, email=?, phone=?, address=?, role=? WHERE user_id=?";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, name); ps.setString(2, username); ps.setString(3, email);
                    ps.setString(4, phone); ps.setString(5, address); ps.setString(6, role);
                    ps.setInt(7, Integer.parseInt(id));
                }
                ps.executeUpdate();
            } else {
                // INSERT Baru: Gunakan password dari input, jika kosong gunakan default
                if (password == null || password.trim().isEmpty()) password = "Freshora123";

                String sql = "INSERT INTO users (name, username, email, password, phone, address, role) VALUES (?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, name); ps.setString(2, username); ps.setString(3, email);
                ps.setString(4, password);
                ps.setString(5, phone); ps.setString(6, address); ps.setString(7, role);
                ps.executeUpdate();
            }
        } catch (Exception e) { e.printStackTrace(); }
        finally { db.disconnect(); }
        response.sendRedirect("ManageUserServlet");
    }
}
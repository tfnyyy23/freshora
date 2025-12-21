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

@WebServlet(name = "ManageCustomerServlet", urlPatterns = {"/admin/ManageCustomerServlet"})
public class ManageCustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Proteksi: Pastikan hanya admin yang bisa akses
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");
        if (admin == null || !"admin".equals(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<User> customerList = new ArrayList<>();
        JDBC db = new JDBC();
        
        try {
            db.connect();
            // Query hanya mengambil role 'customer'
            String sql = "SELECT * FROM users WHERE role = 'customer' ORDER BY user_id DESC";
            Statement st = db.getConnection().createStatement();
            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {
                // Sesuaikan dengan constructor User kamu
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
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }

        request.setAttribute("customerList", customerList);
        // Kirim ke halaman JSP yang tadi kita buat
        request.getRequestDispatcher("/admin/customers.jsp").forward(request, response);
    }
}

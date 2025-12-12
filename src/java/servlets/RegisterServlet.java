/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package servlets;

import classes.JDBC;
import models.User;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // ===== VALIDASI PASSWORD =====
        if (!password.equals(confirmPassword)) {
            response.sendRedirect("register.jsp?error=Password tidak sama");
            return;
        }

        // ===== MASUKKAN KE OBJECT USER =====
        User user = new User(
                name,
                username,
                email,
                phone,
                address,
                password,
                "customer"
        );

        JDBC db = new JDBC();
        db.connect();

        if (!db.isConnected()) {
            response.sendRedirect("register.jsp?error=Koneksi database gagal");
            return;
        }

        Connection con = db.getConnection();
        PreparedStatement ps = null;

        try {
            String sql = "INSERT INTO users (name, username, email, phone, address, password, role) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?)";

            ps = con.prepareStatement(sql);
            ps.setString(1, user.getName());
            ps.setString(2, user.getUsername());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getPassword());
            ps.setString(7, user.getRole());

            ps.executeUpdate();

            response.sendRedirect("register.jsp?success=true");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=Registrasi gagal");
        } finally {
            try {
                if (ps != null) ps.close();
                db.disconnect();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}

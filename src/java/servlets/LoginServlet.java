package servlets;

import classes.JDBC;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import models.User;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        JDBC db = new JDBC();
        db.connect();

        try {
            Connection conn = db.getConnection();
            
            // 1. Cek apakah username ada di database
            String sqlUser = "SELECT * FROM users WHERE username = ?";
            PreparedStatement psUser = conn.prepareStatement(sqlUser);
            psUser.setString(1, username);
            ResultSet rs = psUser.executeQuery();

            if (rs.next()) {
                // 2. Jika username ada, cek password-nya
                String dbPassword = rs.getString("password");
                
                if (dbPassword.equals(password)) {
                    // LOGIN BERHASIL
                    User user = new User(
                        rs.getString("name"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getString("password"),
                        rs.getString("role")
                    );
                    user.setUserId(rs.getInt("user_id"));

                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);

                    String role = rs.getString("role");
                    if ("customer".equalsIgnoreCase(role)) {
                        response.sendRedirect("CustomerServlet");
                    } else if ("admin".equalsIgnoreCase(role)) {
                        response.sendRedirect("AdminServlet");
                    } else {
                        response.sendRedirect("login.jsp?error=role");
                    }
                } else {
                    // Password salah
                    response.sendRedirect("login.jsp?error=wrong_pass");
                }
            } else {
                // Username tidak terdaftar
                response.sendRedirect("login.jsp?error=not_found");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=server");
        } finally {
            db.disconnect();
        }
    }
}
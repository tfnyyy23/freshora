package servlets;

import models.User;
import classes.JDBC;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import models.User;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        JDBC db = new JDBC();
        db.connect();

        try {
            String sql = "SELECT * FROM users WHERE username=? AND password=?";
            PreparedStatement ps = db.getConnection().prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                //  BUAT OBJECT USER SESUAI CONSTRUCTOR
                User user = new User(
                    rs.getString("name"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("address"),
                    rs.getString("password"),
                    rs.getString("role")
                );

                //  SET userId VIA SETTER
                user.setUserId(rs.getInt("user_id"));

                //  SIMPAN KE SESSION
                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                String role = rs.getString("role");

                if ("customer".equalsIgnoreCase(role)) {
                    response.sendRedirect("CustomerServlet");
                } else if ("admin".equalsIgnoreCase(role)) {
                    response.sendRedirect("admin/dashboard.jsp");
                } else {
                    response.sendRedirect("login.jsp?error=role");
                }

            } else {
                response.sendRedirect("login.jsp?error=invalid");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=server");
        }
    }
}

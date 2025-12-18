package servlets;

import classes.JDBC;
import models.Product;
import models.User;

import java.io.IOException;
import java.sql.Statement;
import java.sql.ResultSet;
import java.util.List;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet(name = "CustomerServlet", urlPatterns = {"/CustomerServlet"})
public class CustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        JDBC db = new JDBC();
        db.connect();

        List<Product> products = new ArrayList<>();
        String keyword = request.getParameter("keyword");
        String ajax = request.getParameter("ajax");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if(user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        int userId = user.getUserId();

        int cartCount = 0;
        try {
            Statement st = db.getConnection().createStatement();
            ResultSet rs;

            if (keyword != null && !keyword.trim().isEmpty()) {
                String sql = "SELECT * FROM products " +
                             "WHERE name LIKE '%" + keyword + "%' " +
                             "ORDER BY product_id DESC";
                rs = st.executeQuery(sql);
            } else {
                String sql = "SELECT * FROM products " +
                             "ORDER BY product_id DESC " +
                             "LIMIT 8";
                rs = st.executeQuery(sql);
            }

            while (rs.next()) {
                Product p = new Product(
                    rs.getInt("product_id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getInt("price"),
                    rs.getInt("stock"),
                    rs.getString("image"),
                    rs.getDouble("rating"),
                    rs.getInt("category_id")
                );
                products.add(p);
            }

            rs.close();
            st.close();
            
            // ================== CART ==================
            Connection con = db.getConnection();
            PreparedStatement ps = con.prepareStatement(
            "SELECT SUM(quantity) AS total FROM cart_items c JOIN carts ca ON c.cart_id=ca.cart_id WHERE ca.user_id=?");
            ps.setInt(1, userId);
            ResultSet rse = ps.executeQuery();
            if (rse.next()) cartCount = rse.getInt("total");
            session.setAttribute("cartCount", cartCount);
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }

        request.setAttribute("products", products);
        request.setAttribute("keyword", keyword);

        if ("1".equals(ajax)) {
            // Kembalikan hanya HTML grid produk (partial JSP)
            request.getRequestDispatcher("customer/partials/productList.jsp")
                   .forward(request, response);
        } else {
            // Render seluruh halaman dashboard
            request.getRequestDispatcher("customer/dashboard.jsp")
                   .forward(request, response);
        }
    }
}

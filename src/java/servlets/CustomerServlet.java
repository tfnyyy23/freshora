/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;

import classes.JDBC;
import models.Product;
import java.util.List;
import java.util.ArrayList;
import java.sql.Statement;
import java.sql.ResultSet;
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
@WebServlet(name = "CustomerServlet", urlPatterns = {"/CustomerServlet"})
public class CustomerServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        JDBC db = new JDBC();
        db.connect();

        List<Product> products = new ArrayList<>();

        String keyword = request.getParameter("keyword");   // dari search
        String all = request.getParameter("all");           // dari "lihat semua"

        try {
            Statement st = db.getConnection().createStatement();
            ResultSet rs;

            if (keyword != null && !keyword.trim().isEmpty()) {
                // === MODE SEARCH ===
                String sql = "SELECT * FROM products WHERE name LIKE '%" + keyword + "%'";
                rs = st.executeQuery(sql);

            } else if (all != null) {
                // === MODE LIHAT SEMUA PRODUK ===
                String sql = "SELECT * FROM products";
                rs = st.executeQuery(sql);

            } else {
                // === MODE DASHBOARD (DEFAULT: 8 TERBARU) ===
                String sql = "SELECT * FROM products ORDER BY product_id DESC LIMIT 8";
                rs = st.executeQuery(sql);
            }

            while (rs.next()) {
                Product p = new Product(
                    rs.getInt("product_id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getInt("stock"),
                    rs.getString("image"),
                    rs.getDouble("rating"),
                    rs.getInt("category_id")
                );
                products.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("products", products);

        // === ARAHKAN KE HALAMAN SESUAI MODE ===
        if (keyword != null || all != null) {
            request.getRequestDispatcher("customer/allProduct.jsp")
                   .forward(request, response);
        } else {
            request.getRequestDispatcher("customer/dashboard.jsp")
                   .forward(request, response);
        }
    }

}

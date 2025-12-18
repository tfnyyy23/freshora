/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/detail"})
public class ProductDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Ambil ID dari URL (misal: detail?id=3)
        String productIdStr = request.getParameter("id");
        
        if (productIdStr == null || productIdStr.isEmpty()) {
            response.sendRedirect("dashboard.jsp"); // Balikin ke dashboard kalau ID kosong
            return;
        }

        try {
            // 2. Koneksi ke Database Freshora
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/freshora", "root", "");

            // 3. Query JOIN untuk ambil data produk & kategorinya
            String sql = "SELECT p.*, c.name AS category_name FROM products p " +
                         "JOIN categories c ON p.category_id = c.category_id " +
                         "WHERE p.product_id = ?";
            
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(productIdStr));
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                // 4. Masukkan data ke dalam Map agar mudah dibaca di JSP
                Map<String, Object> product = new HashMap<>();
                product.put("product_id", rs.getInt("product_id"));
                product.put("name", rs.getString("name"));
                product.put("description", rs.getString("description"));
                product.put("price", rs.getInt("price"));
                product.put("stock", rs.getInt("stock"));
                product.put("image", rs.getString("image"));
                product.put("rating", rs.getDouble("rating"));
                
                // Kirim data ke JSP
                request.setAttribute("product", product);
                request.setAttribute("categoryName", rs.getString("category_name"));
                
                // Pindah ke halaman detailProduct.jsp
                request.getRequestDispatcher("customer/detailProduct.jsp").forward(request, response);
            } else {
                response.sendRedirect("dashboard.jsp");
            }
            
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error Database: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Biasanya untuk proses "Tambah ke Keranjang", tapi untuk sekarang kita arahkan ke doGet
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet untuk menampilkan detail produk Freshora";
    }
}

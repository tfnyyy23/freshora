package servlets;

import classes.JDBC; 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.IOException;
import java.util.*; // WAJIB UNTUK LIST DAN MAP
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ReportServlet", urlPatterns = {"/ReportServlet"})
public class ReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        JDBC db = new JDBC();
        int totalRevenue = 0;
        int totalTransactions = 0;
        List<Map<String, Object>> topProducts = new ArrayList<>();

        try {
            db.connect();
            
            // 1. Hitung total pendapatan (Gunakan kolom 'total' dan status 'paid')
            // Berdasarkan SQL kamu, transaksi sukses biasanya berstatus 'paid'
            ResultSet rs1 = db.getConnection().createStatement().executeQuery(
                "SELECT SUM(total) FROM orders WHERE status='paid'");
            if(rs1.next()) totalRevenue = rs1.getInt(1);

            // 2. Hitung jumlah total transaksi
            ResultSet rs2 = db.getConnection().createStatement().executeQuery(
                "SELECT COUNT(*) FROM orders");
            if(rs2.next()) totalTransactions = rs2.getInt(1);

            // 3. Ambil data Produk Terlaris (Query ini yang hilang di kode lama kamu)
            String queryTop = "SELECT p.name, SUM(oi.quantity) as sold " +
                             "FROM order_items oi " +
                             "JOIN products p ON oi.product_id = p.product_id " +
                             "GROUP BY p.product_id, p.name " +
                             "ORDER BY sold DESC LIMIT 5";
            
            ResultSet rs3 = db.getConnection().createStatement().executeQuery(queryTop);
            while (rs3.next()) {
                Map<String, Object> product = new HashMap<>();
                product.put("name", rs3.getString("name"));
                product.put("sold", rs3.getInt("sold"));
                topProducts.add(product);
            }

        } catch (SQLException e) { 
            e.printStackTrace(); 
        } finally { 
            db.disconnect(); 
        }

        // Kirim data ke JSP
        request.setAttribute("revenue", totalRevenue);
        request.setAttribute("transactions", totalTransactions);
        request.setAttribute("topProducts", topProducts);
        
        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }
}
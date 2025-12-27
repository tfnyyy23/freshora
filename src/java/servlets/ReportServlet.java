/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;

// TAMBAHKAN IMPORT BERIKUT AGAR TIDAK ERROR
import classes.JDBC; 
import java.sql.ResultSet;
import java.io.IOException;
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

        try {
            db.connect();
            // Hitung total pendapatan hari ini
            ResultSet rs1 = db.getConnection().createStatement().executeQuery(
                "SELECT SUM(total_price) FROM orders WHERE status='Selesai'");
            if(rs1.next()) totalRevenue = rs1.getInt(1);

            // Hitung jumlah transaksi
            ResultSet rs2 = db.getConnection().createStatement().executeQuery(
                "SELECT COUNT(*) FROM orders");
            if(rs2.next()) totalTransactions = rs2.getInt(1);

        } catch (Exception e) { 
            e.printStackTrace(); 
        } finally { 
            db.disconnect(); 
        }

        request.setAttribute("revenue", totalRevenue);
        request.setAttribute("transactions", totalTransactions);
        
        // Pastikan path forward sesuai dengan folder file jsp kamu
        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }
}
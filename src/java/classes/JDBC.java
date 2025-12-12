/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package classes;
import java.sql.*;
/**
 *
 * @author ASUS
 */
public class JDBC {
    private Connection con = null;
    private boolean isConnected = false;
    private String message = "";

    // --- DB connection settings (adjust if needed) ---
    private final String DB_NAME = "freshora";
    private final String DB_URL = "jdbc:mysql://localhost:3306/" + DB_NAME + "?useSSL=false&serverTimezone=UTC";
    private final String DB_USER = "root";
    private final String DB_PASS = "";

    
    public void connect() {
        try {
            // Load driver (optional for modern drivers, but kept for clarity)
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish connection
            con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            isConnected = (con != null && !con.isClosed());
            message = isConnected ? "DB connected" : "Connection failed (unknown reason)";
        } catch (ClassNotFoundException e) {
            isConnected = false;
            message = "JDBC Driver not found: " + e.getMessage();
            e.printStackTrace();
        } catch (SQLException e) {
            isConnected = false;
            message = "SQL error: " + e.getMessage();
            e.printStackTrace();
        } catch (Exception e) {
            isConnected = false;
            message = "Error: " + e.getMessage();
            e.printStackTrace();
        }
    }

   
    public Connection getConnection() {
        return con;
    }

    
    public boolean isConnected() {
        try {
            if (con != null) {
                return !con.isClosed();
            } else {
                return false;
            }
        } catch (SQLException e) {
            return false;
        }
    }

    
    public String getMessage() {
        return message;
    }

    
    public void disconnect() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
            }
            isConnected = false;
            message = "DB disconnected";
        } catch (SQLException e) {
            message = "Error while disconnecting: " + e.getMessage();
            e.printStackTrace();
        }
    }

    
    public String runQuery(String query) {
        Connection tmpCon = null;
        Statement stmt = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            tmpCon = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            stmt = tmpCon.createStatement();
            int affected = stmt.executeUpdate(query);
            return "OK: " + affected + " rows affected";
        } catch (Exception e) {
            e.printStackTrace();
            return "ERROR: " + e.getMessage();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (tmpCon != null && !tmpCon.isClosed()) tmpCon.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    
    public ResultSet getData(String query) throws SQLException {
        if (!isConnected()) {
            message = "Not connected to DB";
            return null;
        }
        Statement stmt = con.createStatement();
        // Note: ResultSet must be closed by caller
        return stmt.executeQuery(query);
    }
}

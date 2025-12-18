package servlets;

import models.User;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import classes.JDBC;

@WebServlet(name = "CartServlet", urlPatterns = {"/CartServlet"})
public class CartServlet extends HttpServlet {

    // ================= GET =================
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        JDBC db = new JDBC();
        db.connect();

        if (!db.isConnected()) {
            throw new ServletException("DB connection failed: " + db.getMessage());
        }

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if(user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        int userId = user.getUserId();

        String addProduct = request.getParameter("add");
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        try {
            Connection conn = db.getConnection();

            // Ambil atau buat cart
            int cartId = getOrCreateCart(conn, userId);

            // Tambah produk jika ada add param
            if (addProduct != null) {
                addProductToCart(conn, cartId, Integer.parseInt(addProduct));
            }

            // Ambil semua item
            List<Map<String, Object>> cartItems = getCartItems(conn, cartId, session);

            if (isAjax && addProduct != null) {
                response.setContentType("application/json");
                int cartCount = (int) session.getAttribute("cartCount");
                response.getWriter().write("{\"cartCount\":" + cartCount + "}");
                return;
            }

            // Tampilkan cart.jsp
            request.setAttribute("cartItems", cartItems);
            request.getRequestDispatcher("/customer/cart.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("allProduct.jsp");
        }
    }

    // ================= POST =================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        JDBC db = new JDBC();
        db.connect();

        if (!db.isConnected()) {
            throw new ServletException("DB connection failed: " + db.getMessage());
        }

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if(user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        int userId = user.getUserId();

        String updateId = request.getParameter("update");
        String deleteId = request.getParameter("delete");
        int quantity = 0;
        if(request.getParameter("quantity") != null) {
            quantity = Integer.parseInt(request.getParameter("quantity"));
        }

        try {
            Connection conn = db.getConnection();
            int cartId = getOrCreateCart(conn, userId);

            if (updateId != null) {
                updateCartItem(conn, cartId, Integer.parseInt(updateId), quantity);
            }

            if (deleteId != null) {
                deleteCartItem(conn, cartId, Integer.parseInt(deleteId));
            }

            // Update jumlah total di session
            getCartItems(conn, cartId, session);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("CartServlet"); // reload halaman cart
    }

    // ================= HELPERS =================
    private int getOrCreateCart(Connection conn, int userId) throws SQLException {
        int cartId = 0;
        PreparedStatement psCart = conn.prepareStatement("SELECT cart_id FROM carts WHERE user_id=?");
        psCart.setInt(1, userId);
        ResultSet rsCart = psCart.executeQuery();
        if (rsCart.next()) {
            cartId = rsCart.getInt("cart_id");
        } else {
            PreparedStatement psInsertCart = conn.prepareStatement(
                    "INSERT INTO carts(user_id) VALUES(?)", Statement.RETURN_GENERATED_KEYS);
            psInsertCart.setInt(1, userId);
            psInsertCart.executeUpdate();
            ResultSet generatedKeys = psInsertCart.getGeneratedKeys();
            if (generatedKeys.next()) {
                cartId = generatedKeys.getInt(1);
            }
        }
        return cartId;
    }

    private void addProductToCart(Connection conn, int cartId, int productId) throws SQLException {
        PreparedStatement psCheck = conn.prepareStatement(
                "SELECT cart_item_id, quantity FROM cart_items WHERE cart_id=? AND product_id=?");
        psCheck.setInt(1, cartId);
        psCheck.setInt(2, productId);
        ResultSet rsCheck = psCheck.executeQuery();

        if (rsCheck.next()) {
            int cartItemId = rsCheck.getInt("cart_item_id");
            int quantity = rsCheck.getInt("quantity") + 1;
            PreparedStatement psUpdate = conn.prepareStatement(
                    "UPDATE cart_items SET quantity=? WHERE cart_item_id=?");
            psUpdate.setInt(1, quantity);
            psUpdate.setInt(2, cartItemId);
            psUpdate.executeUpdate();
        } else {
            PreparedStatement psInsertItem = conn.prepareStatement(
                    "INSERT INTO cart_items(cart_id, product_id, quantity) VALUES(?,?,1)");
            psInsertItem.setInt(1, cartId);
            psInsertItem.setInt(2, productId);
            psInsertItem.executeUpdate();
        }
    }

    private void updateCartItem(Connection conn, int cartId, int productId, int quantity) throws SQLException {
        if(quantity <= 0) return;
        PreparedStatement psUpdate = conn.prepareStatement(
                "UPDATE cart_items SET quantity=? WHERE cart_id=? AND product_id=?");
        psUpdate.setInt(1, quantity);
        psUpdate.setInt(2, cartId);
        psUpdate.setInt(3, productId);
        psUpdate.executeUpdate();
    }

    private void deleteCartItem(Connection conn, int cartId, int productId) throws SQLException {
        PreparedStatement psDelete = conn.prepareStatement(
                "DELETE FROM cart_items WHERE cart_id=? AND product_id=?");
        psDelete.setInt(1, cartId);
        psDelete.setInt(2, productId);
        psDelete.executeUpdate();
    }

    private List<Map<String, Object>> getCartItems(Connection conn, int cartId, HttpSession session) throws SQLException {
        PreparedStatement psItems = conn.prepareStatement(
                "SELECT ci.cart_item_id, ci.quantity, p.product_id, p.name, p.price, p.stock, p.image " +
                "FROM cart_items ci " +
                "JOIN products p ON ci.product_id = p.product_id " +
                "WHERE ci.cart_id=?"
        );
        psItems.setInt(1, cartId);
        ResultSet rsItems = psItems.executeQuery();

        List<Map<String, Object>> cartItems = new ArrayList<>();
        int cartCount = 0;

        while (rsItems.next()) {
            Map<String, Object> item = new HashMap<>();
            item.put("cartItemId", rsItems.getInt("cart_item_id"));
            item.put("productId", rsItems.getInt("product_id"));
            item.put("name", rsItems.getString("name"));
            item.put("price", rsItems.getInt("price"));
            item.put("stock", rsItems.getInt("stock"));
            item.put("image", rsItems.getString("image"));
            item.put("quantity", rsItems.getInt("quantity"));

            cartCount += rsItems.getInt("quantity");
            cartItems.add(item);
        }

        session.setAttribute("cartCount", cartCount);
        return cartItems;
    }
}

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Handles User CRUD operations for the Admin (registering new vehicle owners).
 * Only USER role accounts are managed here — the Admin account itself is not editable.
 */
@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && "ADMIN".equals(session.getAttribute("role"));
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            deleteUser(request, response);
            return;
        }

        List<Object[]> users = new ArrayList<>();
        String sql = "SELECT user_id, name, username FROM users WHERE role = 'USER' ORDER BY user_id";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                users.add(new Object[]{
                        rs.getInt("user_id"),
                        rs.getString("name"),
                        rs.getString("username")
                });
            }

        } catch (SQLException e) {
            throw new ServletException("Database error while loading users", e);
        }

        request.setAttribute("users", users);
        request.getRequestDispatcher("users.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addUser(request, response);
        } else if ("edit".equals(action)) {
            editUser(request, response);
        } else {
            response.sendRedirect("UserServlet");
        }
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        String sql = "INSERT INTO users (name, username, password, role) VALUES (?, ?, ?, 'USER')";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, username);
            ps.setString(3, password);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException("Database error while adding user", e);
        }

        response.sendRedirect("UserServlet");
    }

    private void editUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = Integer.parseInt(request.getParameter("userId"));
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        String sql = "UPDATE users SET name = ?, username = ?, password = ? WHERE user_id = ? AND role = 'USER'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, username);
            ps.setString(3, password);
            ps.setInt(4, userId);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException("Database error while updating user", e);
        }

        response.sendRedirect("UserServlet");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = Integer.parseInt(request.getParameter("userId"));

        String sql = "DELETE FROM users WHERE user_id = ? AND role = 'USER'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException("Database error while deleting user", e);
        }

        response.sendRedirect("UserServlet");
    }
}
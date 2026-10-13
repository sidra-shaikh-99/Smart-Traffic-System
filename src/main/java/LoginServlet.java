import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = request.getParameter("role");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        String sql = "SELECT user_id, name, username, role FROM users " +
                     "WHERE username = ? AND password = ? AND role = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, role);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userId", rs.getInt("user_id"));
                    session.setAttribute("name", rs.getString("name"));
                    session.setAttribute("username", rs.getString("username"));
                    session.setAttribute("role", rs.getString("role"));

                    if ("ADMIN".equals(role)) {
                        response.sendRedirect("AdminDashboardServlet");
                    } else {
                        response.sendRedirect("DashboardServlet");
                    }
                } else {
                    response.sendRedirect("login.jsp?status=error&role=" + role);
                }
            }

        } catch (SQLException e) {
            throw new ServletException("Database error during login", e);
        }
    }
}
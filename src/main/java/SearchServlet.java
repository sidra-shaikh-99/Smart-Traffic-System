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
 * Lets a logged-in user search violation records by vehicle number.
 * Restricted to vehicles/violations owned by that user (data isolation).
 */
@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null
                || !"USER".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String vehicleNumber = request.getParameter("vehicleNumber");

        List<Object[]> results = new ArrayList<>();

        String sql = "SELECT ve.vehicle_number, ve.owner_name, v.violation_type, " +
                "v.violation_date, v.fine_amount, v.status " +
                "FROM violations v " +
                "JOIN vehicles ve ON v.vehicle_id = ve.vehicle_id " +
                "WHERE ve.vehicle_number = ? AND ve.user_id = ? " +
                "ORDER BY v.violation_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, vehicleNumber);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    results.add(new Object[]{
                            rs.getString("vehicle_number"),
                            rs.getString("owner_name"),
                            rs.getString("violation_type"),
                            rs.getDate("violation_date"),
                            rs.getDouble("fine_amount"),
                            rs.getString("status")
                    });
                }
            }

        } catch (SQLException e) {
            throw new ServletException("Database error while searching violation", e);
        }

        request.setAttribute("searchResults", results);
        request.setAttribute("searchedVehicleNumber", vehicleNumber);
        request.getRequestDispatcher("search-results.jsp").forward(request, response);
    }
}
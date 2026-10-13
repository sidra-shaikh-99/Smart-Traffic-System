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
 * Fetches the logged-in user's vehicles and violations,
 * then forwards to user-dashboard.jsp for display.
 * No SQL is written inside the JSP itself.
 */
@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null
                || !"USER".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        List<Object[]> vehicles = new ArrayList<>();
        List<Object[]> violations = new ArrayList<>();
        double totalFine = 0;
        double unpaidFine = 0;
        int totalViolations = 0;

        String vehicleSql = "SELECT vehicle_id, vehicle_number, owner_name, vehicle_type " +
                             "FROM vehicles WHERE user_id = ?";

        String violationSql = "SELECT v.violation_type, v.violation_date, v.fine_amount, v.status, " +
                               "ve.vehicle_number " +
                               "FROM violations v " +
                               "JOIN vehicles ve ON v.vehicle_id = ve.vehicle_id " +
                               "WHERE ve.user_id = ? " +
                               "ORDER BY v.violation_date DESC";

        try (Connection con = DBConnection.getConnection()) {

            try (PreparedStatement ps = con.prepareStatement(vehicleSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        vehicles.add(new Object[]{
                                rs.getInt("vehicle_id"),
                                rs.getString("vehicle_number"),
                                rs.getString("owner_name"),
                                rs.getString("vehicle_type")
                        });
                    }
                }
            }

            try (PreparedStatement ps = con.prepareStatement(violationSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        double fine = rs.getDouble("fine_amount");
                        String status = rs.getString("status");

                        violations.add(new Object[]{
                                rs.getString("violation_type"),
                                rs.getDate("violation_date"),
                                fine,
                                status,
                                rs.getString("vehicle_number")
                        });

                        totalViolations++;
                        totalFine += fine;
                        if ("Unpaid".equals(status)) {
                            unpaidFine += fine;
                        }
                    }
                }
            }

        } catch (SQLException e) {
            throw new ServletException("Database error while loading dashboard", e);
        }

        request.setAttribute("vehicles", vehicles);
        request.setAttribute("violations", violations);
        request.setAttribute("totalViolations", totalViolations);
        request.setAttribute("totalFine", totalFine);
        request.setAttribute("unpaidFine", unpaidFine);

        request.getRequestDispatcher("user-dashboard.jsp").forward(request, response);
    }
}
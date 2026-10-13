import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
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
 * Handles all Violation CRUD operations for the Admin:
 * list (default GET), add, edit, delete, and status update (POST with "action" parameter).
 */
@WebServlet("/ViolationServlet")
public class ViolationServlet extends HttpServlet {

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
            deleteViolation(request, response);
            return;
        }

        // Default: list all violations (joined with vehicle number for display)
        List<Object[]> violations = new ArrayList<>();
        List<Object[]> vehicles = new ArrayList<>();

        String violationSql = "SELECT v.violation_id, ve.vehicle_number, v.violation_type, " +
                "v.violation_date, v.fine_amount, v.status, v.vehicle_id " +
                "FROM violations v JOIN vehicles ve ON v.vehicle_id = ve.vehicle_id " +
                "ORDER BY v.violation_id DESC";

        String vehicleSql = "SELECT vehicle_id, vehicle_number FROM vehicles ORDER BY vehicle_number";

        try (Connection con = DBConnection.getConnection()) {

            try (PreparedStatement ps = con.prepareStatement(violationSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    violations.add(new Object[]{
                            rs.getInt("violation_id"),
                            rs.getString("vehicle_number"),
                            rs.getString("violation_type"),
                            rs.getDate("violation_date"),
                            rs.getDouble("fine_amount"),
                            rs.getString("status"),
                            rs.getInt("vehicle_id")
                    });
                }
            }

            try (PreparedStatement ps = con.prepareStatement(vehicleSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    vehicles.add(new Object[]{
                            rs.getInt("vehicle_id"),
                            rs.getString("vehicle_number")
                    });
                }
            }

        } catch (SQLException e) {
            throw new ServletException("Database error while loading violations", e);
        }

        request.setAttribute("violations", violations);
        request.setAttribute("vehicles", vehicles);
        request.getRequestDispatcher("violations.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addViolation(request, response);
        } else if ("edit".equals(action)) {
            editViolation(request, response);
        } else if ("updateStatus".equals(action)) {
            updateStatus(request, response);
        } else {
            response.sendRedirect("ViolationServlet");
        }
    }

    private void addViolation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
        String violationType = request.getParameter("violationType");
        String violationDate = request.getParameter("violationDate");
        double fineAmount = Double.parseDouble(request.getParameter("fineAmount"));
        String status = request.getParameter("status");

        String sql = "INSERT INTO violations (vehicle_id, violation_type, violation_date, fine_amount, status) " +
                     "VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, vehicleId);
            ps.setString(2, violationType);
            ps.setDate(3, Date.valueOf(violationDate));
            ps.setDouble(4, fineAmount);
            ps.setString(5, status);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException("Database error while adding violation", e);
        }

        response.sendRedirect("ViolationServlet");
    }

    private void editViolation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int violationId = Integer.parseInt(request.getParameter("violationId"));
        int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
        String violationType = request.getParameter("violationType");
        String violationDate = request.getParameter("violationDate");
        double fineAmount = Double.parseDouble(request.getParameter("fineAmount"));
        String status = request.getParameter("status");

        String sql = "UPDATE violations SET vehicle_id = ?, violation_type = ?, violation_date = ?, " +
                     "fine_amount = ?, status = ? WHERE violation_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, vehicleId);
            ps.setString(2, violationType);
            ps.setDate(3, Date.valueOf(violationDate));
            ps.setDouble(4, fineAmount);
            ps.setString(5, status);
            ps.setInt(6, violationId);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException("Database error while updating violation", e);
        }

        response.sendRedirect("ViolationServlet");
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int violationId = Integer.parseInt(request.getParameter("violationId"));
        String newStatus = request.getParameter("status");

        String sql = "UPDATE violations SET status = ? WHERE violation_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, violationId);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException("Database error while updating status", e);
        }

        response.sendRedirect("ViolationServlet");
    }

    private void deleteViolation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int violationId = Integer.parseInt(request.getParameter("violationId"));

        String sql = "DELETE FROM violations WHERE violation_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, violationId);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException("Database error while deleting violation", e);
        }

        response.sendRedirect("ViolationServlet");
    }
}
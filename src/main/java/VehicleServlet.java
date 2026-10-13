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
 * Handles all Vehicle CRUD operations for the Admin:
 * list (default GET), add, edit, delete (POST with "action" parameter).
 */
@WebServlet("/VehicleServlet")
public class VehicleServlet extends HttpServlet {

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
            deleteVehicle(request, response);
            return;
        }

        // Default: list all vehicles (joined with owner username for display)
        List<Object[]> vehicles = new ArrayList<>();
        List<Object[]> users = new ArrayList<>();

        String vehicleSql = "SELECT vh.vehicle_id, vh.vehicle_number, vh.owner_name, " +
                "vh.vehicle_type, u.username, vh.user_id " +
                "FROM vehicles vh JOIN users u ON vh.user_id = u.user_id " +
                "ORDER BY vh.vehicle_id";

        String userSql = "SELECT user_id, name, username FROM users WHERE role = 'USER'";

        try (Connection con = DBConnection.getConnection()) {

            try (PreparedStatement ps = con.prepareStatement(vehicleSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    vehicles.add(new Object[]{
                            rs.getInt("vehicle_id"),
                            rs.getString("vehicle_number"),
                            rs.getString("owner_name"),
                            rs.getString("vehicle_type"),
                            rs.getString("username"),
                            rs.getInt("user_id")
                    });
                }
            }

            try (PreparedStatement ps = con.prepareStatement(userSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(new Object[]{
                            rs.getInt("user_id"),
                            rs.getString("name"),
                            rs.getString("username")
                    });
                }
            }

        } catch (SQLException e) {
            throw new ServletException("Database error while loading vehicles", e);
        }

        request.setAttribute("vehicles", vehicles);
        request.setAttribute("users", users);
        request.getRequestDispatcher("vehicles.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addVehicle(request, response);
        } else if ("edit".equals(action)) {
            editVehicle(request, response);
        } else {
            response.sendRedirect("VehicleServlet");
        }
    }

    private void addVehicle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String vehicleNumber = request.getParameter("vehicleNumber");
        String ownerName = request.getParameter("ownerName");
        String vehicleType = request.getParameter("vehicleType");
        int userId = Integer.parseInt(request.getParameter("userId"));

        String sql = "INSERT INTO vehicles (vehicle_number, owner_name, vehicle_type, user_id) " +
                     "VALUES (?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, vehicleNumber);
            ps.setString(2, ownerName);
            ps.setString(3, vehicleType);
            ps.setInt(4, userId);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException("Database error while adding vehicle", e);
        }

        response.sendRedirect("VehicleServlet");
    }

    private void editVehicle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
        String vehicleNumber = request.getParameter("vehicleNumber");
        String ownerName = request.getParameter("ownerName");
        String vehicleType = request.getParameter("vehicleType");
        int userId = Integer.parseInt(request.getParameter("userId"));

        String sql = "UPDATE vehicles SET vehicle_number = ?, owner_name = ?, " +
                     "vehicle_type = ?, user_id = ? WHERE vehicle_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, vehicleNumber);
            ps.setString(2, ownerName);
            ps.setString(3, vehicleType);
            ps.setInt(4, userId);
            ps.setInt(5, vehicleId);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException("Database error while updating vehicle", e);
        }

        response.sendRedirect("VehicleServlet");
    }

    private void deleteVehicle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));

        String sql = "DELETE FROM vehicles WHERE vehicle_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, vehicleId);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException("Database error while deleting vehicle", e);
        }

        response.sendRedirect("VehicleServlet");
    }
}
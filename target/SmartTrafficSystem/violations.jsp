<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Violation Management - Smart Traffic System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="bg-light">

<%
    if (session == null || session.getAttribute("userId") == null || !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<nav class="navbar navbar-dark bg-dark px-3">
    <span class="navbar-brand mb-0 h1">
        <i class="bi bi-shield-lock"></i> Smart Traffic System — Admin
    </span>
    <div>
        <span class="text-light me-3">Welcome, <%= session.getAttribute("name") %></span>
        <a href="LogoutServlet" class="btn btn-outline-light btn-sm">Logout</a>
    </div>
</nav>

<div class="container-fluid">
    <div class="row">

        <div class="col-md-2 bg-dark min-vh-100 p-0">
            <div class="list-group list-group-flush mt-3">
                <a href="AdminDashboardServlet" class="list-group-item list-group-item-action bg-dark text-light">
                    <i class="bi bi-speedometer2"></i> Dashboard
                </a>
                <a href="VehicleServlet" class="list-group-item list-group-item-action bg-dark text-light">
                    <i class="bi bi-car-front"></i> Vehicles
                </a>
                <a href="ViolationServlet" class="list-group-item list-group-item-action bg-dark text-light active">
                    <i class="bi bi-exclamation-triangle"></i> Violations
                </a>
                <a href="UserServlet" class="list-group-item list-group-item-action bg-dark text-light">
                    <i class="bi bi-people"></i> Users
                </a>
            </div>
        </div>

        <div class="col-md-10 p-4">

            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4>Violation Management</h4>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addViolationModal">
                    <i class="bi bi-plus-circle"></i> Add Violation
                </button>
            </div>

            <div class="card shadow-sm">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-dark">
                        <tr>
                            <th>Vehicle Number</th>
                            <th>Violation Type</th>
                            <th>Date</th>
                            <th>Fine Amount</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            List<Object[]> violations = (List<Object[]>) request.getAttribute("violations");
                            List<Object[]> vehicles = (List<Object[]>) request.getAttribute("vehicles");

                            for (Object[] vi : violations) {
                                int violationId = (int) vi[0];
                                String status = (String) vi[5];
                                String badgeClass = "Paid".equals(status) ? "bg-success" : "bg-danger";
                        %>
                        <tr>
                            <td><%= vi[1] %></td>
                            <td><%= vi[2] %></td>
                            <td><%= vi[3] %></td>
                            <td>&#8377; <%= vi[4] %></td>
                            <td>
                                <form action="ViolationServlet" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="violationId" value="<%= violationId %>">
                                    <select name="status" class="form-select form-select-sm d-inline w-auto"
                                            onchange="this.form.submit()">
                                        <option value="Unpaid" <%= "Unpaid".equals(status) ? "selected" : "" %>>Unpaid</option>
                                        <option value="Paid" <%= "Paid".equals(status) ? "selected" : "" %>>Paid</option>
                                    </select>
                                </form>
                                <span class="badge <%= badgeClass %> ms-1"><%= status %></span>
                            </td>
                            <td>
                                <button class="btn btn-sm btn-warning"
                                        data-bs-toggle="modal"
                                        data-bs-target="#editViolationModal<%= violationId %>">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <a href="ViolationServlet?action=delete&violationId=<%= violationId %>"
                                   class="btn btn-sm btn-danger"
                                   onclick="return confirm('Are you sure you want to delete this violation?');">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </td>
                        </tr>
                        <% } %>

                        <% if (violations.isEmpty()) { %>
                        <tr>
                            <td colspan="6" class="text-center text-muted">No violations found.</td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- Edit Modals (placed OUTSIDE the table for valid HTML / stable Bootstrap behavior) -->
<%
    for (Object[] vi : violations) {
        int violationId = (int) vi[0];
        String status = (String) vi[5];
%>
<div class="modal fade" id="editViolationModal<%= violationId %>" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="ViolationServlet" method="post">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Violation</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="violationId" value="<%= violationId %>">

                    <div class="mb-3">
                        <label class="form-label">Vehicle</label>
                        <select name="vehicleId" class="form-select" required>
                            <%
                                int currentVehicleId = (int) vi[6];
                                for (Object[] veh : vehicles) {
                                    int vId = (int) veh[0];
                            %>
                            <option value="<%= vId %>" <%= (vId == currentVehicleId) ? "selected" : "" %>>
                                <%= veh[1] %>
                            </option>
                            <% } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Violation Type</label>
                        <select name="violationType" class="form-select" required>
                            <%
                                String[] types = {"Overspeeding", "Signal Jumping", "No Helmet", "Wrong Parking", "No Seatbelt"};
                                String currentType = (String) vi[2];
                                for (String t : types) {
                            %>
                            <option value="<%= t %>" <%= t.equals(currentType) ? "selected" : "" %>><%= t %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Violation Date</label>
                        <input type="date" name="violationDate" class="form-control"
                               value="<%= vi[3] %>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Fine Amount</label>
                        <input type="number" step="0.01" max="99999999.99" name="fineAmount" class="form-control"
                               value="<%= vi[4] %>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Status</label>
                        <select name="status" class="form-select" required>
                            <option value="Unpaid" <%= "Unpaid".equals(status) ? "selected" : "" %>>Unpaid</option>
                            <option value="Paid" <%= "Paid".equals(status) ? "selected" : "" %>>Paid</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>
<% } %>

<!-- Add Violation Modal -->
<div class="modal fade" id="addViolationModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="ViolationServlet" method="post">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Violation</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="add">

                    <div class="mb-3">
                        <label class="form-label">Vehicle</label>
                        <select name="vehicleId" class="form-select" required>
                            <%
                                List<Object[]> vehiclesForAdd = (List<Object[]>) request.getAttribute("vehicles");
                                for (Object[] veh : vehiclesForAdd) {
                            %>
                            <option value="<%= veh[0] %>"><%= veh[1] %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Violation Type</label>
                        <select name="violationType" class="form-select" required>
                            <option value="Overspeeding">Overspeeding</option>
                            <option value="Signal Jumping">Signal Jumping</option>
                            <option value="No Helmet">No Helmet</option>
                            <option value="Wrong Parking">Wrong Parking</option>
                            <option value="No Seatbelt">No Seatbelt</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Violation Date</label>
                        <input type="date" name="violationDate" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Fine Amount</label>
                        <input type="number" step="0.01" max="99999999.99" name="fineAmount" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Status</label>
                        <select name="status" class="form-select" required>
                            <option value="Unpaid">Unpaid</option>
                            <option value="Paid">Paid</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Add Violation</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
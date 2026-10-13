<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Smart Traffic System</title>
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

        <!-- Sidebar -->
        <div class="col-md-2 bg-dark min-vh-100 p-0">
            <div class="list-group list-group-flush mt-3">
                <a href="AdminDashboardServlet" class="list-group-item list-group-item-action bg-dark text-light active">
                    <i class="bi bi-speedometer2"></i> Dashboard
                </a>
                <a href="VehicleServlet" class="list-group-item list-group-item-action bg-dark text-light">
                    <i class="bi bi-car-front"></i> Vehicles
                </a>
                <a href="ViolationServlet" class="list-group-item list-group-item-action bg-dark text-light">
                    <i class="bi bi-exclamation-triangle"></i> Violations
                </a>
                <a href="UserServlet" class="list-group-item list-group-item-action bg-dark text-light">
                    <i class="bi bi-people"></i> Users
                </a>
            </div>
        </div>

    
        <!-- Main content -->
        <div class="col-md-10 p-4">

            <h4 class="mb-3">Dashboard Overview</h4>

            <div class="row">
                <div class="col-md-3 mb-3">
                    <div class="card text-white bg-primary shadow-sm">
                        <div class="card-body">
                            <h6>Total Vehicles</h6>
                            <h3><%= request.getAttribute("totalVehicles") %></h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="card text-white bg-dark shadow-sm">
                        <div class="card-body">
                            <h6>Total Violations</h6>
                            <h3><%= request.getAttribute("totalViolations") %></h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="card text-white bg-success shadow-sm">
                        <div class="card-body">
                            <h6>Paid Fines</h6>
                            <h3><%= request.getAttribute("paidCount") %></h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="card text-white bg-danger shadow-sm">
                        <div class="card-body">
                            <h6>Unpaid Fines</h6>
                            <h3><%= request.getAttribute("unpaidCount") %></h3>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card text-white bg-secondary shadow-sm">
                        <div class="card-body">
                            <h6>Total Fine Amount Collected/Recorded</h6>
                            <h3>&#8377; <%= request.getAttribute("totalFineAmount") %></h3>
                        </div>
                    </div>
                </div>
            </div>

            <h4 class="mb-3">Recent Violations</h4>

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
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            List<Object[]> recentViolations = (List<Object[]>) request.getAttribute("recentViolations");
                            for (Object[] rv : recentViolations) {
                                String status = (String) rv[4];
                                String badgeClass = "Paid".equals(status) ? "bg-success" : "bg-danger";
                        %>
                        <tr>
                            <td><%= rv[0] %></td>
                            <td><%= rv[1] %></td>
                            <td><%= rv[2] %></td>
                            <td>&#8377; <%= rv[3] %></td>
                            <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                        </tr>
                        <% } %>

                        <% if (recentViolations.isEmpty()) { %>
                        <tr>
                            <td colspan="5" class="text-center text-muted">No violations recorded yet.</td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>
</div>

</body>
</html>
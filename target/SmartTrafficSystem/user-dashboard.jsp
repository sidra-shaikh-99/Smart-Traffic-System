<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Dashboard - Smart Traffic System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="bg-light">

<%
    if (session == null || session.getAttribute("userId") == null || !"USER".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<nav class="navbar navbar-dark bg-dark px-3">
    <span class="navbar-brand mb-0 h1">
        <i class="bi bi-shield-check"></i> Smart Traffic System
    </span>
    <div>
        <span class="text-light me-3">Welcome, <%= session.getAttribute("name") %></span>
        <a href="LogoutServlet" class="btn btn-outline-light btn-sm">Logout</a>
    </div>
</nav>

<div class="container my-4">

    <h4 class="mb-3">Your Vehicles</h4>

    <div class="row">
        <%
            List<Object[]> vehicles = (List<Object[]>) request.getAttribute("vehicles");
            for (Object[] v : vehicles) {
        %>
        <div class="col-md-4 mb-3">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h5 class="card-title"><i class="bi bi-car-front"></i> <%= v[1] %></h5>
                    <p class="card-text mb-1"><strong>Owner:</strong> <%= v[2] %></p>
                    <p class="card-text"><strong>Type:</strong> <%= v[3] %></p>
                </div>
            </div>
        </div>
        <% } %>

        <% if (vehicles.isEmpty()) { %>
        <div class="col-12">
            <div class="alert alert-info">No vehicles registered under your account.</div>
        </div>
        <% } %>
    </div>

    <div class="row mt-2 mb-4">
        <div class="col-md-4 mb-3">
            <div class="card text-white bg-primary shadow-sm">
                <div class="card-body">
                    <h6>Total Violations</h6>
                    <h3><%= request.getAttribute("totalViolations") %></h3>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card text-white bg-dark shadow-sm">
                <div class="card-body">
                    <h6>Total Fine</h6>
                    <h3>&#8377; <%= request.getAttribute("totalFine") %></h3>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card text-white bg-danger shadow-sm">
                <div class="card-body">
                    <h6>Unpaid Fine</h6>
                    <h3>&#8377; <%= request.getAttribute("unpaidFine") %></h3>
                </div>
            </div>
        </div>
    </div>

    <h4 class="mb-3">Violation History</h4>

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
                    List<Object[]> violations = (List<Object[]>) request.getAttribute("violations");
                    for (Object[] vi : violations) {
                        String status = (String) vi[3];
                        String badgeClass = "Paid".equals(status) ? "bg-success" : "bg-danger";
                %>
                <tr>
                    <td><%= vi[4] %></td>
                    <td><%= vi[0] %></td>
                    <td><%= vi[1] %></td>
                    <td>&#8377; <%= vi[2] %></td>
                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                </tr>
                <% } %>

                <% if (violations.isEmpty()) { %>
                <tr>
                    <td colspan="5" class="text-center text-muted">No violations found.</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <h4 class="mt-4 mb-3">Search Violation by Vehicle Number</h4>
    <form action="SearchServlet" method="get" class="row g-2">
        <div class="col-auto">
            <input type="text" name="vehicleNumber" class="form-control" placeholder="e.g. MH01AB1234" required>
        </div>
        <div class="col-auto">
            <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i> Search</button>
        </div>
    </form>

</div>

</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Search Results - Smart Traffic System</title>
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

    <a href="DashboardServlet" class="btn btn-secondary btn-sm mb-3">
        <i class="bi bi-arrow-left"></i> Back to Dashboard
    </a>

    <h4 class="mb-3">Search Results for: <%= request.getAttribute("searchedVehicleNumber") %></h4>

    <div class="card shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead class="table-dark">
                <tr>
                    <th>Vehicle Number</th>
                    <th>Owner Name</th>
                    <th>Violation Type</th>
                    <th>Date</th>
                    <th>Fine Amount</th>
                    <th>Status</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<Object[]> results = (List<Object[]>) request.getAttribute("searchResults");
                    for (Object[] r : results) {
                        String status = (String) r[5];
                        String badgeClass = "Paid".equals(status) ? "bg-success" : "bg-danger";
                %>
                <tr>
                    <td><%= r[0] %></td>
                    <td><%= r[1] %></td>
                    <td><%= r[2] %></td>
                    <td><%= r[3] %></td>
                    <td>&#8377; <%= r[4] %></td>
                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                </tr>
                <% } %>

                <% if (results.isEmpty()) { %>
                <tr>
                    <td colspan="6" class="text-center text-muted">
                        No violation records found for this vehicle number under your account.
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>

</div>

</body>
</html>
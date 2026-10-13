<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Management - Smart Traffic System</title>
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
                <a href="ViolationServlet" class="list-group-item list-group-item-action bg-dark text-light">
                    <i class="bi bi-exclamation-triangle"></i> Violations
                </a>
                <a href="UserServlet" class="list-group-item list-group-item-action bg-dark text-light active">
                    <i class="bi bi-people"></i> Users
                </a>
            </div>
        </div>

        <div class="col-md-10 p-4">

            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4>User Management (Vehicle Owners)</h4>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                    <i class="bi bi-person-plus"></i> Add User
                </button>
            </div>

            <div class="card shadow-sm">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-dark">
                        <tr>
                            <th>Name</th>
                            <th>Username</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            List<Object[]> users = (List<Object[]>) request.getAttribute("users");
                            for (Object[] u : users) {
                                int userId = (int) u[0];
                        %>
                        <tr>
                            <td><%= u[1] %></td>
                            <td><%= u[2] %></td>
                            <td>
                                <button class="btn btn-sm btn-warning"
                                        data-bs-toggle="modal"
                                        data-bs-target="#editUserModal<%= userId %>">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <a href="UserServlet?action=delete&userId=<%= userId %>"
                                   class="btn btn-sm btn-danger"
                                   onclick="return confirm('Deleting this user will also delete their vehicles and violations. Continue?');">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </td>
                        </tr>
                        <% } %>

                        <% if (users.isEmpty()) { %>
                        <tr>
                            <td colspan="3" class="text-center text-muted">No users found.</td>
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
    for (Object[] u : users) {
        int userId = (int) u[0];
%>
<div class="modal fade" id="editUserModal<%= userId %>" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="UserServlet" method="post">
                <div class="modal-header">
                    <h5 class="modal-title">Edit User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="userId" value="<%= userId %>">

                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" name="name" class="form-control" value="<%= u[1] %>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Username</label>
                        <input type="text" name="username" class="form-control" value="<%= u[2] %>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="text" name="password" class="form-control" placeholder="Enter new password" required>
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

<!-- Add User Modal -->
<div class="modal fade" id="addUserModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="UserServlet" method="post">
                <div class="modal-header">
                    <h5 class="modal-title">Add New User (Vehicle Owner)</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="add">

                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" name="name" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Username</label>
                        <input type="text" name="username" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="text" name="password" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Add User</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - Smart Traffic System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container">
    <div class="row justify-content-center mt-5">
        <div class="col-md-5">
            <div class="card shadow-sm">
                <div class="card-body p-4">
                    <h3 class="text-center mb-4">Login</h3>

                    <% if ("error".equals(request.getParameter("status"))) { %>
                        <div class="alert alert-danger">Invalid username or password.</div>
                    <% } %>

                    <form action="LoginServlet" method="post">

                        <div class="mb-3">
                            <label class="form-label">Login as</label>
                            <select name="role" class="form-select" required>
                                <%
                                    String preSelected = request.getParameter("role");
                                    boolean isAdmin = "ADMIN".equals(preSelected);
                                %>
                                <option value="USER" <%= !isAdmin ? "selected" : "" %>>User</option>
                                <option value="ADMIN" <%= isAdmin ? "selected" : "" %>>Admin</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <input type="text" name="username" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Password</label>
                            <input type="password" name="password" class="form-control" required>
                        </div>

                        <button type="submit" class="btn btn-primary w-100">Login</button>
                    </form>

                    <div class="text-center mt-3">
                        <a href="index.jsp">&larr; Back to Home</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
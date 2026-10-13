<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Smart Traffic Violation & Fine Management System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

<nav class="navbar navbar-dark bg-dark px-3">
    <span class="navbar-brand mb-0 h1">
        <i class="bi bi-shield-check"></i> Smart Traffic System
    </span>
</nav>

<div class="container text-center flex-grow-1 d-flex flex-column justify-content-center">
    <h1 class="mt-3">SMART TRAFFIC</h1>
    <h2 class="text-primary mb-3">VIOLATION & FINE MANAGEMENT SYSTEM</h2>
    <p class="lead text-muted">
        A digital platform to manage traffic violations, fines, and vehicle records —
        replacing slow, error-prone manual record-keeping with a centralized, searchable system.
    </p>

    <div class="mt-4">
        <a href="login.jsp?role=USER" class="btn btn-primary btn-lg mx-2">
            <i class="bi bi-person"></i> User Login
        </a>
        <a href="login.jsp?role=ADMIN" class="btn btn-dark btn-lg mx-2">
            <i class="bi bi-shield-lock"></i> Admin Login
        </a>
    </div>
</div>

<footer class="text-center text-muted py-3 border-top bg-white">
    <small>&copy; 2026 Smart Traffic Violation & Fine Management System</small>
</footer>

</body>
</html>
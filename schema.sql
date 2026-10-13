-- =========================================================
-- SMART TRAFFIC VIOLATION & FINE MANAGEMENT SYSTEM
-- Database Schema + Sample Data
-- (Online/hosted MySQL version — database already exists,
--  so no CREATE DATABASE / USE statements needed here)
-- =========================================================

-- =========================================================
-- TABLE: users
-- role column distinguishes ADMIN vs USER at DB level
-- =========================================================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(50) NOT NULL,
    role VARCHAR(10) NOT NULL DEFAULT 'USER' CHECK (role IN ('ADMIN', 'USER'))
);

-- =========================================================
-- TABLE: vehicles
-- =========================================================
CREATE TABLE vehicles (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_number VARCHAR(20) NOT NULL UNIQUE,
    owner_name VARCHAR(100) NOT NULL,
    vehicle_type VARCHAR(50) NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- =========================================================
-- TABLE: violations
-- status constrained to Paid/Unpaid only
-- =========================================================
CREATE TABLE violations (
    violation_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT NOT NULL,
    violation_type VARCHAR(100) NOT NULL,
    violation_date DATE NOT NULL,
    fine_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(10) NOT NULL DEFAULT 'Unpaid' CHECK (status IN ('Paid', 'Unpaid')),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE CASCADE
);

-- =========================================================
-- SAMPLE DATA: users (5 users — 1 admin + 4 normal users)
-- =========================================================
INSERT INTO users (name, username, password, role) VALUES
('Admin User', 'admin', 'admin123', 'ADMIN'),
('Rahul Sharma', 'rahul01', 'pass123', 'USER'),
('Priya Patil', 'priya02', 'pass123', 'USER'),
('Amit Deshmukh', 'amit03', 'pass123', 'USER'),
('Sneha Kulkarni', 'sneha04', 'pass123', 'USER');

-- =========================================================
-- SAMPLE DATA: vehicles (8 vehicles)
-- Linked to user_id 2,3,4,5 (admin = user_id 1, not a vehicle owner)
-- =========================================================
INSERT INTO vehicles (vehicle_number, owner_name, vehicle_type, user_id) VALUES
('MH01AB1234', 'Rahul Sharma', 'Car', 2),
('MH01CD5678', 'Rahul Sharma', 'Bike', 2),
('MH03CD4567', 'Priya Patil', 'Car', 3),
('MH03EF8899', 'Priya Patil', 'Scooter', 3),
('MH04EF7890', 'Amit Deshmukh', 'Bike', 4),
('MH04GH1122', 'Amit Deshmukh', 'Car', 4),
('MH02XY3344', 'Sneha Kulkarni', 'Bike', 5),
('MH02ZZ9988', 'Sneha Kulkarni', 'Car', 5);

-- =========================================================
-- SAMPLE DATA: violations (15 violations)
-- =========================================================
INSERT INTO violations (vehicle_id, violation_type, violation_date, fine_amount, status) VALUES
(1, 'Overspeeding', '2026-08-01', 1500.00, 'Unpaid'),
(1, 'Signal Jumping', '2026-08-10', 1000.00, 'Paid'),
(2, 'No Helmet', '2026-08-05', 500.00, 'Unpaid'),
(2, 'Wrong Parking', '2026-08-15', 300.00, 'Paid'),
(3, 'Overspeeding', '2026-07-20', 2000.00, 'Unpaid'),
(3, 'No Seatbelt', '2026-08-02', 1000.00, 'Paid'),
(4, 'Signal Jumping', '2026-08-12', 1000.00, 'Unpaid'),
(5, 'No Helmet', '2026-07-25', 500.00, 'Unpaid'),
(5, 'Wrong Parking', '2026-08-08', 300.00, 'Paid'),
(6, 'Overspeeding', '2026-08-18', 1500.00, 'Unpaid'),
(6, 'No Seatbelt', '2026-07-30', 1000.00, 'Paid'),
(7, 'No Helmet', '2026-08-03', 500.00, 'Unpaid'),
(7, 'Signal Jumping', '2026-08-20', 1000.00, 'Unpaid'),
(8, 'Wrong Parking', '2026-08-06', 300.00, 'Paid'),
(8, 'Overspeeding', '2026-08-22', 2000.00, 'Unpaid');
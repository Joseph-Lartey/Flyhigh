DROP DATABASE IF EXISTS flyhigh;
CREATE DATABASE flyhigh;
USE flyhigh;

-- Users Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(60) NOT NULL,
    profile_picture_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Countries Table
CREATE TABLE countries (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL
);

-- Classes Table
CREATE TABLE classes (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL
);

-- Flights Table
CREATE TABLE flights (
    flight_id INT AUTO_INCREMENT PRIMARY KEY,
    airline VARCHAR(255) NOT NULL,
    flight_number VARCHAR(50) NOT NULL,
    departure_country_id INT,
    arrival_country_id INT,
    departure_airport VARCHAR(255) NOT NULL,
    arrival_airport VARCHAR(255) NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    duration INT NOT NULL,
    price_business DECIMAL(10, 2) NOT NULL,
    price_economy DECIMAL(10, 2) NOT NULL,
    price_elite DECIMAL(10, 2) NOT NULL,
    seats_available_business INT NOT NULL,
    seats_available_economy INT NOT NULL,
    seats_available_elite INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (departure_country_id) REFERENCES countries(country_id),
    FOREIGN KEY (arrival_country_id) REFERENCES countries(country_id)
);

-- Bookings Table
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    flight_id INT,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL,
    weight INT NOT NULL,
    class_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id),
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

-- Notifications Table
CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    message TEXT NOT NULL,
    notification_type VARCHAR(50) NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Documents Table
CREATE TABLE documents (
    document_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    user_id INT,
    document_type VARCHAR(50) NOT NULL,
    document_url TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Populate the countries table
INSERT INTO countries (country_name) VALUES 
('Ghana'),
('United States'),
('Canada'),
('United Kingdom'),
('Australia'),
('Germany'),
('France'),
('Italy'),
('Spain'),
('China'),
('Japan'),
('South Korea'),
('India'),
('Brazil'),
('South Africa'),
('Nigeria'),
('Mexico'),
('Russia'),
('Turkey'),
('Egypt'),
('Argentina'),
('Sweden'),
('Norway'),
('Denmark'),
('Netherlands'),
('Belgium');

-- Populate the classes table
INSERT INTO classes (class_name) VALUES 
('Business'),
('Economy'),
('Elite');

-- Populate the flights table with sample data
INSERT INTO flights (airline, flight_number, departure_country_id, arrival_country_id, departure_airport, arrival_airport, departure_time, arrival_time, duration, price_business, price_economy, price_elite, seats_available_business, seats_available_economy, seats_available_elite) VALUES 
('Air Ghana', 'AG123', 1, 2, 'Accra International', 'JFK International', '2024-08-01 08:00:00', '2024-08-01 16:00:00', 8, 1200.00, 800.00, 1500.00, 10, 100, 5),
('British Airways', 'BA456', 4, 1, 'Heathrow', 'Accra International', '2024-08-02 10:00:00', '2024-08-02 18:00:00', 8, 1300.00, 900.00, 1600.00, 15, 120, 8),
('Delta Airlines', 'DL789', 2, 3, 'JFK International', 'Toronto Pearson', '2024-08-03 09:00:00', '2024-08-03 11:00:00', 2, 500.00, 300.00, 700.00, 20, 150, 10),
('Lufthansa', 'LH321', 6, 1, 'Frankfurt Airport', 'Accra International', '2024-08-04 12:00:00', '2024-08-04 20:00:00', 8, 1400.00, 1000.00, 1700.00, 12, 110, 6),
('Emirates', 'EK654', 10, 4, 'Beijing Capital', 'Heathrow', '2024-08-05 14:00:00', '2024-08-06 02:00:00', 12, 1800.00, 1200.00, 2000.00, 8, 80, 4);

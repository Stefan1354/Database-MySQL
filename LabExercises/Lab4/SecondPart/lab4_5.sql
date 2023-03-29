DROP DATABASE IF EXISTS airport;
CREATE DATABASE airport;
USE airport;

CREATE TABLE owner (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL,
address VARCHAR(255) NOT NULL,
phone VARCHAR(50) NOT NULL
);

CREATE TABLE department (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL,
type ENUM('Administration', 'Personal', 'Stewardess', 'Pilot'),
owner_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (owner_id) REFERENCES owner(id)
);

CREATE TABLE planes (
id INT AUTO_INCREMENT PRIMARY KEY,
brand VARCHAR(255) NOT NULL,
number INT NOT NULL,
dateManufacture DATE NOT NULL,
noPassengers INT NOT NULL,
manufacturer VARCHAR(255) NOT NULL,
UNIQUE KEY(number)
);

CREATE TABLE flights (
id INT AUTO_INCREMENT PRIMARY KEY,
no_flight INT NOT NULL UNIQUE,
no_plane INT NOT NULL UNIQUE,
pilot VARCHAR(255) NOT NULL,
stewardess VARCHAR(255) NOT NULL,
date_hour_take_off DATETIME NOT NULL,
date_hour_landing DATETIME NOT NULL,
start_dest VARCHAR(255) NOT NULL,
end_dest VARCHAR(255) NOT NULL,
plane_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (plane_id) REFERENCES planes(id),
UNIQUE KEY (no_flight, no_plane, date_hour_take_off, date_hour_landing)
);

CREATE TABLE manager (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL,
phone VARCHAR(255) NOT NULL,
egn VARCHAR(20) NOT NULL UNIQUE,
address VARCHAR(50) NOT NULL
);

CREATE TABLE employee (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL,
address VARCHAR(255) NOT NULL,
phone VARCHAR(50) NOT NULL,
egn VARCHAR(20) NOT NULL,
work_experience INT NOT NULL,
manager_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (manager_id) REFERENCES manager(id),
department_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (department_id) REFERENCES department(id)
);

CREATE TABLE tickets (
id INT AUTO_INCREMENT PRIMARY KEY,
passenger_name VARCHAR(255) NOT NULL,
seat_number VARCHAR(10) NOT NULL,
ticket_price DECIMAL(10,2) NOT NULL,
class ENUM('Economy', 'Business', 'First') NOT NULL,
purchase_date DATETIME NOT NULL,
flight_id INT NOT NULL,
UNIQUE KEY(flight_id, passenger_name, seat_number),
CONSTRAINT FOREIGN KEY (flight_id) REFERENCES flights(id)
);

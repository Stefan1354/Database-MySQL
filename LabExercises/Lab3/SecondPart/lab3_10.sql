DROP DATABASE IF EXISTS car_service;
CREATE DATABASE car_service;
USE car_service;

CREATE TABLE service (
id INT AUTO_INCREMENT PRIMARY KEY,
type ENUM ('Vehicle diagnostics', 
	   'Oil and filter change', 
           'Tire change', 
           'Repair of air conditioning systems', 
           'Gearbox repair'),
price DECIMAL (5,2) DEFAULT NULL,
duration INT NOT NULL
);

CREATE TABLE employees (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL,
workExperience INT NOT NULL,
phone VARCHAR(20) NOT NULL
);

CREATE TABLE repairs (
id INT AUTO_INCREMENT PRIMARY KEY,
date DATETIME NOT NULL,
total_price DECIMAL (7,2) NOT NULL,
emp_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (emp_id) REFERENCES employees(id)
);

CREATE TABLE clients (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL,
phone VARCHAR(20) NOT NULL,
address VARCHAR(150) NOT NULL,
emp_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (emp_id) REFERENCES employees(id)
);

CREATE TABLE cars (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL,
model VARCHAR(255) NOT NULL,
engine_type VARCHAR(255) NOT NULL,
yearOfManufacture INT NOT NULL,
clients_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (clients_id) REFERENCES clients(id),
emp_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (emp_id) REFERENCES employees(id)
);

CREATE TABLE clients_services (
clients_id INT NOT NULL,
services_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (clients_id) REFERENCES clients(id),
CONSTRAINT FOREIGN KEY (services_id) REFERENCES service(id),
PRIMARY KEY (clients_id, services_id)
);

CREATE TABLE repairs_cars (
repairs_id INT NOT NULL,
cars_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (repairs_id) REFERENCES repairs(id),
CONSTRAINT FOREIGN KEY (cars_id) REFERENCES cars(id),
PRIMARY KEY (repairs_id, cars_id)
);

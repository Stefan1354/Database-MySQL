DROP DATABASE IF EXISTS test_cinemas;
CREATE DATABASE test_cinemas;
USE test_cinemas;


CREATE TABLE projection (
id INT AUTO_INCREMENT PRIMARY KEY,
audience INT NOT NULL,
duration INT NOT NULL
);

CREATE TABLE films (
id INT AUTO_INCREMENT PRIMARY KEY,
year DATE NOT NULL,
country VARCHAR(255) NOT NULL,
length INT NOT NULL,
name VARCHAR(255) NOT NULL,
producer VARCHAR(255) NOT NULL
);

CREATE TABLE cinema (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL,
place VARCHAR(255) NOT NULL,
no_halls INT NOT NULL
);

CREATE TABLE halls (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL,
capacity INT NOT NULL,
status ENUM ('VIP', 'DELUXE', '4D'),
projection_id INT NOT NULL,
films_id INT NOT NULL,
cinema_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (projection_id) REFERENCES projection(id),
CONSTRAINT FOREIGN KEY (films_id) REFERENCES films(id),
CONSTRAINT FOREIGN KEY (cinema_id) REFERENCES cinema(id)
);

CREATE TABLE films_cinema (
films_id INT NOT NULL,
cinema_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (films_id) REFERENCES films(id),
CONSTRAINT FOREIGN KEY (cinema_id) REFERENCES cinema(id),
PRIMARY KEY (films_id, cinema_id)
);

CREATE TABLE projection_cinema (
projection_id INT NOT NULL,
cinema_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (projection_id) REFERENCES projection(id),
CONSTRAINT FOREIGN KEY (cinema_id) REFERENCES cinema(id),
PRIMARY KEY(projection_id, cinema_id)
);


INSERT INTO films (year, country, length, name, producer) 
VALUES
('2023-01-01', 'USA', 110, 'Final Destination 7', 'James Wong'),
('2022-02-14', 'USA', 120, 'A Quiet Place Part II', 'John Krasinski'),
('2021-05-20', 'USA', 140, 'Godzilla vs. Kong', 'Adam Wingard'),
('2021-11-24', 'USA', 130, 'Encanto', 'Byron Howard');


INSERT INTO cinema (name, place, no_halls) 
VALUES 
('Arena Mladost', 'Sofia, Bulgaria', 5),
('Cine Grand', 'Varna, Bulgaria', 4),
('Cineplex', 'Plovdiv, Bulgaria', 6),
('Cinema City', 'Burgas, Bulgaria', 3);


INSERT INTO halls (name, capacity, status, projection_id, films_id, cinema_id) VALUES
('Hall 1', 100, 'VIP', 1, 1, 1),
('Hall 2', 80, 'DELUXE', 2, 2, 2),
('Hall 3', 60, '4D', 3, 3, 3),
('Hall 4', 120, 'VIP', 4, 4, 4),
('Hall 5', 90, 'DELUXE', 1, 1, 2),
('Hall 6', 70, '4D', 2, 2, 3),
('Hall 7', 100, 'VIP', 3, 3, 4),
('Hall 8', 80, 'DELUXE', 4, 4, 1),
('Hall 9', 60, '4D', 1, 1, 3),
('Hall 10', 120, 'VIP', 2, 2, 4),
('Hall 11', 90, 'DELUXE', 3, 3, 1),
('Hall 12', 70, '4D', 4, 4, 2);


INSERT INTO films_cinema (films_id, cinema_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 2),
(2, 3),
(3, 3),
(3, 4),
(4, 1),
(4, 4);


INSERT INTO projection_cinema (projection_id, cinema_id) VALUES
(1, 1),
(1, 2),
(2, 2),
(2, 3),
(3, 3),
(3, 4),
(4, 1),
(4, 4);


#2
SELECT cinema.name, halls.id, projection.duration
FROM cinema JOIN halls ON cinema.id = halls.cinema_id
JOIN projection ON halls.projection_id = projection.id
JOIN films ON halls.films_id = films.id
WHERE films.name = 'Final Destination 7' AND (halls.status = 'VIP' OR halls.status = 'Deluxe')
ORDER BY cinema.name, halls.id;

#3
SELECT SUM(projection.audience) AS peopleNumber FROM projection
JOIN halls ON projection.id = halls.projection_id
JOIN films ON halls.films_id = films.id
JOIN films_cinema ON films.id = films_cinema.films_id
JOIN cinema ON films_cinema.cinema_id = cinema.id
WHERE films.name = 'Final Destination 7' AND
halls.status = 'VIP'  AND cinema.name = 'Arena Mladost';

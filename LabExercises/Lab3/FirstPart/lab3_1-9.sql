DROP DATABASE IF EXISTS school_sport_clubs;
CREATE DATABASE school_sport_clubs;
USE school_sport_clubs;

CREATE TABLE school_sport_clubs.sports(
	id INT AUTO_INCREMENT PRIMARY KEY ,
	name VARCHAR(255) NOT NULL
);

CREATE TABLE school_sport_clubs.coaches(
	id INT AUTO_INCREMENT PRIMARY KEY ,
	name VARCHAR(255) NOT NULL ,
	egn VARCHAR(10) NOT NULL UNIQUE
);

CREATE TABLE school_sport_clubs.students(
	id INT AUTO_INCREMENT PRIMARY KEY ,
	name VARCHAR(255) NOT NULL ,
	egn VARCHAR(10) NOT NULL UNIQUE ,
	address VARCHAR(255) NOT NULL ,
	phone VARCHAR(20) NULL DEFAULT NULL ,
	class VARCHAR(10) NULL DEFAULT NULL   
);

CREATE TABLE school_sport_clubs.sportGroups(
	id INT AUTO_INCREMENT PRIMARY KEY ,
	location VARCHAR(255) NOT NULL ,
	dayOfWeek ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') ,
	hourOfTraining TIME NOT NULL ,
	sport_id INT NULL ,
	coach_id INT NULL ,
	UNIQUE KEY(location,dayOfWeek,hourOfTraining)  ,
	CONSTRAINT FOREIGN KEY(sport_id) 
	REFERENCES sports(id) ,
	CONSTRAINT FOREIGN KEY (coach_id) 
	REFERENCES coaches(id)
);

CREATE TABLE school_sport_clubs.student_sport(
	student_id INT NOT NULL , 
	sportGroup_id INT NOT NULL ,  
	CONSTRAINT FOREIGN KEY (student_id) 
	REFERENCES students(id) ,	
	CONSTRAINT FOREIGN KEY (sportGroup_id) 
	REFERENCES sportGroups(id) ,
	PRIMARY KEY(student_id,sportGroup_id)
);

INSERT INTO sports
VALUES 	(NULL, 'Football') ,
	(NULL, 'Volleyball') ,
	(NULL, 'Tennis');
		
INSERT INTO coaches  
VALUES 	(NULL, 'Ivan Todorov Petkov', '7509041245') ,
	(NULL, 'Georgi Ivanov Todorov', '8010091245') ,
	(NULL, 'Ilian Todorov Georgiev', '8407106352') ,
	(NULL, 'Petar Slavkov Yordanov', '7010102045') ,
	(NULL, 'Todor Ivanov Ivanov', '8302160980') , 
	(NULL, 'Slavi Petkov Petkov', '7106041278');
		
INSERT INTO students (name, egn, address, phone, class) 
VALUES 	('Iliyan Ivanov', '9401150045', 'Sofia-Mladost 1', '0893452120', '10') ,
	('Ivan Iliev Georgiev', '9510104512', 'Sofia-Liylin', '0894123456', '11') ,
	('Elena Petrova Petrova', '9505052154', 'Sofia-Mladost 3', '0897852412', '11') ,
	('Ivan Iliev Iliev', '9510104542', 'Sofia-Mladost 3', '0894123457', '11') ,
	('Maria Hristova Dimova', '9510104547', 'Sofia-Mladost 4', '0894123442', '11') ,
	('Antoaneta Ivanova Georgieva', '9411104547', 'Sofia-Krasno selo', '0874526235', '10');
		
INSERT INTO sportGroups
VALUES 	(NULL, 'Sofia-Mladost 1', 'Monday', '08:00:00', 1, 1 ) ,
	(NULL, 'Sofia-Mladost 1', 'Monday', '09:30:00', 2, 1 ) ,
	(NULL, 'Sofia-Liylin 7', 'Sunday', '09:00:00', 2, 2) ,
        (NULL, 'Sofia-Liylin 3', 'Tuesday', '09:00:00', 2, 2) ,
	(NULL, 'Sofia-Liylin 3', 'Friday', '09:00:00', NULL, NULL) ,
	(NULL, 'Sofia-Nadezhda', 'Sunday', '08:00:00', 1, NULL);
		
INSERT INTO student_sport 
VALUES 	(1, 1),
	(2, 1),
	(3, 1),
	(4, 2),
	(5, 2),
	(6, 2);

#1
INSERT INTO students (name, egn, address, class, phone)
VALUES ('Ivan Ivanov Ivanov', '9207186371', 'Sofia-Serdika', '10', '0888892950');

#2
SELECT * FROM students ORDER BY name;

#3
DELETE FROM students
WHERE name = 'Ivan Ivanov Ivanov' AND egn = '9207186371' AND address = 'Sofia-Serdika' AND class = '10' AND phone = '0888892950';

#4
SELECT students.name, sports.name
FROM students
JOIN student_sport ON student_sport.student_id = students.id
JOIN sportGroups ON student_sport.sportGroup_id = sportGroups.id
JOIN sports ON sportGroups.sport_id = sports.id;

#5
SELECT students.name, students.class, student_sport.sportGroup_id
FROM students 
JOIN student_sport ON students.id = student_sport.student_id
JOIN sportGroups ON student_sport.sportGroup_id = sportGroups.id
WHERE sportGroups.dayOfWeek = 'Monday';

#6
SELECT coaches.name
FROM coaches
JOIN sportGroups ON sportGroups.coach_id = coaches.id
JOIN sports ON sportGroups.sport_id = sports.id
WHERE sports.name = 'Football';

#7
SELECT location, dayOfWeek, hourOfTraining
FROM sportGroups
JOIN sports ON sports.id = sportGroups.sport_id
WHERE sports.name = 'Volleyball';

#8
SELECT sports.name
FROM sports
JOIN sportGroups ON sports.id = sportGroups.sport_id
JOIN student_sport ON sportGroups.id = student_sport.sportGroup_id
JOIN students ON student_sport.student_id = students.id
WHERE students.name = 'Iliyan Ivanov';

#9
SELECT students.name
FROM students
JOIN student_sport ON students.id = student_sport.student_id
JOIN sportGroups ON student_sport.sportGroup_id = sportGroups.id
JOIN coaches ON sportGroups.coach_id = coaches.id
JOIN sports ON sportGroups.sport_id = sports.id 
WHERE sports.name = 'Football' AND coaches.name = 'Ivan Todorov Petkov';

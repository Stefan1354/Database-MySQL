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

CREATE TABLE taxesPayments(
	id INT AUTO_INCREMENT PRIMARY KEY,
	student_id INT NOT NULL,
	group_id INT NOT NULL,
	paymentAmount DOUBLE NOT NULL,
	month TINYINT,
	year YEAR,
	dateOfPayment DATETIME NOT NULL ,
	CONSTRAINT FOREIGN KEY (student_id) 
	REFERENCES students(id),
	CONSTRAINT FOREIGN KEY (group_id) 
	REFERENCES sportgroups(id)
);

CREATE TABLE salaryPayments(
	id INT AUTO_INCREMENT PRIMARY KEY,
	coach_id INT NOT NULL,
	month TINYINT,
	year YEAR,
	salaryAmount double,
	dateOfPayment datetime not null,
	CONSTRAINT FOREIGN KEY (coach_id) 
	REFERENCES coaches(id),
	UNIQUE KEY(`coach_id`,`month`,`year`)
);

INSERT INTO sports
VALUES 	(NULL, 'Football') ,
	(NULL, 'Volleyball') ,
	(NULL, 'Tennis') ,
	(NULL, 'Karate') ,
	(NULL, 'Taekwon-do');
		
INSERT INTO coaches  
VALUES 	(NULL, 'Ivan Todorov Petkov', '7509041245') ,
	(NULL, 'georgi Ivanov Todorov', '8010091245') ,
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
	(NULL, 'Sofia-Mladost 1', 'Monday', '09:30:00', 1, 2 ) ,
	(NULL, 'Sofia-Liylin 7', 'Sunday', '08:00:00', 2, 1) ,
	(NULL, 'Sofia-Liylin 2', 'Sunday', '09:30:00', 2, 2) ,	
	(NULL, 'Sofia-Liylin 3', 'Tuesday', '09:00:00', NULL, NULL) ,			
	(NULL, 'Plovdiv', 'Monday', '12:00:00', '1', '1');
		
INSERT INTO student_sport 
VALUES 	(1, 1),
	(2, 1),
	(3, 1),
	(4, 2),
	(5, 2),
	(6, 2),
	(1, 3),
	(2, 3),
	(3, 3);
		
INSERT INTO `school_sport_clubs`.`taxespayments` 
VALUES	(NULL, '1', '1', '200', '1', 2022, now()),
	(NULL, '1', '1', '200', '2', 2022, now()),
	(NULL, '1', '1', '200', '3', 2022, now()),
	(NULL, '1', '1', '200', '4', 2022, now()),
	(NULL, '1', '1', '200', '5', 2022, now()),
	(NULL, '1', '1', '200', '6', 2022, now()),
	(NULL, '1', '1', '200', '7', 2022, now()),
	(NULL, '1', '1', '200', '8', 2022, now()),
	(NULL, '1', '1', '200', '9', 2022, now()),
	(NULL, '1', '1', '200', '10', 2022, now()),
	(NULL, '1', '1', '200', '11', 2022, now()),
	(NULL, '1', '1', '200', '12', 2022, now()),
	(NULL, '2', '1', '250', '1', 2022, now()),
	(NULL, '2', '1', '250', '2', 2022, now()),
	(NULL, '2', '1', '250', '3', 2022, now()),
	(NULL, '2', '1', '250', '4', 2022, now()),
	(NULL, '2', '1', '250', '5', 2022, now()),
	(NULL, '2', '1', '250', '6', 2022, now()),
	(NULL, '2', '1', '250', '7', 2022, now()),
	(NULL, '2', '1', '250', '8', 2022, now()),
	(NULL, '2', '1', '250', '9', 2022, now()),
	(NULL, '2', '1', '250', '10', 2022, now()),
	(NULL, '2', '1', '250', '11', 2022, now()),
	(NULL, '2', '1', '250', '12', 2022, now()),
	(NULL, '3', '1', '250', '1', 2022, now()),
	(NULL, '3', '1', '250', '2', 2022, now()),
	(NULL, '3', '1', '250', '3', 2022, now()),
	(NULL, '3', '1', '250', '4', 2022, now()),
	(NULL, '3', '1', '250', '5', 2022, now()),
	(NULL, '3', '1', '250', '6', 2022, now()),
	(NULL, '3', '1', '250', '7', 2022, now()),
	(NULL, '3', '1', '250', '8', 2022, now()),
	(NULL, '3', '1', '250', '9', 2022, now()),
	(NULL, '3', '1', '250', '10', 2022, now()),
	(NULL, '3', '1', '250', '11', 2022, now()),
	(NULL, '3', '1', '250', '12', 2022, now()),
	(NULL, '1', '2', '200', '1', 2022, now()),
	(NULL, '1', '2', '200', '2', 2022, now()),
	(NULL, '1', '2', '200', '3', 2022, now()),
	(NULL, '1', '2', '200', '4', 2022, now()),
	(NULL, '1', '2', '200', '5', 2022, now()),
	(NULL, '1', '2', '200', '6', 2022, now()),
	(NULL, '1', '2', '200', '7', 2022, now()),
	(NULL, '1', '2', '200', '8', 2022, now()),
	(NULL, '1', '2', '200', '9', 2022, now()),
	(NULL, '1', '2', '200', '10', 2022, now()),
	(NULL, '1', '2', '200', '11', 2022, now()),
	(NULL, '1', '2', '200', '12', 2022, now()),
	(NULL, '4', '2', '200', '1', 2022, now()),
	(NULL, '4', '2', '200', '2', 2022, now()),
	(NULL, '4', '2', '200', '3', 2022, now()),
	(NULL, '4', '2', '200', '4', 2022, now()),
	(NULL, '4', '2', '200', '5', 2022, now()),
	(NULL, '4', '2', '200', '6', 2022, now()),
	(NULL, '4', '2', '200', '7', 2022, now()),
	(NULL, '4', '2', '200', '8', 2022, now()),
	(NULL, '4', '2', '200', '9', 2022, now()),
	(NULL, '4', '2', '200', '10', 2022, now()),
	(NULL, '4', '2', '200', '11', 2022, now()),
	(NULL, '4', '2', '200', '12', 2022, now()),
	/**2021**/
	(NULL, '1', '1', '200', '1', 2021, now()),
	(NULL, '1', '1', '200', '2', 2021, now()),
	(NULL, '1', '1', '200', '3', 2021, now()),
	(NULL, '1', '1', '200', '4', 2021, now()),
	(NULL, '1', '1', '200', '5', 2021, now()),
	(NULL, '1', '1', '200', '6', 2021, now()),
	(NULL, '1', '1', '200', '7', 2021, now()),
	(NULL, '1', '1', '200', '8', 2021, now()),
	(NULL, '1', '1', '200', '9', 2021, now()),
	(NULL, '1', '1', '200', '10', 2021, now()),
	(NULL, '1', '1', '200', '11', 2021, now()),
	(NULL, '1', '1', '200', '12', 2021, now()),
	(NULL, '2', '1', '250', '1', 2021, now()),
	(NULL, '2', '1', '250', '2', 2021, now()),
	(NULL, '2', '1', '250', '3', 2021, now()),
	(NULL, '2', '1', '250', '4', 2021, now()),
	(NULL, '2', '1', '250', '5', 2021, now()),
	(NULL, '2', '1', '250', '6', 2021, now()),
	(NULL, '2', '1', '250', '7', 2021, now()),
	(NULL, '2', '1', '250', '8', 2021, now()),
	(NULL, '2', '1', '250', '9', 2021, now()),
	(NULL, '2', '1', '250', '10', 2021, now()),
	(NULL, '2', '1', '250', '11', 2021, now()),
	(NULL, '2', '1', '250', '12', 2021, now()),
	(NULL, '3', '1', '250', '1', 2021, now()),
	(NULL, '3', '1', '250', '2', 2021, now()),
	(NULL, '3', '1', '250', '3', 2021, now()),
	(NULL, '3', '1', '250', '4', 2021, now()),
	(NULL, '3', '1', '250', '5', 2021, now()),
	(NULL, '3', '1', '250', '6', 2021, now()),
	(NULL, '3', '1', '250', '7', 2021, now()),
	(NULL, '3', '1', '250', '8', 2021, now()),
	(NULL, '3', '1', '250', '9', 2021, now()),
	(NULL, '3', '1', '250', '10', 2021, now()),
	(NULL, '3', '1', '250', '11', 2021, now()),
	(NULL, '3', '1', '250', '12', 2021, now()),
	(NULL, '1', '2', '200', '1', 2021, now()),
	(NULL, '1', '2', '200', '2', 2021, now()),
	(NULL, '1', '2', '200', '3', 2021, now()),
	(NULL, '1', '2', '200', '4', 2021, now()),
	(NULL, '1', '2', '200', '5', 2021, now()),
	(NULL, '1', '2', '200', '6', 2021, now()),
	(NULL, '1', '2', '200', '7', 2021, now()),
	(NULL, '1', '2', '200', '8', 2021, now()),
	(NULL, '1', '2', '200', '9', 2021, now()),
	(NULL, '1', '2', '200', '10', 2021, now()),
	(NULL, '1', '2', '200', '11', 2021, now()),
	(NULL, '1', '2', '200', '12', 2021, now()),
	(NULL, '4', '2', '200', '1', 2021, now()),
	(NULL, '4', '2', '200', '2', 2021, now()),
	(NULL, '4', '2', '200', '3', 2021, now()),
	(NULL, '4', '2', '200', '4', 2021, now()),
	(NULL, '4', '2', '200', '5', 2021, now()),
	(NULL, '4', '2', '200', '6', 2021, now()),
	(NULL, '4', '2', '200', '7', 2021, now()),
	(NULL, '4', '2', '200', '8', 2021, now()),
	(NULL, '4', '2', '200', '9', 2021, now()),
	(NULL, '4', '2', '200', '10', 2021, now()),
	(NULL, '4', '2', '200', '11', 2021, now()),
	(NULL, '4', '2', '200', '12', 2021, now()),
	/**2020**/
	(NULL, '1', '1', '200', '1', 2020, now()),
	(NULL, '1', '1', '200', '2', 2020, now()),
	(NULL, '1', '1', '200', '3', 2020, now()),
	(NULL, '2', '1', '250', '1', 2020, now()),
	(NULL, '3', '1', '250', '1', 2020, now()),
	(NULL, '3', '1', '250', '2', 2020, now()),
	(NULL, '1', '2', '200', '1', 2020, now()),
	(NULL, '1', '2', '200', '2', 2020, now()),
	(NULL, '1', '2', '200', '3', 2020, now()),
	(NULL, '4', '2', '200', '1', 2020, now()),
        (NULL, '4', '2', '200', '2', 2020, now());
	
#4
SELECT s1.name AS student1, s2.name AS student2, sp.name AS sportName, sg.location, sg.dayOfWeek, sg.hourOfTraining
FROM students s1
JOIN student_sport ss1 ON s1.id = ss1.student_id
JOIN sportGroups sg ON ss1.sportGroup_id = sg.id
JOIN sports sp ON sg.sport_id = sp.id
JOIN student_sport ss2 ON ss1.sportGroup_id = ss2.sportGroup_id AND ss1.student_id < ss2.student_id
JOIN students s2 ON s2.id = ss2.student_id AND sp.name = 'Football';

#5
CREATE VIEW tables
AS
SELECT students.name, students.class, sportgroups.location, coaches.name
FROM students JOIN student_sport ON students.id = student_sport.student_id
JOIN sportgroups ON student_sport.sportGroup_id = sportgroups.id
JOIN sports ON sportgroups.sport_id = sports.id
JOIN coaches ON sportgroups.coach_id = coaches.id
WHERE sporrgroups.hourOfTraining = '08:00:00';


#6
SELECT sports.name, COUNT(students.id) AS numberOfStudents
FROM sports JOIN sportgroups ON sports.id = sportgroups.sport_id
JOIN student_sport ON student_sport.sportGroup_id = sportgroups.id
JOIN students ON student_sport.student_id = students.id
GROUP BY sports.name;

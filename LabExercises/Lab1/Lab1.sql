DROP DATABASE IF EXISTS sportClubs;
CREATE DATABASE sportClubs;
USE sportClubs;

CREATE TABLE students (
id INT auto_increment PRIMARY KEY, 
studentName VARCHAR(255) NOT NULL,
fNum CHAR(10) NOT NULL UNIQUE,
phone VARCHAR(50) NULL
);

CREATE TABLE coaches (
id INT auto_increment PRIMARY KEY, 
coachName VARCHAR(255) NOT NULL,
egn CHAR(10) NOT NULL UNIQUE
);

CREATE TABLE clubs (
id INT auto_increment PRIMARY KEY, 
sportName VARCHAR(255) NOT NULL
);

CREATE TABLE sportGroups(
id INT auto_increment PRIMARY KEY,
dayOfWeek ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), 
hourOfDay TIME NOT NULL,
place VARCHAR(255) NOT NULL,
club_id INT NOT NULL,
coach_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (club_id) REFERENCES clubs(id),
CONSTRAINT FOREIGN KEY (coach_id) REFERENCES coaches(id),
unique KEY(dayOfWeek, hourOfDay, place)
);

CREATE TABLE student_group(
student_id INT NOT NULL,
group_id INT NOT NULL,
CONSTRAINT FOREIGN KEY (student_id) REFERENCES students(id),
CONSTRAINT FOREIGN KEY (group_id) REFERENCES sportGroups(id),
PRIMARY KEY(student_id, group_id)
);

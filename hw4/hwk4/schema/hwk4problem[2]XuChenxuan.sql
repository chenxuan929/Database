DROP DATABASE IF EXISTS School;
CREATE DATABASE School;
USE School;


CREATE TABLE school (
    school_indentification_no INT PRIMARY KEY NOT NULL,
    school_name VARCHAR(64),
    town VARCHAR(64),
    street VARCHAR(64),
    zip_code INT
);

CREATE TABLE pupil (
    pupil_indentification_no INT PRIMARY KEY NOT NULL,
    first_name VARCHAR(64),
    last_name VARCHAR(64),
    sex CHAR(1),
    birth_date DATE,
    schoolID INT,
    FOREIGN KEY (schoolID) REFERENCES school(school_indentification_no) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE teacher ( 
    NIN CHAR(9) PRIMARY KEY NOT NULL,
    first_name VARCHAR(64),
    last_name VARCHAR(64),
    sex CHAR(1),
    qualifications TEXT,
    schoolID INT,
    FOREIGN KEY (schoolID) REFERENCES school(school_indentification_no) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE manager (
	manager_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL, 
	starting_date DATE,
    schoolID INT,
    teacherNIN CHAR(9),
    FOREIGN KEY (schoolID) REFERENCES school(school_indentification_no) ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (teacherNIN) REFERENCES teacher(NIN) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE subject (
    subject_name VARCHAR(64) PRIMARY KEY NOT NULL,
    subject_level ENUM ('undergraduate', 'graduate') NOT NULL,
    subject_abbreviation VARCHAR(16) UNIQUE NOT NULL
);

CREATE TABLE class (
    class_no INT,
    teacherNIN CHAR(9),
    teach_hours INT,
    subjectName VARCHAR(64),
    PRIMARY KEY(class_no, subjectName),
    FOREIGN KEY (teacherNIN) REFERENCES teacher(NIN) ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (subjectName) REFERENCES subject(subject_name) ON DELETE RESTRICT ON UPDATE RESTRICT
);









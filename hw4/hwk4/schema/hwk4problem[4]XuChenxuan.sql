DROP DATABASE IF EXISTS Blood;
CREATE DATABASE Blood;
USE Blood;


CREATE TABLE clinic (
	clinic_no INT PRIMARY KEY NOT NULL,
    clinic_name VARCHAR(64) DEFAULT 'AK',
    street_no VARCHAR(64) DEFAULT 'AK',
    street_name VARCHAR(64),
    town VARCHAR(64),
    zip_code VARCHAR(16)
    );
    
CREATE TABLE staff (
	first_name VARCHAR(64),
    last_name VARCHAR(64),
    empNo INT PRIMARY KEY NOT NULL,
    start_date DATE,
    clinicNo INT,
    FOREIGN KEY (clinicNo) REFERENCES clinic(clinic_no) 
		ON UPDATE RESTRICT ON DELETE RESTRICT);
        
CREATE TABLE blood_classification (
	blood_type ENUM('A', 'B', 'AB', 'O') NOT NULL,
    rh_factor ENUM('positive', 'negative') NOT NULL,
    PRIMARY KEY (blood_type, rh_factor));
    
CREATE TABLE donor (
	patientID INT PRIMARY KEY NOT NULL,
    first_name VARCHAR(64),
    last_name VARCHAR(64),
    age INT,
    biological_gender ENUM('male', 'female'),
    username VARCHAR(255) UNIQUE,
	bloodType ENUM('A', 'B', 'AB', 'O'),
    rhFactor ENUM('positive', 'negative'),
    FOREIGN KEY (bloodType, rhFactor) REFERENCES blood_classification(blood_type, rh_factor) 
		ON UPDATE RESTRICT ON DELETE RESTRICT);
	
        
CREATE TABLE donation (
	donation_id INT PRIMARY KEY,
    donation_date DATE,
    clinicNo INT,
    patientID INT,
    FOREIGN KEY (clinicNo) REFERENCES clinic(clinic_no) 
		ON UPDATE RESTRICT ON DELETE RESTRICT,
	FOREIGN KEY (patientID) REFERENCES donor(patientID) 
		ON UPDATE RESTRICT ON DELETE RESTRICT);

CREATE TABLE blood_bag (
	serial_number INT PRIMARY KEY,
    bag_filled BOOLEAN,
    clinicNo INT,
    donationID INT,
    FOREIGN KEY (donationID) REFERENCES donation(donation_id)
		ON UPDATE RESTRICT ON DELETE RESTRICT);
        
CREATE TABLE contest (
	contest_name VARCHAR(64) PRIMARY KEY NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    prize VARCHAR(255),
    clinicNo INT,
    winnerID INT,
    FOREIGN KEY(winnerID) REFERENCES donor(patientID) 
		ON UPDATE RESTRICT ON DELETE RESTRICT
	);
    
CREATE TABLE donorContest (
	patientID INT,
    contestName VARCHAR(64),
    donationTimes INT DEFAULT 0,
    PRIMARY KEY(patientID, contestName),
    FOREIGN KEY (patientID) REFERENCES donor(patientID) 
		ON UPDATE RESTRICT ON DELETE RESTRICT,
	FOREIGN KEY (contestName) REFERENCES contest(contest_name)
		ON UPDATE RESTRICT ON DELETE RESTRICT);
    
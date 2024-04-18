DROP DATABASE IF EXISTS crime_db2022xuc;
CREATE DATABASE crime_db2022xuc;
USE crime_db2022xuc;


CREATE TABLE districts (
	d_code VARCHAR(10) PRIMARY KEY NOT NULL,
    d_name VARCHAR(100) NOT NULL
);


CREATE TABLE offense_codes (
	o_code INT PRIMARY KEY,
    description VARCHAR(100) NOT NULL
);


CREATE TABLE incidents (
	incident_number INT PRIMARY KEY,
    offense_code INT NOT NULL,
    reporting_area INT,
    shotting ENUM('0', '1') NOT NULL,
    i_year INT DEFAULT 2022,
    i_month INT DEFAULT 12,
    i_day_of_week ENUM('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday') NOT NULL,
    i_hour INT NOT NULL,
    street VARCHAR(64) NOT NULL,
    latitude DOUBLE NOT NULL,
    longitude DOUBLE NOT NULL,
    incident_date DATETIME NOT NULL,
    district VARCHAR(10) NOT NULL,
    CONSTRAINT hour_constraint CHECK(i_hour>=0 AND i_hour <24),
    FOREIGN KEY (district) REFERENCES districts(d_code),
    FOREIGN KEY (offense_code) REFERENCES offense_codes(o_code) ON DELETE RESTRICT ON UPDATE RESTRICT
);


CREATE TABLE neighborhoods (
	n_code VARCHAR(10) NOT NULL,
	n_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (n_code, n_name),
	FOREIGN KEY (n_code) REFERENCES districts(d_code) ON DELETE RESTRICT ON UPDATE RESTRICT
);


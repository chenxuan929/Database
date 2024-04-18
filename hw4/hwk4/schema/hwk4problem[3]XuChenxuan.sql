DROP DATABASE IF EXISTS NationalPark;
CREATE DATABASE NationalPark;
USE NationalPark;


CREATE TABLE global_location (
    central_latitude FLOAT NOT NULL,
    central_longitude FLOAT NOT NULL,
    locationID INT PRIMARY KEY AUTO_INCREMENT,
    CONSTRAINT unique_location UNIQUE (central_latitude, central_longitude)
);

CREATE TABLE political_territory (
    territory_name VARCHAR(64) PRIMARY KEY NOT NULL ,
    territory_type ENUM('US STATE', 'official US territory') NOT NULL,
    locationID INT,
    FOREIGN KEY (locationID) REFERENCES global_location(locationID) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE adjacent_territory (
    territory_name1 VARCHAR(64),
    territory_name2 VARCHAR(64),
    PRIMARY KEY (territory_name1, territory_name2),
    FOREIGN KEY (territory_name1) REFERENCES political_territory (territory_name)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (territory_name2) REFERENCES political_territory (territory_name)
        ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE national_park (
    park_name VARCHAR(64) PRIMARY KEY,
    photo_collection BLOB,
    direction TEXT,
    description TEXT,
    locationID INT,
    FOREIGN KEY (locationID) REFERENCES global_location(locationID) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE site (
    site_name VARCHAR(64) PRIMARY KEY,
    description TEXT,
    photo_collection BLOB,
    driving_direction TEXT,
    park_name VARCHAR(64),
    locationID INT,
    FOREIGN KEY (locationID) REFERENCES global_location(locationID) ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (park_name) REFERENCES national_park(park_name) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE accommodation (
    type ENUM('Campsite', 'Hotel'),
    accommodation_id INT PRIMARY KEY,
    accommodation_name VARCHAR(64),
    destination_direction TEXT,
    cost_per_night FLOAT,
    phone_no VARCHAR(16) UNIQUE,
    locationID INT,
    park_name VARCHAR(64),
    FOREIGN KEY (locationID) REFERENCES global_location(locationID) ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (park_name) REFERENCES national_park(park_name) ON DELETE RESTRICT ON UPDATE RESTRICT
);





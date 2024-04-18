DROP DATABASE IF EXISTS Chain;
CREATE DATABASE Chain;
USE Chain;

CREATE TABLE customer (
	first_name VARCHAR(64),
    last_name VARCHAR(64),
    local_address VARCHAR(64),
    customer_id INT PRIMARY KEY NOT NULL
);

CREATE TABLE chain (
	chain_id INT PRIMARY KEY NOT NULL,
    street_no INT,
    street_name VARCHAR(64),
    zip_code INT,
    state_abbreviation TEXT,
    open_time TIME,
    closing_time TIME
);

CREATE TABLE staff_member (
	staff_no INT PRIMARY KEY NOT NULL,
    fist_name VARCHAR(64),
    last_name VARCHAR(64)
);

CREATE TABLE manager (
	start_date DATE
);

CREATE TABLE product_genres (
	genres_id INT PRIMARY KEY NOT NULL,
    genres_name VARCHAR(64),
    product_genre ENUM('bakery', 'non-perishable', 'produce', 'meat', 'dairy products')
);

CREATE TABLE product_type (
	type_name VARCHAR(64) PRIMARY KEY NOT NULL,
    genres_id INT,
    CONSTRAINT genres_id_fk FOREIGN KEY (genres_id)
		REFERENCES product_genres(genres_id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE orders (
	order_id INT PRIMARY KEY NOT NULL,
    identification_type ENUM('credit card', 'driving license', 'passport'),
    chain_id INT,
    customer_id INT,
    CONSTRAINT order_chain_id_fk FOREIGN KEY (chain_id) 
		REFERENCES chain(chain_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT order_customer_id_fk FOREIGN KEY (customer_id) 
		REFERENCES customer(customer_id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE inventory (
	chain_id INT,
    type_name  VARCHAR(64),
    quantity INT,
    CONSTRAINT inventory_chain_id_fk FOREIGN KEY (chain_id) 
		REFERENCES chain(chain_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT inventory_type_name_fk FOREIGN KEY (type_name) 
		REFERENCES product_type(type_name) ON DELETE RESTRICT ON UPDATE RESTRICT,
    PRIMARY KEY(chain_id, type_name)
);


CREATE TABLE credit_card_info (
	card_number VARCHAR(19) PRIMARY KEY NOT NULL,
    card_type ENUM('VISA', 'AMEX', 'Mastercard'),
    expiration_date DATE,
    customer_id INT,
    CONSTRAINT cc_customer_id_fk FOREIGN KEY (customer_id) 
		REFERENCES customer(customer_id) ON DELETE RESTRICT ON UPDATE RESTRICT
);






	



DROP DATABASE IF EXISTS movie;
CREATE DATABASE movie;
USE movie;

CREATE TABLE users (
	login_id INT PRIMARY KEY,
    Name VARCHAR(256) NOT NULL,
    age INT,
    origin_country VARCHAR(256)
);

CREATE TABLE genres (
	genres_type ENUM('Crime', 'Super Natural', 'Drama', 'Comedy', 'Thriller', 'Western', 'Horror', 'Fantasy','Documentary')
);

CREATE TABLE production_componies (
	compony_id INT PRIMARY KEY,
    c_name VARCHAR(256) NOT NULL,
    address VARCHAR(256),
    description VARCHAR(256)
);


CREATE TABLE books (
	book_id INT PRIMARY KEY,
    title VARCHAR(256) NOT NULL,
    author VARCHAR(256) NOT NULL
);

CREATE TABLE producers (
	p_id INT PRIMARY KEY,
    p_name VARCHAR(256) NOT NULL,
    date_birth DATE NOT NULL,
    description VARCHAR(256),
    combination_role_id INT
);

CREATE TABLE directers (
	d_id INT PRIMARY KEY,
    d_name VARCHAR(256) NOT NULL,
    date_birth DATE NOT NULL,
    description VARCHAR(256),
    combination_role_id INT
);



CREATE TABLE movies (
	movie_id INT PRIMARY KEY,
	title VARCHAR(256) UNIQUE,
    original_language VARCHAR(256) NOT NULL,
    origin_country VARCHAR(256) NOT NULL,
    platform_type ENUM('streaming', 'theater', 'network television station'),
    description VARCHAR(256),
    product_compony_id INT,
    book_id INT,
    producer_id INT,
    directer_id INT,
    FOREIGN KEY (product_compony_id) REFERENCES production_componies(compony_id) ON UPDATE RESTRICT ON DELETE RESTRICT,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON UPDATE RESTRICT ON DELETE RESTRICT,
    FOREIGN KEY (producer_id) REFERENCES producers(p_id) ON UPDATE RESTRICT ON DELETE RESTRICT,
    FOREIGN KEY (directer_id) REFERENCES directers(d_id) ON UPDATE RESTRICT ON DELETE RESTRICT
);


CREATE TABLE actors (
	actor_id INT PRIMARY KEY,
    name VARCHAR(256) NOT NULL,
    date_birth DATE NOT NULL,
    description VARCHAR(256),
    combination_role_id INT,
    movie_id INT,
    char_id INT,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE character_roles (
	role_name VARCHAR(256) NOT NULL,
    description VARCHAR(256),
    time_on_screen INT,
    movie_id INT,
    actor_id INT,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (actor_id) REFERENCES actors(actor_id) ON UPDATE CASCADE ON DELETE CASCADE
);



CREATE TABLE rates (
	rate_score ENUM('1','2','3','4','5','6','7','8','9','10')NOT NULL,
    optional_review VARCHAR(256),
    date DATE NOT NULL,
    user_id INT,
    movie_id INT,
    FOREIGN KEY (user_id) REFERENCES users(login_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON UPDATE CASCADE ON DELETE CASCADE
);





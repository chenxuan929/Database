USE musicxuc;


-- (1)
-- Write a function num_songs_with_genre(genre_p) that accepts a genre name and returns the number of songs with the genre.
DELIMITER //
DROP FUNCTION IF EXISTS num_songs_with_genre;
CREATE FUNCTION num_songs_with_genre(genre_p VARCHAR(50)) RETURNS INT
READS SQL DATA
BEGIN
	DECLARE song_count INT;
    SELECT COUNT(*) INTO song_count FROM songs s
    JOIN genres g ON s.genre_id = g.gid
    WHERE g.genre_name = genre_p;
    RETURN song_count;
END;
//
DELIMITER ;
-- test
SELECT num_songs_with_genre('Rock') AS song_count;
SELECT num_songs_with_genre('Jazz') AS song_count;
SELECT num_songs_with_genre('Pop') AS song_count;



/*
-- (2) 
-- Write a procedure get_artists_with_label(label_p) that accepts a record label name and returns a result set of all artist names and the corresponding label name.
DELIMITER //
DROP PROCEDURE IF EXISTS get_artists_with_label;
CREATE PROCEDURE get_artists_with_label(label_p VARCHAR(50))
BEGIN 
	SELECT artist_name, label_name FROM artists JOIN record_label ON artists.record_label_id = record_label.rid
    WHERE label_name = label_p;
END //
DELIMITER ;

-- test
CALL get_artists_with_label('LabelName');
CALL get_artists_with_label("Atlantic Records");
CALL get_artists_with_label("Warner Music Group");




-- (3)
--   Write a procedure named song_has_genre(genre_p) that accepts a genre name and returns a result set of the songs with that genre. The result should contain the song id , the song name, and the album name. If a genre is provided that is not found in the genre table, generate an error from the procedure stating that the passed genre is not valid and use SIGNAL to throw error ‘45000’.
DELIMITER //
DROP PROCEDURE IF EXISTS song_has_genre;
CREATE PROCEDURE song_has_genre(IN genre_p VARCHAR(50)) 
BEGIN
	DECLARE genre_id INT;
	SELECT g.gid INTO genre_id FROM genres g WHERE genre_name = genre_p;
    IF genre_id IS NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid genre';
	ELSE
		SELECT s.sid, s.song_name, al.album_name
        FROM songs s
		JOIN albums al ON al.alid = s.album_id
		WHERE genre_id = s.genre_id;
	END IF;
END;
//
DELIMITER ;

-- test
CALL song_has_genre('Jazz');
CALL song_has_genre('Pop');




-- (4) 
-- Write a function named album_length(length_p) that accepts one parameter, a count of songs and returns the number of albums with that length
DELIMITER //
DROP FUNCTION IF EXISTS album_length;
CREATE FUNCTION album_length(length_p INT) RETURNS INT
READS SQL DATA
BEGIN
	DECLARE album_count INT;
    SELECT COUNT(DISTINCT s.album_id) INTO album_count
    FROM songs s
    GROUP BY s.album_id
    HAVING COUNT(s.sid) = length_p;
    RETURN album_count;
END;
//
DELIMITER ;

-- test
SELECT album_length(2);
SELECT album_length(6);
SELECT album_length(8);




-- (5)
-- Write a procedure named get_song_details() that accepts a song name as an argument and returns the song name, the song id, the recording label, the album name, the genre name and the mood name.
DELIMITER //
DROP PROCEDURE IF EXISTS get_song_details;
CREATE PROCEDURE get_song_details(song_name_p VARCHAR(50)) 
BEGIN 
    SELECT songs.song_name, songs.sid, record_label.label_name, albums.album_name, genres.genre_name, moods.mood_name
    FROM songs
    JOIN albums ON songs.album_id = albums.alid
    JOIN genres ON songs.genre_id = genres.gid
    JOIN moods ON songs.mood_id = moods.mid
    JOIN artists ON albums.artist = artists.artist_name
    JOIN record_label ON artists.record_label_id = record_label.rid
    WHERE songs.song_name = song_name_p;

END //
DELIMITER ;

-- test
CALL get_song_details('Despacito');
CALL get_song_details('Happy Together');
CALL get_song_details('One More Night');




-- (6)
-- Write a function named more_followers(artist1,artist2). It accepts 2 artist names and returns 1 if artist1 has more followers than artist2, 0 if they have the same number of followers  , and -1 if artist2 has more followers that  artist1
DELIMITER //
DROP FUNCTION IF EXISTS more_followers;
CREATE FUNCTION more_followers(artist1 VARCHAR(50),artist2 VARCHAR(50)) RETURNS INT
READS SQL DATA
BEGIN
	DECLARE count_follower1 INT;
    DECLARE count_follower2 INT;
    
	SELECT COUNT(user_id) INTO count_follower1
    FROM user_follows_artist ufa
    JOIN artists ar ON ar.aid = ufa.aid
    WHERE ar.artist_name = artist1;
    
    SELECT COUNT(user_id) INTO count_follower2
    FROM user_follows_artist ufa
    JOIN artists ar ON ar.aid = ufa.aid
    WHERE ar.artist_name = artist2;
    
    IF count_follower1 > count_follower2 THEN 
		RETURN 1;
    ELSEIF count_follower1 = count_follower2 THEN 
		RETURN 0;
    ELSE 
		RETURN -1;
	END IF;
END;
//
DELIMITER ;

-- test
SELECT more_followers("Vanilla", "Still Woozy");
SELECT more_followers("The Weeknd", "Daddy Yankee"); 
SELECT more_followers("Still Woozy", "Vanilla"); 





-- (7)
-- Create a procedure named create_song( title_p, artist_p, record_label_p, mood_p, genre_p, album_title) that inserts a song  into the database . Make sure you create the appropriate tuples in the album and other required tables before attempting to insert the song.  Also, ensure that the specified record label, genre name and mood name already exist in the database. If they do not exist, use SIGNAL with error number 450000.  When adding a song, it can be associated with a known artist’s current existing album or the song could belong to a new album for the artist. Also, assume the producer of the song performs on the song.
DELIMITER //
DROP PROCEDURE IF EXISTS create_song;
CREATE PROCEDURE create_song( 
	title_p VARCHAR(50),
	artist_p VARCHAR(50),
	record_label_p VARCHAR(50),
	mood_p VARCHAR(50),
	genre_p VARCHAR(50),
	album_title_p VARCHAR(50)
)
BEGIN
	DECLARE record_label_id_e INT;
    DECLARE genre_id_e INT;
    DECLARE mood_id_e INT;
    DECLARE artist_id_e INT;
	DECLARE album_id_e INT;
    
	SELECT aid INTO artist_id_e FROM artists WHERE artist_name = artist_p;
    SELECT rid INTO record_label_id_e FROM record_label WHERE label_name = record_label_p;
    SELECT gid INTO genre_id_e FROM genres WHERE genre_name = genre_p;
    SELECT mid INTO mood_id_e FROM moods WHERE mood_name = mood_p;
    SELECT alid INTO album_id_e FROM albums WHERE album_name = album_title_p AND artist = artist_p;

    IF record_label_id_e IS NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid record label';
	END IF;
    IF genre_id_e IS NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid Genre';
	END IF;
     IF mood_id_e IS NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid Mood label';
	END IF;
    
	IF artist_id_e IS NULL THEN
		INSERT INTO artists(artist_name, record_label_id) VALUES (artist_p, record_label_p);
        SELECT LAST_INSERT_ID() INTO artist_id_e;
	END IF;
    
    IF album_id_e IS NULL THEN
		INSERT INTO albums(album_name, artist) VALUES (album_title_p, artist_p);
        SELECT LAST_INSERT_ID() INTO album_id_e;
	END IF;
    
    INSERT INTO songs(song_name, album_id, genre_id, mood_id)
    VALUES (title_p, album_id_e, genre_id_e, mood_id_e);
END //
DELIMITER ;

-- test
CALL create_song('Me about You', 'The Turtles', 'Def Jam Recordings', 'Calm', 'Pop', 'Happy Together');
SELECT * FROM artists WHERE artist_name = 'The Turtles';
SELECT * FROM record_label WHERE label_name = 'Def Jam Recordings';
SELECT * FROM genres WHERE genre_name = 'Pop';
SELECT * FROM moods WHERE mood_name = 'Calm';
SELECT * FROM albums WHERE album_name = 'Happy Together';
SELECT * FROM songs WHERE song_name = 'Me about You';





-- (8)
-- Write a procedure named get_songs_with_mood() that accepts a mood name and  returns the song name, the mood name, mood description and the artist who released the song.
DELIMITER //
DROP PROCEDURE IF EXISTS get_songs_with_mood;
CREATE PROCEDURE get_songs_with_mood(mood_name_p VARCHAR(50))
BEGIN
	SELECT s.song_name, m.mood_name, m.mood_description, al.artist
    FROM songs s
    JOIN moods m ON m.mid = s.mood_id
    JOIN albums al ON s.album_id = al.alid
    WHERE m.mood_name = mood_name_p;
END //
DELIMITER ;

-- test
CALL get_songs_with_mood('Calm');
CALL get_songs_with_mood('Energetic');
CALL get_songs_with_mood('Happy');

   
   

-- （9）
-- Modify the artists table to contain a field called num_released of type INTEGER and write a procedure called set_num_released_count(artist)  that accepts an artist name and  initializes the num_released field to the number of albums the artist has released. The artist table modification can occur outside or inside of the procedure but must be executed only once.
ALTER TABLE artists ADD COLUMN num_released INT DEFAULT 0;
DELIMITER //
DROP PROCEDURE IF EXISTS set_num_released_count;
CREATE PROCEDURE set_num_released_count(artist_name_p VARCHAR(50))
BEGIN
	DECLARE released_count INT;

    SELECT COUNT(*) INTO released_count FROM albums
    WHERE artist = artist_name_p;
    UPDATE artists SET num_released = released_count
    WHERE artist_name = artist_name_p;
END //
DELIMITER ;

-- test
CALL set_num_released_count('Artist1');
SELECT * FROM artists WHERE artist_name = 'Artist1';
CALL set_num_released_count('Artist2');
SELECT * FROM artists WHERE artist_name = 'Artist2';
CALL set_num_released_count('Artist3');




-- (10)
-- Create a procedure named update_all_artists_num_releases( ) that assigns the artist.num_releases  to the correct value. The correct value is determined by the number of albums the artist has released. Use the procedure from problem 9 to complete this procedure. You will need a cursor and a handler to complete this procedure
DELIMITER //
DROP PROCEDURE IF EXISTS update_all_artists_num_releases;
CREATE PROCEDURE update_all_artists_num_releases()
BEGIN
	DECLARE done INT DEFAULT FALSE;
    DECLARE artist_name_val VARCHAR(50);
    DECLARE cur CURSOR FOR SELECT artist_name FROM artists;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO artist_name_val;
        IF done THEN
            LEAVE read_loop;
        END IF;
		CALL set_num_released_count(artist_name_val);
	END LOOP;
	CLOSE cur;
END //
DELIMITER ;

-- test
CALL update_all_artists_num_releases();
SELECT * FROM artists;




-- (11)
-- Write a trigger that updates the artist table when an album  tuple is inserted into the database. The trigger will need to  assign the correct value of albums released for the artist. Name the trigger artist_update_after_insert_album. Insert an album  into the album table to verify your trigger is working;  The album name  = “Justice”, Artist = “Justin Beiber”
DROP TRIGGER IF EXISTS artist_update_after_insert_album;
DELIMITER //

CREATE TRIGGER artist_update_after_insert_album
AFTER INSERT ON albums
FOR EACH ROW
BEGIN
    DECLARE artist_id_val INT;
    
    -- Get the artist ID for the inserted album
    SELECT aid INTO artist_id_val
    FROM artists
    WHERE artist_name = NEW.artist;
    
    -- Update the num_released field for the artist
    UPDATE artists
    SET num_released = num_released + 1
	WHERE artist_name = NEW.artist;
END;
//
DELIMITER ;

-- test
INSERT INTO albums (album_name, artist) VALUES ('Justice', 'Justin Beiber');
SELECT * FROM albums WHERE artist = 'Justin Beiber';

INSERT INTO albums (album_name, artist) VALUES ('Justice', 'Justin');
SELECT * FROM albums WHERE artist = 'Justin';





-- (12)
-- Write a trigger that updates the artist table when an album is deleted from the album table. The trigger will need to assign the correct value to the   artist.num_released field for the corresponding artist. Name the trigger artist_update_after_delete_artist. Delete  an album  from the album table to verify your trigger is working;  The album name  = “Justice”, Artist = “Justin Beiber”
DROP TRIGGER IF EXISTS artist_update_after_delete_album;

DELIMITER //
CREATE TRIGGER artist_update_after_delete_album
AFTER DELETE ON albums
FOR EACH ROW
BEGIN
    DECLARE artist_id_val INT;
    
    -- Get the artist ID for the deleted album
    SELECT aid INTO artist_id_val
    FROM artists
    WHERE artist_name = OLD.artist;
    
    -- Update the num_released field for the artist
    UPDATE artists
    SET num_released = num_released - 1
    WHERE artist_name = OLD.artist;
END;
//
DELIMITER ;

-- test
DELETE FROM albums WHERE album_name = 'Justice' AND artist = 'Justin Beiber';
SELECT * FROM artists WHERE artist_name = 'Justin Beiber';
SELECT * FROM albums;
SELECT * FROM artists;
  



-- (13)
-- Create and execute a prepared statement from the SQL workbench that calls the function more_followers(artist1,artist2). Use 2 user session variables to pass the two arguments to the function. Pass the values “Vanilla” and “The Turtles” as the author values.
SET @artist1 := 'Vanilla';
SET @artist2 := 'The Turtles';
SET @sql := 'SELECT more_followers(?, ?) INTO @result';

PREPARE stmt FROM @sql;
EXECUTE stmt USING @artist1, @artist2;
SELECT @result AS followers_comparison_result;
DEALLOCATE PREPARE stmt;


-- (14)
-- Create and execute a prepared statement from the SQL workbench that calls the function num_songs_with_genre(genre_p) . Use a user session variable to pass the genre name to the function. Pass the value  “Rock” as the length
SET @genre_p := 'Rock';

PREPARE stmt FROM 'SELECT num_songs_with_genre(?) INTO @num_songs';
EXECUTE stmt USING @genre_p;
SELECT @num_songs;
DEALLOCATE PREPARE stmt;

    
*/
	
	

	



 
    
    
    
    
    




    
    
    
    
    
    
    
	
    

    
	


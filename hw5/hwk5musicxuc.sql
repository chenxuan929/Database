USE musicxuc;

/*
-- (1)
SELECT artists.artist_name, record_label.label_name
FROM artists
JOIN record_label ON artists.record_label_id = record_label.rid;
*/

/*
-- (2)
SELECT record_label.label_name, COUNT(artists.aid) AS signed_artists
FROM record_label
LEFT JOIN artists ON record_label.rid = artists.record_label_id
GROUP BY record_label.label_name
ORDER BY signed_artists DESC;
*/

/*
-- (3)
SELECT COUNT(user_id) AS num_followers
FROM user_follows_artist;
*/

/*
-- (4)
DROP TABLE IF EXISTS `rock_songs`;

CREATE TABLE rock_songs AS
SELECT songs.song_name, 'Rock' AS genre_name
FROM songs
WHERE songs.genre_id IN (SELECT gid FROM genres WHERE genre_name = 'Rock');
*/

/*
-- (5)
SELECT 
	songs.sid AS song_id,
	songs.song_name AS song_title,
	albums.album_name AS album_name,
	artists.artist_name AS artist_name,
	record_label.label_name AS recording_label
FROM songs
INNER JOIN artist_performs_song ON songs.sid = artist_performs_song.sid
INNER JOIN artists ON artist_performs_song.aid = artists.aid
INNER JOIN albums ON songs.album_id = albums.alid
INNER JOIN record_label ON artists.record_label_id = record_label.rid
*/


/* 
-- (6)
SELECT 
	songs.song_name AS song_title,
    albums.album_name AS album_name,
    (
        SELECT record_label.label_name
        FROM artists AS album_artist
        INNER JOIN albums ON albums.artist = album_artist.artist_name
        INNER JOIN record_label ON album_artist.record_label_id = record_label.rid
        WHERE albums.alid = songs.album_id
        LIMIT 1
    ) AS recording_label,
    GROUP_CONCAT(artists.artist_name ORDER BY artists.artist_name ASC) AS perform_artist
From songs
INNER JOIN artist_performs_song ON songs.sid = artist_performs_song.sid
INNER JOIN artists ON artist_performs_song.aid = artists.aid
INNER JOIN albums ON songs.album_id = albums.alid
INNER JOIN record_label ON artists.record_label_id = record_label.rid
GROUP BY song_title, album_name, recording_label
ORDER BY song_title ASC;
*/

/* 
-- (6) Another approach
SELECT
    s.song_name AS song_title,
    a.album_name,
    rl.label_name AS recording_label,
    GROUP_CONCAT(art.artist_name ORDER BY art.artist_name ASC) AS artists_performed
FROM songs s
JOIN albums a ON s.album_id = a.alid
JOIN artist_performs_song aps ON s.sid = aps.sid
JOIN artists art ON aps.aid = art.aid
JOIN artists ar ON a.artist = ar.artist_name
JOIN record_label rl ON ar.record_label_id = rl.rid
GROUP BY s.song_name, a.album_name, rl.label_name
ORDER BY s.song_name ASC;
*/


/*
-- (7)
SELECT
	songs.song_name AS song_name
FROM songs
JOIN artist_performs_song ON songs.sid = artist_performs_song.sid
GROUP BY songs.song_name
ORDER BY COUNT(artist_performs_song.aid) DESC
LIMIT 1;
*/

/*
-- (8)
SELECT 
	artists.artist_name,
    COUNT(user_follows_artist.user_id) AS num_followers
FROM artists
LEFT JOIN user_follows_artist ON artists.aid = user_follows_artist.aid
GROUP BY artists.artist_name
ORDER BY num_followers DESC;
*/

/*
-- (9)
SELECT
	record_label.label_name,
    COUNT(albums.alid) AS num_albums
FROM record_label
LEFT JOIN artists ON artists.record_label_id = record_label.rid
LEFT JOIN albums ON artists.artist_name = albums.artist
GROUP BY record_label.label_name
ORDER BY num_albums DESC;
*/

/*
-- (10)
SELECT 
	genres.genre_name,
    COUNT(songs.sid) AS num_songs
FROM genres
LEFT JOIN songs ON songs.genre_id = genres.gid
GROUP BY genres.genre_name
ORDER BY num_songs DESC;
*/

/*
-- (11)
SELECT
	s.song_name AS song_title,
    a.album_name AS album_name,
    ar.artist_name AS producing_artist,
    g.genre_name AS genre,
    m.mood_name AS mood,
    COUNT(ufa.user_id) AS num_followers
FROM songs s
JOIN albums a ON s.album_id = a.alid
JOIN artists ar ON a.artist = ar.artist_name
JOIN genres g ON s.genre_id = g.gid
JOIN moods m ON s.mood_id = m.mid
LEFT JOIN user_follows_artist ufa ON ar.aid = ufa.aid
GROUP BY album_name, song_title, producing_artist, genre, mood;
*/


/*
-- (12)
SELECT artist_name FROM artists
WHERE NOT EXISTS
	(SELECT DISTINCT user_id FROM user WHERE user_id NOT IN
		(SELECT user_id FROM user_follows_artist WHERE user_follows_artist.aid = artists.aid)
	);
*/

/*
-- (13)
SELECT u.user_id, u.user_name, u.user_email FROM user u
WHERE NOT EXISTS (
	SELECT a.aid
    FROM artists a
    WHERE NOT EXISTS (
		SELECT ufa.aid
        FROM user_follows_artist ufa
        WHERE ufa.aid = a.aid AND ufa.user_id = u.user_id
	)
);
*/

/*
-- (14)
SELECT albums.* FROM albums
JOIN artists ON albums.artist = artists.artist_name
JOIN record_label ON artists.record_label_id = record_label.rid
WHERE record_label.label_name LIKE '%Music%';
*/


/*
-- (15)
SELECT
    u1.user_name AS user1,
    u2.user_name AS user2,
    a.artist_name
FROM
    user_follows_artist uf1
JOIN user_follows_artist uf2 ON uf1.aid = uf2.aid AND uf1.user_id < uf2.user_id
JOIN user u1 ON uf1.user_id = u1.user_id
JOIN user u2 ON uf2.user_id = u2.user_id
JOIN artists a ON uf1.aid = a.aid
ORDER BY a.artist_name ASC;
*/

/*
-- (16)
SELECT artist_name, COUNT(DISTINCT albums.alid) AS num_albums FROM artists
JOIN albums ON artists.artist_name = albums.artist
GROUP BY artists.artist_name
ORDER BY num_albums DESC;
*/

/*
-- (17)
SELECT MAX(song_count) AS most_songs
FROM (
    SELECT
        artists.artist_name,
        COUNT(DISTINCT songs.sid) AS song_count
    FROM artists
    JOIN albums ON artists.artist_name = albums.artist
    JOIN songs ON albums.alid = songs.album_id
    GROUP BY artists.artist_name
) AS artist_song_counts;
*/

/*
-- (18)
SELECT artist_name, num_songs
FROM (
	SELECT artist_name, COUNT(DISTINCT aps.sid) AS num_songs 
    FROM artists
    JOIN artist_performs_song aps ON artists.aid = aps.aid
    GROUP BY artists.artist_name
) AS most_song_artist ORDER BY num_songs DESC LIMIT 1;
*/


/*
-- (19)
SELECT 
record_label.label_name,
COUNT(DISTINCT songs.sid) AS song_released FROM record_label
JOIN artists ON record_label.rid = artists.record_label_id
JOIN albums ON albums.artist = artists.artist_name
JOIN songs ON songs.album_id = albums.alid
GROUP BY record_label.label_name;
*/



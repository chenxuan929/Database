
-- (4)
SELECT DATE(incident_date) AS calendar_day, COUNT(*) AS num_crimes
FROM incidents
GROUP BY calendar_day
ORDER BY calendar_day ASC;



-- (5)
SELECT street, COUNT(*) AS num_crimes
FROM incidents
GROUP BY street
ORDER BY num_crimes DESC
LIMIT 1;



-- (6)
SELECT DATE(i.incident_date) AS calendar_day, COUNT(*) AS num_crimes
FROM incidents i
JOIN districts d ON i.district = d.d_code
JOIN neighborhoods n ON d.d_code = n.n_code
WHERE n.n_name = "North End"
GROUP BY calendar_day
ORDER BY num_crimes DESC
LIMIT 1;



/*
-- (7)
SELECT COUNT(*) AS num_crimes
FROM incidents i
JOIN neighborhoods n ON i.district = n.n_code
WHERE n.n_name = "Hyde Park";
*/

/*
-- (8)
SELECT i.offense_code AS crime_code, i.incident_date, d.d_name AS district
FROM incidents i
JOIN districts d ON i.district = d.d_code
JOIN offense_codes o ON i.offense_code = o.o_code
WHERE o.description LIKE '%RAPE%'
ORDER BY i.incident_date, d.d_name;
*/


-- (9)
SELECT o.o_code AS crime_code, o.description,
COALESCE(COUNT(i.incident_number), 0) AS num_occurrences
FROM offense_codes o
LEFT JOIN incidents i ON o.o_code = i.offense_code
GROUP BY o.o_code
ORDER BY num_occurrences DESC;



-- (10)
SELECT d.d_code, d.d_name, COUNT(i.incident_number) AS num_crimes
FROM districts d
JOIN incidents i ON d.d_code = i.district
GROUP BY d.d_code, d_name
ORDER BY num_crimes DESC;



-- (11)
SELECT o.o_code, COALESCE(COUNT(i.district), 0) AS num_districts
FROM offense_codes o
LEFT JOIN incidents i ON o.o_code = i.offense_code
GROUP BY o.o_code
ORDER BY num_districts;



-- (12)
SELECT i.incident_number, d.d_name, o.description, i.incident_date
FROM incidents i
JOIN districts d ON i.district = d.d_code
JOIN offense_codes o ON i.offense_code = o.o_code
WHERE i.incident_date >= '2022-12-25' AND i.incident_date <= '2022-12-28'
ORDER BY incident_date ASC;



-- (13)
WITH rank_district AS (
	SELECT d.d_name, o.description,
			COUNT(i.incident_number) AS num_incidents,
			ROW_NUMBER() OVER (PARTITION BY d.d_name ORDER BY COUNT(i.incident_number) DESC) AS rn
	FROM incidents i
	JOIN districts d ON i.district = d.d_code
	JOIN offense_codes o ON i.offense_code = o.o_code
	GROUP BY d.d_name, o.description
)
SELECT d_name, description, num_incidents
FROM rank_district
WHERE rn = 1;




-- (14)
WITH crime_districts AS (
	SELECT d.d_name AS district_name,
		o.description AS crime_description,
        COUNT(i.incident_number) AS num_crime
	FROM incidents i
    JOIN districts d ON i.district = d.d_code
    JOIN offense_codes o ON i.offense_code = o.o_code
    GROUP BY o.description, d.d_name
)
SELECT crime_description, SUM(num_crime) AS num_crimes, GROUP_CONCAT(district_name) AS districts
FROM crime_districts
GROUP BY crime_description
ORDER BY num_crimes DESC;



-- (15)
SELECT COUNT(i.incident_number) AS num_crimes, i.i_hour
FROM incidents i
WHERE i_hour >= 18 AND i_hour <= 23
GROUP BY i_hour
ORDER BY i_hour ASC;



-- (16)
SELECT i.i_day_of_week, COUNT(i.incident_number) AS num_crimes
FROM incidents i
GROUP BY i.i_day_of_week
ORDER BY FIELD(i.i_day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');



-- (17)
SELECT AVG(num_crimes) AS average_crimes
FROM (
	SELECT DATE(i.incident_date) AS calendar_day,
    COUNT(*) AS num_crimes
    FROM incidents i
    GROUP BY calendar_day
) AS subquery_alias;


-- (18)
SELECT o.o_code, o.description
FROM offense_codes o
WHERE o.o_code NOT IN (
	SELECT i.offense_code
    FROM incidents i
);









/*
CA Hate Crime Data Exploration
We are going to explore data about crime in California from 2015 - 2021 
Skills used: UPDATE, JOIN, GROUPED BY, CTE
*/

SELECT * 
FROM hate_crime_CA..victims
ORDER BY 3,4

SELECT * 
FROM hate_crime_CA..suspects
ORDER BY 3,4

-- Select Data that we are going to be starting with (victims)

SELECT year, county, total_victims, crime, location, total_victims_adult, total_victims_juvenile
FROM hate_crime_CA..victims
WHERE total_victims_adult is not null
ORDER BY 1,2

-- Changed the county code to coumnty name
-- I changed the data type from float to varchar on SQL Server 
-- before making the updates

UPDATE victims
SET county = CASE
			WHEN county = '1' THEN 'Alameda'
			WHEN county = '2' THEN 'Alpine'
			WHEN county = '3' THEN 'Amador'
			WHEN county = '4' THEN 'Butte'
			WHEN county = '5' THEN 'Calaveras'
			WHEN county = '6' THEN 'Colusa'
			WHEN county = '7' THEN 'Contra Costa'
			WHEN county = '8' THEN 'Del Norte'
			WHEN county = '9' THEN 'El Dorado'
			WHEN county = '10' THEN 'Fresno'
			WHEN county = '11' THEN 'Glenn'
			WHEN county = '12' THEN 'Humboldt'
			WHEN county = '13' THEN 'Imperial'
			WHEN county = '14' THEN 'Inyo'
			WHEN county = '15' THEN 'Kern'
			WHEN county = '16' THEN 'Kings'
			WHEN county = '17' THEN 'Lake'
			WHEN county = '18' THEN 'Lassen'
			WHEN county = '19' THEN 'Los Angeles'
			WHEN county = '20' THEN 'Madera'
			WHEN county = '21' THEN 'Marin'
			WHEN county = '22' THEN 'Mariposa'
			WHEN county = '23' THEN 'Mendocino'
			WHEN county = '24' THEN 'Merced'
			WHEN county = '25' THEN 'Modoc'
			WHEN county = '26' THEN 'Mono'
			WHEN county = '27' THEN 'Monterey'
			WHEN county = '28' THEN 'Napa'
			WHEN county = '29' THEN 'Nevada'
			WHEN county = '30' THEN 'Orange'
			WHEN county = '31' THEN 'Placer'
			WHEN county = '32' THEN 'Plumas'
			WHEN county = '33' THEN 'Riverside'
			WHEN county = '34' THEN 'Sacramento'
			WHEN county = '35' THEN 'San Benito'
			WHEN county = '36' THEN 'San Bernardino'
			WHEN county = '37' THEN 'San Diego'
			WHEN county = '38' THEN 'San Francisco'
			WHEN county = '39' THEN 'San Joaquin'
			WHEN county = '40' THEN 'San Luis Obispo'
			WHEN county = '41' THEN 'San Mateo'
			WHEN county = '42' THEN 'Santa Barbara'
			WHEN county = '43' THEN 'Santa Clara'
			WHEN county = '44' THEN 'Santa Cruz'
			WHEN county = '45' THEN 'Shasta'
			WHEN county = '46' THEN 'Sierra'
			WHEN county = '47' THEN 'Siskiyou'
			WHEN county = '48' THEN 'Solano'
			WHEN county = '49' THEN 'Sonoma'
			WHEN county = '50' THEN 'Stanislaus'
			WHEN county = '51' THEN 'Sutter'
			WHEN county = '52' THEN 'Tehama'
			WHEN county = '53' THEN 'Trinity'
			WHEN county = '54' THEN 'Tulare'
			WHEN county = '55' THEN 'Tuolumne'
			WHEN county = '56' THEN 'Ventura'
			WHEN county = '57' THEN 'Yolo'
			WHEN county = '58' THEN 'Yuba'
			ELSE 'uknown'
			END
WHERE county IN (1, 2, 3, 4 ,5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58)



-- Counties with the highest hate crimes 
SELECT county, SUM(total_victims) AS TotalVictims
FROM victims
GROUP BY county
HAVING SUM(total_victims) > 1
ORDER BY 2 desc

-- Total victims grouped by crime
SELECT crime, SUM(total_victims) AS TotalVictims
FROM victims
GROUP BY crime
HAVING SUM(total_victims) > 1
ORDER BY 2 desc


--Total Victims grouped by location
SELECT location, SUM(total_victims) AS TotalVictims
FROM victims
GROUP BY location
HAVING SUM(total_victims) > 1
ORDER BY 2 desc


-- Total Victims grouped by motive crime
-- using CTE and JOINS
-- I used a HAVE clause in order to analyze the crime motives by year
WITH CTE_weapons AS
  (
	SELECT s.bias_subtype, CASE WHEN s.weapon IS NULL THEN 'No weapon' ELSE s.weapon END AS Weapon, s.total_suspects_adult, s.total_suspects_juvenile, v.total_victims, v.year
	FROM victims v JOIN suspects s
	ON v.RecordId = s.RecordId
  )
SELECT bias_subtype AS CrimeMotive, SUM(total_victims) AS total_victims, year
FROM CTE_weapons
GROUP BY bias_subtype, year
HAVING year = 2020
ORDER BY 2 desc

-- Viewing the first 5 rows of each dataset
SELECT *
FROM projects.dc_data_1
LIMIT 5;

SELECT *
FROM projects.dc_data_2
LIMIT 5;

SELECT *
FROM projects.marvel_wikia_data
LIMIT 5;

-- Creating a table with data combined from both the comics (DC and Marvel)
CREATE TABLE comics_combined AS
SELECT projects.dc_data_1.name, id, align, eye, hair, sex, gsm, alive, appearances, year, 'dc' AS comic
FROM projects.dc_data_2
INNER JOIN projects.dc_data_1
ON projects.dc_data_1.name = projects.dc_data_2.name
UNION ALL
SELECT name, id, align, eye, hair, sex, gsm, alive, appearances, year, 'marvel'
FROM marvel_wikia_data;

-- Querying the combined table to verify the data
SELECT *
FROM projects.comics_combined
ORDER BY comic DESC;

-- Checking the number of rows in the combined table
SELECT COUNT(*) AS num_rows
FROM projects.comics_combined;

-- Checking the number of columns in the combined table
SELECT COUNT(*) AS num_columns
FROM information_schema.columns
WHERE table_name = 'comics_combined';

-- Identify duplicate character names
SELECT name, COUNT(*) AS count
FROM projects.comics_combined
GROUP BY name
HAVING COUNT(*) > 1;

-- Checking for missing values
SELECT
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS missing_name,
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS missing_id,
    SUM(CASE WHEN align IS NULL THEN 1 ELSE 0 END) AS missing_align,
    SUM(CASE WHEN eye IS NULL THEN 1 ELSE 0 END) AS missing_eye,
    SUM(CASE WHEN hair IS NULL THEN 1 ELSE 0 END) AS missing_hair,
    SUM(CASE WHEN sex IS NULL THEN 1 ELSE 0 END) AS missing_sex,
    SUM(CASE WHEN gsm IS NULL THEN 1 ELSE 0 END) AS missing_gsm,
    SUM(CASE WHEN alive IS NULL THEN 1 ELSE 0 END) AS missing_alive,
    SUM(CASE WHEN appearances IS NULL THEN 1 ELSE 0 END) AS missing_appearances,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS missing_year,
    SUM(CASE WHEN comic IS NULL THEN 1 ELSE 0 END) AS missing_comic
FROM projects.comics_combined;

-- Checking for empty values
SELECT
    SUM(CASE WHEN name = '' THEN 1 ELSE 0 END) AS empty_name,
    SUM(CASE WHEN id = '' THEN 1 ELSE 0 END) AS empty_id,
    SUM(CASE WHEN align = '' THEN 1 ELSE 0 END) AS empty_align,
    SUM(CASE WHEN eye = '' THEN 1 ELSE 0 END) AS empty_eye,
    SUM(CASE WHEN hair = '' THEN 1 ELSE 0 END) AS empty_hair,
    SUM(CASE WHEN sex = '' THEN 1 ELSE 0 END) AS empty_sex,
    SUM(CASE WHEN gsm = '' THEN 1 ELSE 0 END) AS empty_gsm,
    SUM(CASE WHEN alive = '' THEN 1 ELSE 0 END) AS empty_alive,
    SUM(CASE WHEN appearances = '' THEN 1 ELSE 0 END) AS empty_appearances,
    SUM(CASE WHEN year = '' THEN 1 ELSE 0 END) AS empty_year,
    SUM(CASE WHEN comic = '' THEN 1 ELSE 0 END) AS empty_comic
FROM projects.comics_combined;

-- Replacing empty values with 'NA' where applicable
UPDATE projects.comics_combined SET id = 'NA' WHERE id = '';
UPDATE projects.comics_combined SET align = 'NA' WHERE align = '';
UPDATE projects.comics_combined SET align = 'NA' WHERE align = 'N/A';
UPDATE projects.comics_combined SET eye = 'NA' WHERE eye = '';
UPDATE projects.comics_combined SET hair = 'NA' WHERE hair = '';
UPDATE projects.comics_combined SET sex = 'NA' WHERE sex = '';
UPDATE projects.comics_combined SET gsm = 'NA' WHERE gsm = '';
UPDATE projects.comics_combined SET alive = 'NA' WHERE alive = '';

-- Basic insights

-- Identifying the first character introduced by Marvel and DC
SELECT *
FROM projects.comics_combined
WHERE comic = 'marvel'
ORDER BY year 
LIMIT 1;

SELECT *
FROM projects.comics_combined
WHERE comic = 'dc'
ORDER BY year 
LIMIT 1;

-- Total character count in Marvel and DC
SELECT COUNT(*) AS num_characters
FROM projects.comics_combined
WHERE comic = 'marvel';

SELECT COUNT(*) AS num_characters
FROM projects.comics_combined
WHERE comic = 'dc';

-- Top characters with the most appearances
SELECT name, sex, appearances 
FROM projects.comics_combined
WHERE comic = 'marvel'
ORDER BY appearances DESC
LIMIT 5;

-- Top 5 characters with the most appearances in Marvel and DC
SELECT name, sex, appearances 
FROM projects.comics_combined
WHERE comic = 'dc'
ORDER BY appearances DESC
LIMIT 5;

-- Most frequent eye color
SELECT eye, COUNT(*) AS count
FROM projects.comics_combined
WHERE comic = 'marvel'
GROUP BY eye
ORDER BY count DESC
LIMIT 5;

SELECT eye, COUNT(*) AS count
FROM projects.comics_combined
WHERE comic = 'dc'
GROUP BY eye
ORDER BY count DESC
LIMIT 5;

-- Most frequent hair color
SELECT hair, COUNT(*) AS count
FROM projects.comics_combined
WHERE comic = 'marvel'
GROUP BY hair
ORDER BY count DESC
LIMIT 5;

SELECT hair, COUNT(*) AS count
FROM projects.comics_combined
WHERE comic = 'dc'
GROUP BY hair
ORDER BY count DESC
LIMIT 5;

-- Average appearances by alignment across both comics
SELECT align, FORMAT(AVG(appearances), 2) AS avg_appearance
FROM projects.comics_combined
GROUP BY align
ORDER BY AVG(appearances) DESC;

-- Gender analysis

-- Total count and proportion of characters by sex
SELECT sex, COUNT(*) AS total, 
FORMAT(COUNT(*) / (SELECT COUNT(*) FROM projects.comics_combined) * 100, 2) AS percentage
FROM projects.comics_combined
GROUP BY sex
ORDER BY COUNT(*) / (SELECT COUNT(*) FROM projects.comics_combined) * 100 DESC;

-- Character representation by alignment
SELECT sex, align, COUNT(*) AS count
FROM projects.comics_combined
WHERE sex IN ('male characters', 'female characters') 
GROUP BY sex, align
ORDER BY sex, align;

-- Pivoting the above result
SELECT align,
COUNT(CASE WHEN sex = 'female characters' THEN 1 ELSE NULL END) AS female,
COUNT(CASE WHEN sex = 'male characters' THEN 1 ELSE NULL END) AS male
FROM projects.comics_combined
GROUP BY align;

-- Survival analysis by gender
SELECT sex, alive, COUNT(*) AS num_characters
FROM projects.comics_combined
WHERE sex IN ('male characters', 'female characters') AND alive != 'NA'  
GROUP BY sex, alive;

-- Pivoting the above result
SELECT sex, 
SUM(CASE WHEN alive = 'living characters' THEN 1 ELSE 0 END) AS living_characters,
SUM(CASE WHEN alive = 'deceased characters' THEN 1 ELSE 0 END) AS deceased_characters,
FORMAT(SUM(CASE WHEN alive = 'living characters' THEN 1 ELSE 0 END) /
SUM(CASE WHEN alive = 'deceased characters' THEN 1 ELSE 0 END), 1) AS ratio
FROM projects.comics_combined
WHERE sex IN ('male characters', 'female characters')  
GROUP BY sex;

-- Representation of characters over different years by gender
SELECT MIN(year) AS min_year, MAX(year) AS max_year
FROM projects.comics_combined;

-- Count of male and female characters by year
SELECT year,
COUNT(CASE WHEN sex = 'female characters' THEN 1 ELSE NULL END) AS female,
COUNT(CASE WHEN sex = 'male characters' THEN 1 ELSE NULL END) AS male
FROM projects.comics_combined
GROUP BY year
ORDER BY year;

-- Gender representation over different decades
SELECT sex,
    SUM(CASE WHEN year BETWEEN 1935 AND 1944 THEN 1 ELSE 0 END) AS '1935 - 1944',
    SUM(CASE WHEN year BETWEEN 1945 AND 1954 THEN 1 ELSE 0 END) AS '1945 - 1954',
    SUM(CASE WHEN year BETWEEN 1955 AND 1964 THEN 1 ELSE 0 END) AS '1955 - 1964',
    SUM(CASE WHEN year BETWEEN 1965 AND 1974 THEN 1 ELSE 0 END) AS '1965 - 1974',
    SUM(CASE WHEN year BETWEEN 1975 AND 1984 THEN 1 ELSE 0 END) AS '1975 - 1984',
    SUM(CASE WHEN year BETWEEN 1985 AND 1994 THEN 1 ELSE 0 END) AS '1985 - 1994',
    SUM(CASE WHEN year BETWEEN 1995 AND 2004 THEN 1 ELSE 0 END) AS '1995 - 2004',
    SUM(CASE WHEN year BETWEEN 2005 AND 2013 THEN 1 ELSE 0 END) AS '2005 - 2013'
FROM projects.comics_combined
WHERE sex IN ('male characters', 'female characters')
GROUP BY sex;



-- Creating a CTE (Common Table Expression) to segment character introduction years into predefined intervals (decades).
-- For each segment, the CTE calculates the total count of male and female characters introduced during that period.
WITH CTE AS
(
SELECT 
CASE
	WHEN year BETWEEN 1935 AND 1944 THEN '1935 - 1944'
	WHEN year BETWEEN 1945 AND 1954 THEN '1945 - 1954'
    WHEN year BETWEEN 1955 AND 1964 THEN '1955 - 1964'
    WHEN year BETWEEN 1965 AND 1974 THEN '1965 - 1974'
    WHEN year BETWEEN 1975 AND 1984 THEN '1975 - 1984'
    WHEN year BETWEEN 1985 AND 1994 THEN '1985 - 1994'
    WHEN year BETWEEN 1995 AND 2004 THEN '1995 - 2004'
    WHEN year BETWEEN 2005 AND 2013 THEN '2005 - 2013'
    ELSE 'NA'
END AS Year_Segment, 
SUM(CASE WHEN Sex = 'male characters' THEN 1 ELSE 0 END) AS 'Male', 
SUM(CASE WHEN Sex = 'female characters' THEN 1 ELSE 0 END) AS 'Female'
FROM projects.comics_combined
WHERE sex IN ('male characters', 'female characters')
GROUP BY Year_Segment
ORDER BY Year_Segment
)
-- Using the CTE results to calculate a rolling sum of male and female characters across the defined segments.
SELECT Year_Segment, 
SUM(Male) OVER(ORDER BY Year_Segment) AS Rolling_Male,
SUM(Female) OVER(ORDER BY Year_Segment) AS Rolling_Female
FROM CTE;
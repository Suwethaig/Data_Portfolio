-- Analysis 1

SELECT * 
FROM his_ave_rent
LIMIT 5;

-- Determine the rent increase and percentage increase over the last 15 years
SELECT 
    Year,
    Total_Avg_Rent AS Avg_Rent,
    Total_Avg_Rent - LAG(Total_Avg_Rent) OVER (ORDER BY Year) AS Annual_Rent_Change,  -- Calculate rent increase
    FORMAT((Total_Avg_Rent - LAG(Total_Avg_Rent) OVER (ORDER BY Year)) / LAG(Total_Avg_Rent) OVER (ORDER BY Year) * 100, 2) AS Annual_Rent_Growth_Percentage  -- Calculate percentage increase
FROM 
    his_ave_rent
WHERE Year > 2008
ORDER BY Year ;

-- Analysis 2

-- Retrieve all data from combined_wage_data table
SELECT *
FROM combined_wage_data;

-- Replace 'N/A' in Median_Wage column with NULL
UPDATE combined_wage_data
SET Median_Wage = NULLIF(Median_Wage, 'N/A');

-- Create a temporary table to calculate monthly wages and associate it with rental data
DROP TABLE IF EXISTS temp_rent_income;
CREATE TEMPORARY TABLE temp_rent_income AS
SELECT 
    his_ave_rent.Year, 
    Minimum_Wage * 40 * 4 AS Min_Wage_Monthly,  -- Calculate monthly minimum wage
    ROUND(Median_Wage * 40 * 4, 0) AS Med_Wage_Monthly,  -- Calculate monthly median wage
    Bachelor AS Bach_Rent, 
    1_Bedroom AS 1B_Rent, 
    2_Bedroom AS 2B_Rent, 
    3_Plus_Bedroom AS 3P_Rent, 
    Total_Avg_Rent AS Avg_Rent
FROM combined_wage_data 
JOIN his_ave_rent 
ON combined_wage_data.Year = his_ave_rent.Year
WHERE combined_wage_data.Year > 2018;

-- Retrieve all data from temp_rent_income to check the output
SELECT * 
FROM temp_rent_income;

-- Calculate rent-to-income ratio for minimum and median wage
SELECT 
    Year, 
    FORMAT((Avg_Rent / Min_Wage_Monthly) * 100, 2) AS Min_Rent_To_Income, 
    FORMAT((Avg_Rent / Med_Wage_Monthly) * 100, 2) AS Med_Rent_To_Income
FROM temp_rent_income;

-- Calculate rent-to-income ratio for different bedroom types based on minimum wage
SELECT 
    Year, 
    FORMAT((Bach_Rent / Min_Wage_Monthly) * 100, 2) AS Bach_Rent_To_Income, 
    FORMAT((1B_Rent / Min_Wage_Monthly) * 100, 2) AS 1B_Rent_To_Income, 
    FORMAT((2B_Rent / Min_Wage_Monthly) * 100, 2) AS 2B_Rent_To_Income, 
    FORMAT((3P_Rent / Min_Wage_Monthly) * 100, 2) AS 3P_Rent_To_Income
FROM temp_rent_income;

-- Analysis 3

-- Retrieving the average rent data across zones to check its contents
SELECT *
FROM zone_avg_rent;

-- Determining the minimum, maximum and range of avg rent value
SELECT MIN(Total_Avg_Rent) AS Min_Rent, MAX(Total_Avg_Rent) AS Max_Rent, 
MAX(Total_Avg_Rent) - MIN(Total_Avg_Rent) AS Rent_Range
FROM zone_avg_rent;

-- Creating a temporary table to classify zones into rent levels
DROP TABLE IF EXISTS temp_zone_classifier;
CREATE TEMPORARY TABLE temp_zone_classifier AS(
    SELECT zar.Zone, zar.Total_Avg_Rent,
        CASE
            WHEN zar.Total_Avg_Rent < 1650 THEN 'Low'  -- Classify as 'Low' rent
            WHEN zar.Total_Avg_Rent BETWEEN 1650 AND 2000 THEN 'Medium'  -- Classify as 'Medium' rent
            WHEN zar.Total_Avg_Rent > 2000 THEN 'High'  -- Classify as 'High' rent
        END AS Rent_Level, 
        zu.Total_Units  -- Total units for each zone
    FROM 
        zone_avg_rent zar
    JOIN 
        zone_units zu ON zar.Zone = zu.zone  -- Join on zone
);

-- Retrieving the table to check its contents
SELECT *
FROM temp_zone_classifier;

-- Select rent levels with their count and average total units
SELECT 
    Rent_Level, 
    COUNT(Rent_Level) AS Level_Count,  -- Count of zones in each rent level
    FORMAT(AVG(Total_Units), 2) AS Avg_Units  -- Average total units in each rent level
FROM 
    temp_zone_classifier
GROUP BY 
    Rent_Level;  -- Group by rent level to aggregate results
    
-- Retrieving the zones with 'Medium' rent level from the temporary table
SELECT *
FROM temp_zone_classifier
WHERE Rent_Level = 'Medium'
ORDER BY Total_Units;

-- Select rent levels with their count and average total units
SELECT 
    Rent_Level, 
    COUNT(Rent_Level) AS Level_Count,  -- Count of zones in each rent level
    FORMAT(AVG(Total_Units), 2) AS Avg_Units  -- Average total units in each rent level
FROM 
    temp_zone_classifier
WHERE Total_Units < 10000
GROUP BY 
    Rent_Level;  -- Group by rent level to aggregate results

-- Analysis 4

-- Retrieve rent percentages for different bedroom types as a percentage of median wage for the year 2023
SELECT 
    cwd.Year, 
    FORMAT(har.Bachelor / (cwd.Median_Wage * 160) * 100, 2) AS Bach_Rent_Percent,  -- Percentage of median wage spent on Bachelor rent
    FORMAT(har.1_Bedroom / (cwd.Median_Wage * 160) * 100, 2) AS 1B_Rent_Percent,    -- Percentage of median wage spent on 1 Bedroom rent
    FORMAT(har.2_Bedroom / (cwd.Median_Wage * 160) * 100, 2) AS 2B_Rent_Percent,    -- Percentage of median wage spent on 2 Bedroom rent
    FORMAT(har.3_Plus_Bedroom / (cwd.Median_Wage * 160) * 100, 2) AS 3P_Rent_Percent  -- Percentage of median wage spent on 3+ Bedroom rent
FROM 
    his_ave_rent har
JOIN 
    combined_wage_data cwd
ON 
    har.Year = cwd.Year
WHERE 
    cwd.Year = 2023;  -- Filter data for the year 2023;

-- Analysis 5
    
-- Retrieving the three zones with the lowest average rent
SELECT 
    Zone, 
    Total_Avg_Rent
FROM 
    zone_avg_rent
ORDER BY 
    Total_Avg_Rent ASC  -- Order by rent in ascending order
LIMIT 3;  -- Limit the result to the 3 zones with the lowest rent

-- Additional analysis - Determining Median for Medium zones

-- Getting the Median number of units for Medium rent level zones
SET @rowindex := -1;
SELECT
   Rent_Level, FORMAT(AVG(u.Total_Units), 2) as Median 
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           temp_CTE.Total_Units AS Total_Units,
           temp_CTE.Rent_Level AS Rent_Level
    FROM temp_CTE
    WHERE Rent_Level = 'High'
    ORDER BY temp_CTE.Total_Units) AS u
WHERE 
u.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2))
GROUP BY
Rent_Level;
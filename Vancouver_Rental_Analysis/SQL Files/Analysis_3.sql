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
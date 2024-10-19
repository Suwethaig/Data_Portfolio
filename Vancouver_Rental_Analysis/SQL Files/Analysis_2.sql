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
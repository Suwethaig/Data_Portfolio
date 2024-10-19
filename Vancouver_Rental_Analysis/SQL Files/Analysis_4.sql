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
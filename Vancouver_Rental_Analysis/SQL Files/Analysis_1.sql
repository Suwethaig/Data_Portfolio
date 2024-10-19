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
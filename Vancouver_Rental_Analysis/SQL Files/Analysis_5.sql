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
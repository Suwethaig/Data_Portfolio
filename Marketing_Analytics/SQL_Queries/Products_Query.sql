-- Retrieving all data from the products table
SELECT * 
FROM dbo.products;

-- Observation: No NULL/Missing values, 'Category' column is redundant and will be excluded

-- Getiing the minimum and maximum product prices
SELECT 
    MIN(Price) AS MinPrice, 
    MAX(Price) AS MaxPrice
FROM dbo.products;

-- Categorizing products based on price:
-- 'Low' for prices < 50, 'Medium' for 50 to 200, 'High' for prices > 200
SELECT 
    ProductID,
    ProductName,
    Price,
    CASE
        WHEN Price < 50 THEN 'Low'
        WHEN Price BETWEEN 50 AND 200 THEN 'Medium'
        ELSE 'High'
    END AS PriceCategory
FROM dbo.products;

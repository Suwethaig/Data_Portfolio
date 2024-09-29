-- Retrieve all data from the customers table
SELECT *
FROM dbo.customers;

-- Observations:
-- 1. No NULL or missing values
-- 2. Contains GeographyID, so a join with the geography table is needed

-- Retrieve all data from the geography table
SELECT *
FROM dbo.geography;

-- Join customers table with the geography table to add location information
SELECT 
    c.CustomerID,
    c.CustomerName, 
    c.Email, 
    c.Gender, 
    c.Age, 
    g.Country, 
    g.City
FROM dbo.customers c
LEFT JOIN dbo.geography g
    ON c.GeographyID = g.GeographyID;

-- Retrieve the first 10 records from the customer_reviews table to get an understanding of its structure
SELECT TOP 10*
FROM dbo.customer_reviews;

-- Observation: 'ReviewText' contains double spaces, replace them with single spaces
SELECT 
    ReviewID, 
    CustomerID, 
    ProductID, 
    ReviewDate, 
    Rating, 
    REPLACE(ReviewText, '  ', ' ') AS ReviewText
FROM dbo.customer_reviews;

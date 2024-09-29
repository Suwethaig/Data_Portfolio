-- Retrieve all data from the customer_reviews table
SELECT *
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

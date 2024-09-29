-- Retrieve all data from the engagement_data table
SELECT *
FROM dbo.engagement_data;

-- Observations:
-- 1. Standardize 'ContentType' by making it uppercase
-- 2. Format 'EngagementDate' to 'dd-mm-yyyy'
-- 3. Move 'CampaignID' and 'ProductID' earlier in the column order
-- 4. Split 'Views' and 'Clicks' into separate columns from 'ViewsClicksCombined'

SELECT 
    EngagementID,
    ContentID,
    CampaignID,  -- Moved earlier
    ProductID,   -- Moved earlier
    UPPER(ContentType) AS ContentType,  -- Standardize ContentType
    Likes,
    FORMAT(CONVERT(DATE, EngagementDate), 'dd-MM-yyyy') AS EngagementDate,  -- Format date
    LEFT(ViewsClicksCombined, CHARINDEX('-', ViewsClicksCombined) - 1) AS Views,  -- Split Views
    RIGHT(ViewsClicksCombined, LEN(ViewsClicksCombined) - CHARINDEX('-', ViewsClicksCombined)) AS Clicks  -- Split Clicks
FROM dbo.engagement_data;

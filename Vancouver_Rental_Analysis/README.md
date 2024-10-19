
# Vancouver's Rental Reality

### ***You vs. Vancouver rental prices***

As an immigrant to Vancouver, one of the first things I noticed was how much of my income goes toward rent compared to back home. It was surprising to realize that renting in Vancouver demands a significant portion of my earnings, something I wasn't accustomed to. This observation led me to wonder: ***Is this a recent phenomenon, or have Vancouver residents always faced such high rents?*** 

Rather than just speculate, I decided to dive into the data and discover the truth for myself!

![Combined Meme](https://github.com/user-attachments/assets/81e90ab1-dfe1-49cc-ae58-e7de5ce971ac)

## Key Questions for Exploration
***This section outlines the primary questions driving this analysis of Vancouver's rental market***
1. Have rental prices in Vancouver consistently been high, or is this a recent trend?
2. How challenging is it for a minimum wage worker to manage rent payments?
3. Does having a greater number of rental units in a zone lead to lower prices?
4. Is renting a larger home significantly more expensive, or are all housing options hard to afford?
5. Which zone would be the best choice if I want to minimize my rent?

## Hypotheses
***Based on the key questions, the following hypotheses have been formulated to guide the analysis***
1. Rental prices have recently increased and were not historically high.
2. Minimum wage workers allocate a significant portion of their income to rent, leaving them with limited funds for other necessities.
3. An increase in rental units leads to lower rents, as there is enough supply to meet demand.
4. Renting a larger home is more challenging, as increased size is associated with higher rent.
5. Zones farther from downtown tend to have lower rental prices.

## Data Analysis

### <ins> Analysis 1 </ins>
This analysis focuses on determining whether high rental prices in Vancouver are a recent occurrence or if they have been high over the past 15 years. By examining the annual rent change and percentage growth from 2009 to the present, we can identify significant increases in rent.

#### **SQL Query 1.1:**
```sql
-- Determine the rent increase and percentage increase over the years
SELECT 
    Year,
    Total_Avg_Rent AS Avg_Rent,
    Total_Avg_Rent - LAG(Total_Avg_Rent) OVER (ORDER BY Year) AS Annual_Rent_Change,  -- Calculate rent increase
    FORMAT((Total_Avg_Rent - LAG(Total_Avg_Rent) OVER (ORDER BY Year)) / LAG(Total_Avg_Rent) OVER (ORDER BY Year) * 100, 2) AS Annual_Rent_Growth_Percentage  -- Calculate percentage increase
FROM 
    his_ave_rent
WHERE Year > 2008
ORDER BY Year;
```

#### **Output 1.1:**
![Result_1](https://github.com/user-attachments/assets/9a306486-4aeb-4080-9b01-a00d0e6833f4)

### Interpretation
- Vancouver's rental prices have fluctuated over the past 15 years, with periods of both increases and decreases.
- After a sharp decline during COVID-19, rent growth surged from **1.78%** to **8.34%** as lockdowns lifted.
- In 2023, rental prices reached a peak growth rate of **9.13%**.
- This sharp post-pandemic recovery indicates that the high rents currently experienced in Vancouver are part of a recent trend driven by increased housing demand.

### <ins> Analysis 2 </ins>
This analysis delves into the struggles of minimum wage workers in Vancouver when it comes to affording rent. By examining rental prices across various housing types and comparing them to monthly wages, I aim to reveal the percentage of income that these workers must allocate to housing costs. To ensure a relevant understanding of the current landscape, I have concentrated on the last five years of data.

#### **SQL Query 2.1:**
```sql
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
```

#### **Output 2.1:**
![Result_2](https://github.com/user-attachments/assets/e85db987-4742-4407-82b0-c998a207f219)

#### **SQL Query 2.2:**
```sql
-- Calculate rent-to-income ratio for minimum and median wage
SELECT 
    Year, 
    FORMAT((Avg_Rent / Min_Wage_Monthly) * 100, 2) AS Min_Rent_To_Income, 
    FORMAT((Avg_Rent / Med_Wage_Monthly) * 100, 2) AS Med_Rent_To_Income
FROM temp_rent_income;
```

#### **Output 2.2:**
![Result_3](https://github.com/user-attachments/assets/0bbce2af-f5f5-400f-a5f8-fedf569034bf)


#### **SQL Query 2.3:**
```sql
-- Calculate rent-to-income ratio for different bedroom types based on minimum wage
SELECT 
    Year, 
    FORMAT((Bach_Rent / Min_Wage_Monthly) * 100, 2) AS Bach_Rent_To_Income, 
    FORMAT((1B_Rent / Min_Wage_Monthly) * 100, 2) AS 1B_Rent_To_Income, 
    FORMAT((2B_Rent / Min_Wage_Monthly) * 100, 2) AS 2B_Rent_To_Income, 
    FORMAT((3P_Rent / Min_Wage_Monthly) * 100, 2) AS 3P_Rent_To_Income
FROM temp_rent_income;
```

#### **Output 2.3:**
![Result_4](https://github.com/user-attachments/assets/b48e1a46-7a8a-4e1b-8999-cef3a793ec45)

### Interpretation
- On average, minimum wage workers in Vancouver spend about **65%** of their income on rent, significantly straining their finances.
- The situation is only slightly better for median wage workers, who allocate around **35%** of their income to rent.
- A deeper analysis comparing the monthly earnings of minimum wage workers to various housing types reveals that:
  - They could never afford a **2-bedroom** rental, as these costs consume **80%** of their monthly earnings.
  - They could never afford a **3-plus-bedroom** rental, as these costs consume **90%** of their monthly earnings.

### <ins> Analysis 3 </ins>
This analysis examines whether a greater number of rental units in a zone correlates with lower average rent prices. To conduct this, I have classified zones into low, medium, and high rent categories based on their average rent.

#### **SQL Query 3.1:**
```sql
SELECT MIN(Total_Avg_Rent) AS Min_Rent, MAX(Total_Avg_Rent) AS Max_Rent, 
MAX(Total_Avg_Rent) - MIN(Total_Avg_Rent) AS Rent_Range
FROM zone_avg_rent;
```

#### **Output 3.2:**
![Result 3 1](https://github.com/user-attachments/assets/e1a2b711-a34f-4d7b-81c7-61985d16e5ce)

Based on these findings, I have classified the zones as follows:
- Low: Rent less than $1650
- Medium: Rent between $1650 and $2000
- High: Rent greater than $2000

#### **SQL Query 3.2:**
```sql
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
```

#### **Output 3.2:**
The output table is not included here due to its length, but the CSV file is available in the Outputs folder.

Next, I have analyzed the average number of units across the different rent classifications.

#### **SQL Query 3.3:**
```sql
-- Select rent levels with their count and average total units
SELECT 
    Rent_Level, 
    COUNT(Rent_Level) AS Level_Count,  -- Count of zones in each rent level
    FORMAT(AVG(Total_Units), 2) AS Avg_Units  -- Average total units in each rent level
FROM 
    temp_zone_classifier
GROUP BY 
    Rent_Level;  -- Group by rent level to aggregate results
```

#### **Output 3.3:**
![Result 3 3](https://github.com/user-attachments/assets/9a3e588c-5ad2-4f29-8639-63e978a0891b)


#### *Investigating Medium Rent Zones*
Noticing some anomalies in the medium rent category, I have investigated further for potential outliers.

#### **SQL Query 3.4:**
```sql
-- Retrieving the zones with 'Medium' rent level from the temporary table
SELECT *
FROM temp_zone_classifier
WHERE Rent_Level = 'Medium'
ORDER BY Total_Units;
```
Identifying that **Vancouver zone** has an exceptionally high number of units **(123,867)**, I have opted to use the median instead of the mean to get a clearer picture of the medium rent levels.

#### **Output 3.4:**
![Result 3 4](https://github.com/user-attachments/assets/13347c92-b573-48f2-9faa-d708d0f13f88)

#### **SQL Query 3.5:**
```sql
-- Getting the Median number of units for Medium rent level zones
SET @rowindex := -1;
SELECT
   Rent_Level, FORMAT(AVG(u.Total_Units), 2) as Median 
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           temp_CTE.Total_Units AS Total_Units,
           temp_CTE.Rent_Level AS Rent_Level
    FROM temp_CTE
    WHERE Rent_Level = 'Medium'
    ORDER BY temp_CTE.Total_Units) AS u
WHERE 
u.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2))
GROUP BY
Rent_Level;
```

#### **Output 3.5:**
![Result 3 5](https://github.com/user-attachments/assets/06020726-721c-4386-a2ea-18768d928e41)

### Interpretation
The data shows no clear correlation between the number of rental units and rent prices across different zones. Both high-rent and low-rent areas appear to have similar average unit counts, suggesting that the number of available units does not significantly influence rent levels.

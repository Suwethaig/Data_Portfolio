
# Vancouver's Rental Reality

### ***You vs. Vancouver rental prices***

As a newcomer to Vancouver, one of the first things I noticed was how much of my income goes toward rent! It was surprising to realize that renting in Vancouver demands a significant portion of my earnings, something I wasn't accustomed to. This observation led me to wonder: ***Is this a recent phenomenon, or have Vancouverites always faced such high rents?*** 

Rather than just speculate, I decided to dive into the data and discover the truth for myself.

![Combined Meme](https://github.com/user-attachments/assets/81e90ab1-dfe1-49cc-ae58-e7de5ce971ac)

## Table of Contents
- [Key Questions for Exploration](key-questions-for-exploration)
- [Hypotheses](hypotheses)
- [Data Analysis](data-analysis)
  - [Analysis 1 - Rental Price Evolution](#-analysis-1---rental-price-evolution-)
  - [Analysis 2 - Minimum Wage Challenges](#-analysis-2---minimum-wage-challenges-)
  - [Analysis 3 - Supply and Price Dynamics](#-analysis-3---supply-and-price-dynamics-)
  - [Analysis 4 - Housing Option Trends](#-analysis-4---housing-option-trends-)
  - [Analysis 5 - Affordable Zones](#-analysis-5---affordable-zones-)
- [Final Results](final-results)
- [Data Overview](data-overview)
  - [Data Sources](data-sources)
  - [Data Modifications](data-modifications)
- [Setup Instructions](#setup-instructions)
- [Guide to Folders](#guide-to-folders)

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

### <ins> Analysis 1 - Rental Price Evolution </ins>
This analysis focuses on determining whether high rental prices in Vancouver are a recent occurrence or if they have been high over the past 15 years. I have calculated annual rent change and percentage growth to identify significant increases in rent.

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

### <ins> Analysis 2 - Minimum Wage Challenges </ins>
This analysis delves into the struggles of minimum wage workers in Vancouver when it comes to affording rent. By comparing rental prices to monthly wages, I aim to reveal the percentage of income that these workers must allocate to housing costs. To ensure a relevant understanding of the current landscape, I have concentrated on the last five years of data.

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

Next, I have calculated rent to income ratio for total average rent and average rent across different housing types.

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
- On average, minimum wage workers in Vancouver spend about **65%** of their income on rent.
- The situation is only slightly better for median wage workers, who allocate around **35%** of their income to rent.
- A deeper analysis comparing the monthly earnings of minimum wage workers to various housing types reveals that:
  - **2-bedroom** rental, would consume **80%** of their monthly earnings.
  - **3-plus-bedroom** rental, would consume **90%** of their monthly earnings.

### <ins> Analysis 3 - Supply and Price Dynamics </ins>
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
#### **Output 3.4:**
![Result 3 4](https://github.com/user-attachments/assets/13347c92-b573-48f2-9faa-d708d0f13f88)

Identifying that **Vancouver zone** has an exceptionally high number of units **(123,867)**, I have opted to remove it as it an outlier and them determine the mean to get a clearer picture of the medium rent levels.

#### **SQL Query 3.5:**
```sql
-- Select rent levels with their count and average total units
SELECT 
    Rent_Level, 
    COUNT(Rent_Level) AS Level_Count,  -- Count of zones in each rent level
    FORMAT(AVG(Total_Units), 2) AS Avg_Units  -- Average total units in each rent level
FROM 
    temp_zone_classifier
WHERE Total_Units < 10000
GROUP BY 
    Rent_Level;  -- Group by rent level to aggregate results
```

#### **Output 3.5:**
![Result 3 5](https://github.com/user-attachments/assets/40051db6-2f4b-4a8f-8b9f-33bd64c453ee)

### Interpretation
- Despite the higher availability of rental units in medium rent zones, the presence of more units does not translate to lower prices.

### <ins> Analysis 4 - Housing Option Trends </ins>
This analysis aims to determine whether renting a larger home in Vancouver is significantly more expensive compared to smaller units, or if all housing types are generally hard to afford. 

#### **SQL Query 4.1:**
```sql
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
```

#### **Output 4.1:**
![Result 4 1](https://github.com/user-attachments/assets/31adf246-d1b5-40fd-82cc-45480731c93d)

### Interpretation
- The rent for a **bachelor unit** is **31%** of the median income, which is already significant. 
- This percentage rises to **51%** for **3-plus bedroom** units.

### <ins> Analysis 5 - Affordable Zones </ins>
This analysis focuses on identifying the zone in Vancouver that has the lowest average rent, providing insight into the most affordable area for renters.

#### **SQL Query 5.1:**
```sql
-- Retrieve the zone with the lowest average rent
SELECT 
    Zone, 
    Total_Avg_Rent
FROM 
    zone_avg_rent
ORDER BY 
    Total_Avg_Rent ASC  -- Order by rent in ascending order
LIMIT 1;  -- Limit the result to the zone with the lowest rent
```

#### **Output 5.1:**
![Result 5 1](https://github.com/user-attachments/assets/88310cfa-cf08-4cfc-bf2b-43df804d6f70)

### Interpretation
- The three zones that offer lowest average rent are **Marpole**, **White Rock** and **Southeast Burnaby**.

## Final Results
***1. Have rental prices in Vancouver consistently been high, or is this a recent trend?***\
The high rents currently experienced in Vancouver are part of a recent trend driven by increased housing demand and post-pandemic recovery.

***2. How challenging is it for a minimum wage worker to manage rent payments?***
- Minimum wage workers spend a significant portion of their income on rent, placing a considerable strain on their finances.
- For a family with one earner, affording a 2-bedroom or 3-plus-bedroom rental is nearly impossible, as these costs consume around 85% of their monthly earnings.

***3. Does having a greater number of rental units in a zone lead to lower prices?***\
The analysis indicates that no clear correlation exists between the number of rental units and rent prices across different zones. While increased supply typically leads to lower rents, this relationship appears more complex in Vancouver. Factors such as high demand, economic conditions, and housing policies may counteract the expected supply-demand dynamics.

***4. Is renting a larger home significantly more expensive, or are all housing options hard to afford?***\
Rent constitutes a financial burden across all housing types. However, the larger the home, the more challenging it becomes to manage rent payments effectively.

***5. Which zone would be the best choice if I want to minimize my rent?***\
The Marpole zone offers the lowest average rent at $1,396, making it a more affordable option for renters in Vancouver.

## Data Overview

### Data Sources
1. **Vancouver Rental Data** - Canadian Mortagage and Housing Corporation [(Link)](https://www03.cmhc-schl.gc.ca/hmip-pimh/en/TableMapChart/Table?TableId=2.1.31.3&GeographyId=2410&GeographyTypeId=3&DisplayAs=Table&GeograghyName=Vancouver)
2. **Median Hourly Wage Data** - Statistics Canada [(Link)](https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1410006401&pickMembers%5B0%5D=1.11&pickMembers%5B1%5D=2.2&pickMembers%5B2%5D=3.1&pickMembers%5B3%5D=5.1&pickMembers%5B4%5D=6.1&cubeTimeFrame.startYear=2019&cubeTimeFrame.endYear=2023&referencePeriods=20190101%2C20230101)
3. **Minimum Hourly Wage Data** - Government of Canada [(Link)](https://open.canada.ca/data/en/dataset/390ee890-59bb-4f34-a37c-9732781ef8a0/resource/2ddfbfd4-8347-467d-b6d5-797c5421f4fb  )

### Data Modifications
The following data modifications were performed in Excel:

#### 1. **Historical Rent Data** 
   - **Files**: `his_units`, `his_ave_rent`
   - **Modifications**:
     - Removed columns and rows that were not relevant to the analysis.
     - Formatted the `Year` column to display only the year, simplifying the data for time-series analysis.

#### 2. **Zone Data**
   - **Files**: `zone_units`, `zone_avg_rent`
   - **Modifications**:
     - Removed unnecessary columns and rows to streamline the dataset.
     - Replaced empty cells (originally marked as `**`) with `n/a` for clarity and consistency.

#### 3. **Combined Wage Data**
   - **File**: `combined_wage_data`
   - **Modifications**:
     - This file was created by merging two datasets:
       1. **Median Wage Data**: 
          - Removed unused columns and rows.
          - Pivoted the table to achieve the required format for analysis.
       2. **Historical Minimum Salary**: 
          - Filtered the dataset to only include British Columbia (BC) data.
          - Formatted the `Year` column to display only the year.
          - Updated the wage data to fill in missing values for consecutive years. For instance, if the minimum wage was $5 in 1990 and increased to $5.50 in 1992, the wage for 1991 was set at $5, reflecting the situation in that year.

## Setup Instructions

- Set up the database by importing the necessary datasets into your SQL database: `his_units`, `his_ave_rent`, `zone_units`, `zone_avg_rent`, and `combined_wage_data`.
- Run the analysis by executing the provided SQL queries on the rental data.
- Finally, view the results of the analysis in your SQL database or through any generated output files.

## Guide to Folders

- **Dataset**: This folder contains both the original unedited datasets obtained from the source and the edited datasets that have been modified for analysis purposes.
- **Output**: This folder holds all output images generated from the analysis, providing visual representations of the data findings.
- **SQL Files**: This folder includes all SQL queries used throughout the project for data analysis, ensuring easy access to the code behind the results.


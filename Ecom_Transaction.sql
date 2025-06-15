-- PART 1: DATA CLEANING
-- View the original transaction data
SELECT * FROM transaction_data;

-- Create staging table with appropriate data types for data cleaning and transformation
CREATE TABLE `trans_data_stagging` (
  `Transaction_ID` int DEFAULT NULL,
  `User_Name` text,
  `Age` int DEFAULT NULL,
  `Country` text,
  `Product_Category` text,
  `Purchase_Amount` double DEFAULT NULL,
  `Payment_Method` text,
  `Transaction_Date` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Check the empty staging table structure
SELECT * FROM trans_data_stagging;

-- Load data from the raw transaction_data into staging table for cleaning
INSERT trans_data_stagging
SELECT * 
FROM transaction_data;

-- Verify data loaded into staging table
SELECT * FROM trans_data_stagging;

-- Get max Transaction_ID to check range or data completeness
SELECT MAX(Transaction_ID)
FROM trans_data_stagging;

-- 1. CHECK FOR DUPLICATES

-- Count distinct Transaction_IDs to compare with total count for duplicates
SELECT COUNT(DISTINCT(Transaction_ID))
FROM trans_data_stagging;

-- Count total records to compare against distinct count
SELECT COUNT(Transaction_ID)
FROM trans_data_stagging;

-- Check distinct values in Country, Product_Category and Payment_Method columns for data profiling
SELECT DISTINCT(Country)
FROM trans_data_stagging;

SELECT DISTINCT(Product_Category)
FROM trans_data_stagging;

SELECT DISTINCT(Payment_Method)
FROM trans_data_stagging;

-- 2. STANDARDIZE THE DATE FORMAT

-- Preview conversion of transaction_Date from text to date format
SELECT 	`transaction_Date`, STR_TO_DATE(`transaction_Date`, '%Y-%m-%d') as newDate
FROM trans_data_stagging;

-- Update transaction_Date column to DATE data type by converting text to date format
UPDATE trans_data_stagging
SET `transaction_Date` = STR_TO_DATE(`transaction_Date`, '%Y-%m-%d');

-- Change column data type from text to DATE
ALTER TABLE trans_data_stagging
MODIFY COLUMN `transaction_Date` DATE;

-- 3. CHECK FOR NULL OR BLANK VALUES IN KEY COLUMNS

-- View full table to scan for missing data visually
SELECT *
FROM trans_data_stagging;

-- Check for NULL Transaction_ID, Purchase_Amount and transaction_Date values
SELECT Transaction_ID
FROM trans_data_stagging
WHERE Transaction_ID IS NULL ;

SELECT Purchase_Amount
FROM trans_data_stagging
WHERE 1 IS NULL;

SELECT transaction_Date
FROM trans_data_stagging
WHERE 1 IS NULL;

-- 4. REMOVE UNNECESSARY/EXTRA COLUMNS

-- EXPLORATORY DATA ANALYSIS (EDA)
-- View staging table data
SELECT *
FROM trans_data_stagging;

-- Find date range for transaction_Date to understand data period coverage
SELECT MAX(transaction_Date), MIN(transaction_Date)
FROM trans_data_stagging;

-- Aggregate transaction count and sum of purchase amounts by Country
SELECT Country, COUNT(Transaction_ID), ROUND(SUM(Purchase_Amount),2)
FROM trans_data_stagging
GROUP BY 1
ORDER BY 3 DESC;

-- Aggregate yearly transaction count and purchase sums by Product_Category in USA
SELECT Country, SUBSTRING(`transaction_Date`,1,4), Product_Category, COUNT(Transaction_ID), ROUND(SUM(Purchase_Amount),2)
FROM trans_data_stagging
WHERE Country = 'USA'
GROUP BY 1, 2, 3
ORDER BY 3 DESC;

-- Create CTE for USA category-level aggregation by year
WITH CTE_CATEGORY_USA (Country, Years, Category, Trans_Count, Trans_Sum) AS
(SELECT Country, SUBSTRING(`transaction_Date`,1,4), Product_Category, COUNT(Transaction_ID), ROUND(SUM(Purchase_Amount),2)
FROM trans_data_stagging
WHERE Country = 'USA'
GROUP BY 1, 2, 3
ORDER BY 3 DESC
)
SELECT *
FROM CTE_CATEGORY_USA;


-- FIND TOP 3 PRODUCT CATEGORIES IN USA BY PURCHASE AMOUNT PER YEAR
WITH CTE_CATEGORY_USA (Country, Years, Category, Trans_Count, Trans_Sum) AS
(SELECT Country, SUBSTRING(`transaction_Date`,1,4), Product_Category, COUNT(Transaction_ID), ROUND(SUM(Purchase_Amount),2)
FROM trans_data_stagging
WHERE Country = 'USA'
GROUP BY 1, 2, 3
ORDER BY 3 DESC
), CTE_TOP3_CATEGORY_USA AS
(
SELECT *,
DENSE_RANK() OVER (PARTITION BY Years ORDER BY Trans_Sum DESC) as Ranking
FROM CTE_CATEGORY_USA
)
SELECT * 
FROM CTE_TOP3_CATEGORY_USA 
WHERE Ranking <= 3;

-- FIND MOST USED PAYMENT METHODS FOR HIGH-VALUE TRANSACTIONS (PURCHASE_AMOUNT > $500) ACROSS COUNTRIES AND YEARS
SELECT *
FROM trans_data_stagging;

SELECT Country, Transaction_ID, Purchase_Amount, Payment_Method, transaction_Date
FROM trans_data_stagging
WHERE Purchase_Amount > 500
ORDER BY 1;

WITH CTE_PayMethod AS
(
SELECT Country, Payment_Method, SUBSTRING(`transaction_Date`,1,4) AS Years, COUNT(Transaction_ID) AS Trans_Count, ROUND(SUM(Purchase_Amount),2) AS Trans_Sum
FROM trans_data_stagging
WHERE Purchase_Amount > 500
GROUP BY 1, 2, 3
ORDER BY 1, 3, 4 DESC
), CTE_PayMethod2 AS
(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY Country, Years) AS Ranking
FROM CTE_PayMethod
) 
SELECT * 
FROM CTE_PayMethod2
WHERE Ranking = 1;

-- ANALYZE AVERAGE TRANSACTION AMOUNT OVER TIME BY AGE GROUPS
SELECT *
FROM trans_data_stagging;

SELECT Country, Age, YEAR(`transaction_Date`), ROUND(AVG(Purchase_Amount),2)
FROM trans_data_stagging
GROUP BY 1, 2, 3
ORDER BY 1;

-- Create CTE to group ages into buckets and calculate average purchase amounts by age group and year
WITH CTE_SpendBehaviour AS
(
SELECT Country, 
(CASE
	WHEN Age BETWEEN 18 AND 30 THEN '18-30'
    WHEN Age BETWEEN 31 AND 50 THEN '31-50'
    WHEN Age > 50 THEN '51+'
END) AS Age_Group, YEAR(`transaction_Date`) as Years, Purchase_Amount
FROM trans_data_stagging
ORDER BY 1
), CTE_SpendBehaviour2 AS
(
SELECT Country, Years, Age_Group, ROUND(AVG(Purchase_Amount),2) as Avg_Purchase_Amount
FROM CTE_SpendBehaviour
GROUP BY 1,2,3
ORDER BY 1, 2
)
SELECT * 
FROM CTE_SpendBehaviour2;


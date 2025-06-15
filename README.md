# E-Commerce Transaction Data Analysis with SQL

## Overview
This repository contains SQL scripts and a CSV dataset for analyzing e-commerce transaction data. The project demonstrates end-to-end data cleaning, transformation, and exploratory data analysis (EDA) using SQL. It is designed to showcase practical skills in working with real-world transaction datasets and answering common business questions using SQL queries.

The dataset includes customer demographics, product categories, purchase amounts, payment methods, and transaction dates. The SQL code focuses on data cleaning, handling duplicates, date standardization, null checks, and extracting valuable insights such as top product categories, spending behaviors by age group, and payment method trends.

## Dataset
The dataset (CSV file included) contains the following columns:
  1. Transaction_ID:  Unique identifier for each transaction
  2. User_Name:	Customer's username
  3. Age:	Customer's age
  4. Country:	Country of purchase
  5. Product_Category:	Category of the purchased product
  6. Purchase_Amount:	Amount spent on the transaction
  7. Payment_Method:	Mode of payment (e.g., Credit Card, PayPal)
  8. Transaction_Date:	Date of the transaction (YYYY-MM-DD format)

## SQL Script Summary
The SQL scripts perform the following tasks:
  1. Data Loading and Staging: Create a staging table and load raw data for transformation.
  2. Data Cleaning:
       Check for duplicates and missing values.
       Standardize the date format and convert Transaction_Date from text to date data type.
  3. Exploratory Data Analysis:
       Aggregate total purchase amounts and transaction counts by country and product categories.
       Identify the top 3 product categories in the USA by purchase amount per year.
       Analyze payment methods preferred for high-value transactions ($500+).
       Examine spending behavior by age groups over time.

## How to Use
Import the Excel dataset (transaction_data.csv) into your SQL environment.
Run the SQL script step-by-step in your SQL client (e.g., MySQL Workbench, Azure Data Studio).
Modify the queries or dataset as needed to explore additional business questions.
Use the results as examples of practical SQL data analysis for portfolio building or learning purposes.

## Skills Demonstrated
  SQL data manipulation and transformation | 
  Use of Common Table Expressions (CTEs) | 
  Window functions (ROW_NUMBER(), DENSE_RANK()) | 
  Data cleaning and null handling | 
  Aggregation and grouping | 
  Date handling and formatting | 
  Exploratory data analysis with SQL

## Contact
If you have any questions or feedback, feel free to reach out:
### Prachi Holkar
Linkedin URL: https://www.linkedin.com/in/prachi-holkar/ | 
Email: holkarprachi@hotmail.com


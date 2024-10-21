-- SQL Retail Sales Analysis
CREATE DATABASE retail_sales;

-- Drop TABLE if exists
DROP TABLE IF EXISTS retail_sales;

-- Create TABLE
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date date,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantiy INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

SELECT
    *
FROM
    retail_sales
LIMIT
    10;

SELECT
    COUNT(*)
FROM
    retail_sales;

SELECT
    *
FROM
    retail_sales
WHERE
    transactions_id IS NULL;

SELECT
    *
FROM
    retail_sales
WHERE
    sale_date IS NULL;

SELECT
    *
FROM
    retail_sales
WHERE
    sale_time IS NULL;

-- Data Cleaning
SELECT
    *
FROM
    retail_sales
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

DELETE FROM retail_sales
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

-- Data Exploration
-- How many sales we have?
SELECT
    COUNT(*) AS total_sales
FROM
    retail_sales;

-- How many customers we have?
SELECT
    COUNT(DISTINCT customer_id) AS total_customers
FROM
    retail_sales;

SELECT DISTINCT
    category
FROM
    retail_sales;

-- Data Analysis & Business Key Problems & Answers
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT
    *
FROM
    retail_sales
WHERE
    category = 'Clothing'
    AND quantity >= 4
    AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT
    category,
    SUM(total_sale) AS total_sales
FROM
    retail_sales
GROUP BY
    category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
    ROUND(AVG(age), 2) AS average_age
FROM
    retail_sales
WHERE
    category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT
    *
FROM
    retail_sales
WHERE
    total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT
    category,
    gender,
    COUNT(*) AS total_transactions
FROM
    retail_sales
GROUP BY
    gender,
    category
ORDER BY
    category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT
    YEAR,
    MONTH,
    average_sales
FROM
    (
        SELECT
            EXTRACT(
                YEAR
                FROM
                    sale_date
            ) AS YEAR,
            EXTRACT(
                MONTH
                FROM
                    sale_date
            ) AS MONTH,
            AVG(total_sale) AS average_sales,
            RANK() OVER (
                PARTITION BY
                    EXTRACT(
                        YEAR
                        FROM
                            sale_date
                    )
                ORDER BY
                    AVG(total_sale) DESC
            )
        FROM
            retail_sales
        GROUP BY
            1,
            2
    )
WHERE
    RANK = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT
    customer_id,
    SUM(total_sale) total_sales
FROM
    retail_sales
GROUP BY
    customer_id
ORDER BY
    total_sales DESC
LIMIT
    5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers_count
FROM
    retail_sales
GROUP BY
    category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
-- Approach #1 
SELECT
    CASE
        WHEN EXTRACT(
            HOUR
            FROM
                sale_time
        ) < 12 THEN 'Morning'
        WHEN EXTRACT(
            HOUR
            FROM
                sale_time
        ) BETWEEN 12 AND 17  THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS total
FROM
    retail_sales
GROUP BY
    1;

-- Approach #2
WITH
    hourl_sales AS (
        SELECT
            CASE
                WHEN EXTRACT(
                    HOUR
                    FROM
                        sale_time
                ) < 12 THEN 'Morning'
                WHEN EXTRACT(
                    HOUR
                    FROM
                        sale_time
                ) BETWEEN 12 AND 17  THEN 'Afternoon'
                ELSE 'Evening'
            END AS shift
        FROM
            retail_sales
    )
    select * from hourly_sales
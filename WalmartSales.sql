CREATE DATABASE WalmartSales;

USE WalmartSales;

SELECT *
FROM WalmartSalesData;

ALTER TABLE WalmartSalesData
ALTER COLUMN invoice_id VARCHAR(30) NOT NULL;

ALTER TABLE WalmartSalesData
ADD CONSTRAINT PK_invoice_id
PRIMARY KEY (invoice_id);

ALTER TABLE WalmartSalesData
ALTER COLUMN branch VARCHAR(5) NOT NULL;

ALTER TABLE WalmartSalesData
ALTER COLUMN city VARCHAR(30) NOT NULL;

EXEC sp_rename 'WalmartSalesData.Customer_type', 'Customer_Type', 'COLUMN';

ALTER TABLE WalmartSalesData
ALTER COLUMN customer_type VARCHAR(30) NOT NULL;

ALTER TABLE WalmartSalesData
ALTER COLUMN gender VARCHAR(10) NOT NULL;

EXEC sp_rename 'WalmartSalesData.Product_line', 'Product_Line', 'COLUMN';

ALTER TABLE WalmartSalesData
ALTER COLUMN product_line VARCHAR(100) NOT NULL;

EXEC sp_rename 'WalmartSalesData.unit_price', 'Unit_Price', 'COLUMN';

ALTER TABLE WalmartSalesData
ALTER COLUMN unit_price DECIMAL(10, 2) NOT NULL;

ALTER TABLE WalmartSalesData
ALTER COLUMN quantity INT NOT NULL;

EXEC sp_rename 'WalmartSalesData.Tax', 'Vat', 'COLUMN';

ALTER TABLE WalmartSalesData
ALTER COLUMN total DECIMAL(12, 4) NOT NULL;

ALTER TABLE WalmartSalesData
ALTER COLUMN date DATETIME NOT NULL;

ALTER TABLE WalmartSalesData
ALTER COLUMN time TIME NOT NULL;

EXEC sp_rename 'WalmartSalesData.Payment', 'Payment_Method', 'COLUMN';

ALTER TABLE WalmartSalesData
ALTER COLUMN payment_method VARCHAR(15) NOT NULL;

EXEC sp_rename 'WalmartSalesData.cogs', 'Cogs', 'COLUMN';

ALTER TABLE WalmartSalesData
ALTER COLUMN cogs DECIMAL(10, 2) NOT NULL;

EXEC sp_rename 'WalmartSalesData.gross_income', 'Gross_Income', 'COLUMN';

ALTER TABLE WalmartSalesData
ALTER COLUMN gross_income DECIMAL(12, 4) NOT NULL;

EXEC sp_rename 'WalmartSalesData.gross_margin_percentage', 'Gross_Margin_Percentage', 'COLUMN';

ALTER TABLE WalmartSalesData
ALTER COLUMN gross_margin_percentage DECIMAL(11, 9) NOT NULL;

ALTER TABLE WalmartSalesData
ALTER COLUMN rating DECIMAL(5, 2);

SELECT *
FROM WalmartSalesData;

-- Feature Engineering --

-- time_of_day --
 
SELECT 
	CAST(time AS TIME(0)) AS Time,
	(CASE
		WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
		WHEN time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
		ELSE 'Evening'
	 END) AS Time_of_Day
FROM WalmartSalesData;

ALTER TABLE WalmartSalesData 
ADD Time_of_Day VARCHAR(20);

UPDATE WalmartSalesData
SET Time_of_Day =
	CASE
		WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
		WHEN time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
		ELSE 'Evening'
	 END;

-- Time_of_Day --

SELECT CAST(DATE AS Date) AS Date, DATENAME(WEEKDAY, DATE) AS Day_Name
FROM walmartsalesdata;

ALTER TABLE WalmartSalesData
ADD Day_Name VARCHAR(10);

UPDATE WalmartSalesData
SET Day_Name = DATENAME(WEEKDAY, DATE);

-- Month_Name --

SELECT 
    CAST(DATE AS DATE) as DATE,
    DATENAME(MONTH, DATE) AS Month_Name
FROM WalmartSalesData;

ALTER TABLE WalmartSalesData
ADD Month_Name VARCHAR(10);

UPDATE WalmartSalesData
SET Month_Name = DATENAME(MONTH, DATE);

-- Generic Questions --

-- How many unique cities does the data have? --

SELECT DISTINCT City
FROM WalmartSalesData;

-- In which city is each branch? --

SELECT DISTINCT City, Branch
FROM WalmartSalesData;

-- Product --
-- 1. How many unique product lines does the data have --

SELECT DISTINCT Product_Line
FROM WalmartSalesData
GROUP BY Product_Line;

-- 2. What is the most common payment method --

SELECT Payment_Method, COUNT(*) AS Number_of_Payment_Method
FROM WalmartSalesData
GROUP BY payment_method
ORDER BY Number_of_Payment_Method DESC;

-- 3. What is the most selling product line? --

SELECT product_line, COUNT(*) AS Number_of_Product_Line
FROM WalmartSalesData
GROUP BY product_line
ORDER BY Number_of_Product_Line DESC;

-- 4. What is the total revenue by month --

SELECT Month_Name , SUM(Total) AS Total_Revenue 
FROM WalmartSalesData
GROUP BY Month_Name
ORDER BY Total_Revenue DESC;

-- 5. What month had the largest COGS? --

SELECT Month_Name, SUM(Cogs) as Largest_Cogs
FROM WalmartSalesData
GROUP BY Month_Name
ORDER BY Largest_Cogs DESC;

-- 6. What product line had the largest revenue? --

SELECT Product_Line, SUM(Total) AS Total_Revenue
FROM WalmartSalesData
GROUP BY Product_Line
ORDER BY Total_Revenue DESC;

-- 7. What is the city with the largest revenue? --

SELECT Branch, City, SUM(Total) AS Total_Revenue
FROM WalmartSalesData
GROUP BY Branch, City
ORDER BY Total_Revenue DESC;

-- 8. What product line had the largest Average VAT? --

SELECT Product_Line, AVG(Vat) AS Largest_Vat
FROM WalmartSalesData
GROUP BY Product_Line
ORDER BY Largest_Vat DESC;

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". --
-- Good if it's greater than average sales --

SELECT Product_Line, SUM(Total) AS Total_Revenue,
CASE	
	WHEN SUM(Total) > (SELECT AVG(Total_Revenue) 
		FROM (SELECT SUM(Total) AS Total_Revenue
		FROM WalmartSalesData
		GROUP BY Product_Line) AS Total_Revenue)
		THEN 'Good'
		ELSE 'Bad'
	END AS Average_Sales_Performance
FROM WalmartSalesData
GROUP BY Product_Line
ORDER BY Total_Revenue DESC;

-- 10. Which brand sold more prodcts that the average product sold? --

SELECT Branch, SUM(Quantity) AS Quantity
FROM WalmartSalesData
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(Quantity)
FROM WalmartSalesData);

-- 11. What is the most common product line by gender? --

SELECT Product_Line, Gender, COUNT(Gender) AS Most_Product_Line
FROM WalmartSalesData
GROUP BY Product_Line,Gender
ORDER BY Most_Product_Line DESC;

-- 12. What is the average rating of each product line? --

SELECT Product_Line, ROUND(AVG(Rating), 2) AS Average_Rating
FROM WalmartSalesData
GROUP BY Product_Line
ORDER BY Average_Rating DESC;



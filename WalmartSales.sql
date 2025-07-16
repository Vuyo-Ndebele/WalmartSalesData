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

-- Product 

-- 1. Number of sales made in each time of the day per weekday --

WITH MondaySales AS (
	SELECT Day_Name, Time_of_Day, Total
	FROM WalmartSalesData
	WHERE Day_Name = 'Monday'
)
SELECT Day_Name, Time_of_Day, COUNT(total) AS Number_of_Sales
FROM MondaySales
GROUP BY Day_Name, Time_of_Day
ORDER BY Number_of_Sales DESC;

-- 2. Which of the customer types brings the most revenue? --

WITH Customer_With_Most_Revenue AS (
	SELECT Customer_Type, Total
	FROM WalmartSalesData
)
SELECT Customer_Type, ROUND(SUM(Total), 2) AS Most_Revenue
FROM Customer_With_Most_Revenue
GROUP BY Customer_Type
ORDER BY Most_Revenue DESC;

-- 3. Which city has the largest tax percentage or VAT (Value Added Tax)? --

WITH City_With_Largest_Vat AS (
	SELECT City, Vat
	FROM WalmartSalesData
)
SELECT City, ROUND(SUM(Vat), 2) AS Largest_Vat
FROM City_With_Largest_Vat
GROUP BY City
ORDER BY Largest_Vat DESC;

-- 4. Which customer type pays the most in VAT? --

WITH Customer_With_Most_Vat AS (
	SELECT Customer_Type, Vat
	FROM WalmartSalesData
)
SELECT Customer_Type, SUM(Vat) AS Most_Vat
FROM Customer_With_Most_Vat
GROUP BY customer_type
ORDER BY Most_Vat DESC;

-- Customer --

-- 1. How many unique customer type does the data have? --

SELECT DISTINCT Customer_Type
FROM WalmartSalesData;

-- 2. How many unique payment methods does the data have? --

SELECT DISTINCT Payment_Method
FROM WalmartSalesData;

-- 3. What is the most common customer type? --

WITH Common_Customer_Type AS (
	SELECT Customer_Type
	FROM WalmartSalesData
)
SELECT TOP 1 Customer_Type, COUNT(*) AS Frequency_Customer_Type
FROM Common_Customer_Type
GROUP BY Customer_Type
ORDER BY Frequency_Customer_Type DESC

-- 4. Which customer type buys the most? --

WITH Customer_That_Buys_The_Most AS (
	SELECT Customer_Type
	FROM WalmartSalesData
)
SELECT Customer_Type, COUNT(*) AS Customer_Count
FROM Customer_That_Buys_The_Most
GROUP BY Customer_Type
ORDER BY Customer_Count DESC;

-- 5. What is the gender of most customers? --

WITH Gender_of_Most_Customers AS (
	SELECT Gender
	FROM WalmartSalesData
)
SELECT Gender, COUNT(*) AS Number_of_Gender
FROM Gender_of_Most_Customers
GROUP BY Gender
ORDER BY Number_of_Gender DESC;

-- 6. What is the gender distribution per branch? --

WITH Branch_of_Customers AS (
	SELECT Branch, Gender
	FROM WalmartSalesData
	WHERE Branch IN('A', 'B', 'C')
)
SELECT Branch, Gender, COUNT(*) AS Number_of_Gender
FROM Branch_of_Customers
GROUP BY Branch, Gender
ORDER BY Branch DESC, Number_of_Gender DESC;

-- 7. Which time of the day do customers give the most rating? --

WITH Time_of_The_Day_With_Most_Ratings AS (
	SELECT Time_of_Day
	FROM WalmartSalesData
)
SELECT Time_of_Day, COUNT(*) AS Most_Rating
FROM Time_of_The_Day_With_Most_Ratings
GROUP BY Time_of_Day
ORDER BY Most_Rating DESC;

-- 8. Which time of the day do customers give the most ratings per branch? --

WITH Time_of_The_Day_With_Most_Ratings AS (
	SELECT Branch, Time_of_Day
	FROM WalmartSalesData
	WHERE Branch IN('A', 'B', 'C')
)
SELECT Branch, Time_of_Day, COUNT(*) AS Most_Ratings
FROM Time_of_The_Day_With_Most_Ratings 
GROUP BY Branch, Time_of_Day
ORDER BY Branch DESC, Most_Ratings DESC;

-- 9. Which day of the week has the best average ratings? --

WITH The_Best_Day_Avg_Ratings AS (
	SELECT Day_Name, Rating
	FROM WalmartSalesData
)
SELECT Day_Name, AVG(Rating) AS Best_Average_Ratings
FROM The_Best_Day_Avg_Ratings
GROUP BY Day_Name
ORDER BY Best_Average_Ratings DESC;

-- 10. Which day of the week has the best average ratings per branch? --

WITH The_Best_Day_Avg_Ratings AS (
	SELECT Branch, Day_Name, Rating
	FROM WalmartSalesData
)
SELECT Branch, Day_Name, AVG(Rating) AS Best_Average_Ratings
FROM The_Best_Day_Avg_Ratings
GROUP BY Branch, Day_Name
ORDER BY Branch DESC, Best_Average_Ratings DESC;


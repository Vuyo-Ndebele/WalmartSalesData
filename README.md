# Walmart Sales Data Analysis

## About

This project aims to explore the Walmart Sales data to understand top performing branches and products, sales trends of different products and customer behaviour. The aim is to study how sales strategies can be improved and optimized. The dataset was obtained from the [Kaggle Walmart Sales Forecasting Competition](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting).

"In this recruiting competition, job-seekers are provided with historical sales data for 45 Walmart stores located in different regions. Each store contains many departments, and participants must project the sales for each department in each store. To add to the challenge, selected holiday markdown events are included in the dataset. These markdowns are known to affect sales, but it is challenging to predict which departments are affected and the extent of the impact." [source](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting).

## Purposes Of The Project

The major purpose of this project is to gain insight into the sales data of Walmart to understand the different factors that affect sales of different branches.

## About Data

The dataset was obtained from the [Kaggle Walmart Sales Forecasting Competition](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting). This dataset contains sales transactions from three different branches of Walmart, respectively located in Mandalay, Yangon and Naypyitaw. The data contains 17 columns and 1000 rows:

| Column                  | Description                             | Data Type      |
| :---------------------- | :-------------------------------------- | :------------- |
| invoice_id              | Invoice of the sales made               | VARCHAR(30)    |
| branch                  | Branch at which sales were made         | VARCHAR(5)     |
| city                    | The location of the branch              | VARCHAR(30)    |
| customer_type           | The type of the customer                | VARCHAR(30)    |
| gender                  | Gender of the customer making purchase  | VARCHAR(10)    |
| product_line            | Product line of the product solf        | VARCHAR(100)   |
| unit_price              | The price of each product               | DECIMAL(10, 2) |
| quantity                | The amount of the product sold          | INT            |
| VAT                 | The amount of tax on the purchase       | FLOAT(6, 4)    |
| total                   | The total cost of the purchase          | DECIMAL(10, 2) |
| date                    | The date on which the purchase was made | DATE           |
| time                    | The time at which the purchase was made | TIMESTAMP      |
| payment_method                 | The total amount paid                   | DECIMAL(10, 2) |
| cogs                    | Cost Of Goods sold                      | DECIMAL(10, 2) |
| gross_margin_percentage | Gross margin percentage                 | FLOAT(11, 9)   |
| gross_income            | Gross Income                            | DECIMAL(10, 2) |
| rating                  | Rating                                  | FLOAT(2, 1)    |

### Analysis List

1. Product Analysis

> Conduct analysis on the data to understand the different product lines, the products lines performing best and the product lines that need to be improved.

2. Sales Analysis

> This analysis aims to answer the questions of the sales trends of products. The result of this can be used to measure the effectiveness of each sales strategy the business applies and what modificatoins are needed to gain more sales.

3. Customer Analysis

> This analysis aims to uncover different customer segments, purchase trends and the profitability of each customer segment.

## Approach Used

1. **Data Wrangling:** This is the first step where inspection of data is done to make sure **NULL** values and missing values are detected and data replacement methods are used to replace, missing or **NULL** values.

> 1. Build a database
> 2. The SQL script does a comprehensive cleanup and transformation of the WalmartSalesData table.
     It includes:

>    a. Renaming columns for consistency (using EXEC sp_rename).

>    b. Setting stricter data types and NOT NULL constraints.

>    c. Adding a primary key on invoice_id.

> 3. Select columns with null values in them. There are no null values in our database as in creating the tables, we set **NOT NULL** for each field, hence null values are filtered out.

2. **Feature Engineering:** This will help generate some new columns from existing ones.

> 1. Add a new column named `time_of_day` to give insight of sales in the Morning, Afternoon and Evening. This will help answer the question on which part of the day most sales are made.

> 2. Add a new column named `day_name` that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busy.

> 3. Add a new column named `month_name` that contains the extracted month of the year on which the given transaction took place (Jan, Feb, Mar). Help determine which month of the year has the most sales and profit.

2. **Exploratory Data Analysis (EDA):** Exploratory data analysis is done to answer the listed questions and aims of this project.

3. **Conclusion:**
   
> The analysis of Walmart sales data reveals several key insights into customer behavior, sales trends, and operational performance across branches and product lines.
> The  data shows consistent peak sales during specific times of the day and days of the week, highlighting clear shopping patterns.
> Additionally, certain product lines consistently outperform others, indicating stronger consumer demand in those categories.
> Customer types and gender distribution also influence purchasing behavior, offering a deeper understanding of target demographics.
> Seasonal variations and branch-level performance differences further suggest that location and timing significantly impact overall sales.

4. **Recommendations:**
   
> 1. Optimize Inventory Based on Product Line Performance
- Focus on stocking high-demand product lines while reconsidering or improving underperforming ones. Use historical sales trends to predict demand more accurately.

> 2. Enhance Marketing for Low-Performing Periods
- Target marketing campaigns during off-peak hours and low-sales days to boost customer traffic and increase average daily sales.

> 3. Branch-Specific Strategies
- Customize strategies for each branch based on local customer behavior and performance metrics. Consider promotional offers or layout adjustments to improve sales in weaker branches.

> 4. Leverage Customer Type Insights
- Develop loyalty programs or targeted promotions for both regular and first-time customers based on their spending patterns.

> 5. Use Time-of-Day Data to Improve Staffing and Service
- Align staff schedules and promotional activities with peak shopping times (e.g., afternoons and weekends) to enhance customer service and satisfaction.

> 6. Promote High-Margin Products
- Analyze profitability alongside sales volume to promote not just high-selling items, but those with higher margins.

> 7. Adopt a Data-Driven Culture
- Encourage continuous data collection and analysis to monitor trends, identify opportunities, and adapt quickly to changes in customer behavior or market conditions.

## Business Questions To Answer

### Generic Question

1. How many unique cities does the data have?
2. In which city is each branch?

### Product

1. How many unique product lines does the data have?
2. What is the most common payment method?
3. What is the most selling product line?
4. What is the total revenue by month?
5. What month had the largest COGS?
6. What product line had the largest revenue?
5. What is the city with the largest revenue?
6. What product line had the largest VAT?
7. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
8. Which branch sold more products than average product sold?
9. What is the most common product line by gender?
12. What is the average rating of each product line?

### Sales

1. Number of sales made in each time of the day per weekday
2. Which of the customer types brings the most revenue?
3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
4. Which customer type pays the most in VAT?

### Customer

1. How many unique customer types does the data have?
2. How many unique payment methods does the data have?
3. What is the most common customer type?
4. Which customer type buys the most?
5. What is the gender of most of the customers?
6. What is the gender distribution per branch?
7. Which time of the day do customers give most ratings?
8. Which time of the day do customers give most ratings per branch?
9. Which day fo the week has the best avg ratings?
10. Which day of the week has the best average ratings per branch?


## Revenue And Profit Calculations

$ COGS = unitsPrice * quantity $

$ VAT = 5\% * COGS $

$VAT$ is added to the $COGS$ and this is what is billed to the customer.

$ total(gross_sales) = VAT + COGS $

$ grossProfit(grossIncome) = total(gross_sales) - COGS $

**Gross Margin** is gross profit expressed in percentage of the total(gross profit/revenue)

$ \text{Gross Margin} = \frac{\text{gross income}}{\text{total revenue}} $

<u>**Example with the first row in our DB:**</u>

**Data given:**

- $ \text{Unite Price} = 45.79 $
- $ \text{Quantity} = 7 $

$ COGS = 45.79 * 7 = 320.53 $

$ \text{VAT} = 5\% * COGS\\= 5\%  320.53 = 16.0265 $

$ total = VAT + COGS\\= 16.0265 + 320.53 = $336.5565$

$ \text{Gross Margin Percentage} = \frac{\text{gross income}}{\text{total revenue}}\\=\frac{16.0265}{336.5565} = 0.047619\\\approx 4.7619\% $

## Code

For the rest of the code, check the [WalmartSales.sql](https://github.com/Vuyo-Ndebele/WalmartSalesData/blob/main/WalmartSales.sql) file.

```SQL

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

```


-- Retrieve all columns from the superstore table
SELECT * FROM super_store_analysis.superstore;

-- Count the total number of rows in the superstore table
SELECT Count(*) FROM super_store_analysis.superstore;

-- Calculate total sales, quantity sold, and profit
SELECT ROUND(SUM(Sales), 0) AS Total_Sales,
       ROUND(SUM(Quantity), 0) AS Quantity_Sold,
       ROUND(SUM(Profit), 0) AS Profit
FROM super_store_analysis.superstore;

-- Count the number of orders per year
SELECT YEAR(STR_TO_DATE(Order_Date, '%d-%m-%Y')) AS `YEAR`,
       COUNT(DISTINCT Order_ID) AS Orders
FROM super_store_analysis.superstore
GROUP BY YEAR(STR_TO_DATE(Order_Date, '%d-%m-%Y'))
ORDER BY YEAR(STR_TO_DATE(Order_Date, '%d-%m-%Y'));

-- Calculate average sales per month
SELECT MONTH(STR_TO_DATE(Order_Date,'%d-%m-%Y')) AS 'MONTH',
       ROUND(AVG(Sales), 0) AS Avg_Sales
FROM super_store_analysis.superstore
GROUP BY MONTH(STR_TO_DATE(Order_Date, '%d-%m-%Y'))
ORDER BY MONTH(STR_TO_DATE(Order_Date, '%d-%m-%Y'));

-- Find the latest and earliest order dates
SELECT MIN(STR_TO_DATE(Order_Date,'%d-%m-%Y')) AS Latest_Date,
       MAX(STR_TO_DATE(Order_Date,'%d-%m-%Y')) AS Earliest_Date
FROM super_store_analysis.superstore;

-- Count the number of orders per year
SELECT YEAR(STR_TO_DATE(Order_Date,'%d-%m-%Y')) AS 'YEAR',
       COUNT(DISTINCT Order_ID) AS Orders
FROM super_store_analysis.superstore
GROUP BY YEAR(STR_TO_DATE(Order_Date, '%d-%m-%Y'))
ORDER BY YEAR(STR_TO_DATE(Order_Date, '%d-%m-%Y'));

-- Calculate total sales per city and display top 5 cities by sales
SELECT City, ROUND(SUM(Sales), 0) AS Total_Sales
FROM super_store_analysis.superstore
GROUP BY City
ORDER BY Total_Sales DESC
LIMIT 5;

-- Calculate profit margin per region and display the region with the highest profit margin
SELECT Region, ROUND(AVG(Profit)) AS Profit_Margin
FROM super_store_analysis.superstore
GROUP BY Region
ORDER BY Profit_Margin DESC
LIMIT 1;

-- Calculate total sales per state and display top 10 states by sales
SELECT State, ROUND(SUM(Sales)) AS Total_Sales
FROM super_store_analysis.superstore
GROUP BY State
ORDER BY Total_Sales DESC
LIMIT 10;

-- Calculate total sales and quantity sold per product and display top 10 products by sales
SELECT `Product Name`, ROUND(SUM(Sales), 0) AS Total_Sales,
       ROUND(SUM(Quantity), 0) AS Quantity_sold
FROM super_store_analysis.superstore
GROUP BY `Product Name`
ORDER BY Total_Sales DESC
LIMIT 10;

-- Calculate total sales and quantity sold per category and sub-category and display top 10 categories by sales
SELECT Category, `Sub-Category`, ROUND(SUM(Sales), 0) AS Total_Sales,
       ROUND(SUM(Quantity), 0) AS Quantity_sold
FROM super_store_analysis.superstore
GROUP BY Category, `Sub-Category`
ORDER BY Total_Sales DESC
LIMIT 10;

-- Find top 10 products with maximum profit
SELECT `Product Name`, ROUND(SUM(Profit), 0) AS Max_Profit
FROM super_store_analysis.superstore
GROUP BY `Product Name`
ORDER BY Max_Profit DESC
LIMIT 10;

-- Find top 10 products with minimum profit
SELECT `Product Name`, ROUND(SUM(Profit), 0) AS Max_Profit
FROM super_store_analysis.superstore
GROUP BY `Product Name`
ORDER BY Max_Profit ASC
LIMIT 10;

-- Find top 10 customers with highest total sales
SELECT `Customer Name`, ROUND(SUM(Sales), 0) AS Total_Sales
FROM super_store_analysis.superstore
GROUP BY `Customer Name`
ORDER BY Total_Sales DESC
LIMIT 10;

-- Find the customer with the most purchased quantity
SELECT `Customer Name`, SUM(Quantity) AS Most_Purchased
FROM super_store_analysis.superstore
GROUP BY `Customer Name`
ORDER BY Most_Purchased DESC
LIMIT 1;

-- Find the customer with the least purchased quantity
SELECT `Customer Name`, SUM(Quantity) AS Least_Purchased
FROM super_store_analysis.superstore
GROUP BY `Customer Name`
ORDER BY Least_Purchased ASC
LIMIT 1;

-- Calculate the average discount per segment
SELECT Segment, CONCAT(ROUND(AVG(Discount) * 100, 2), '%') AS Avg_discount
FROM super_store_analysis.superstore
GROUP BY Segment;

-- Count the number of orders per ship mode
SELECT `Ship Mode`, COUNT(*) AS Count
FROM super_store_analysis.superstore
GROUP BY `Ship Mode`
LIMIT 1;

-- Calculate the average difference in days between ship date and order date
SELECT 
    ROUND(AVG(DATEDIFF(STR_TO_DATE(Ship_Date, '%d-%m-%Y'), STR_TO_DATE(Order_Date, '%d-%m-%Y'))), 0) AS avg_difference_days
FROM super_store_analysis.superstore
WHERE Ship_Date IS NOT NULL AND Order_Date IS NOT NULL;

-- Add a duration column to the table
ALTER TABLE super_store_analysis.superstore
ADD COLUMN Duration INT;

-- Update the duration column with the difference in days between ship date and order date
UPDATE super_store_analysis.superstore
SET Duration = DATEDIFF(STR_TO_DATE(Ship_Date, '%d-%m-%Y'), STR_TO_DATE(Order_Date, '%d-%m-%Y'))
WHERE Ship_Date IS NOT NULL AND Order_Date IS NOT NULL;

-- Count the number of late orders per region
SELECT
    Region,
    COUNT(DISTINCT Order_ID) AS Number_of_late_orders
FROM super_store_analysis.superstore
WHERE Duration > (SELECT ROUND(AVG(DATEDIFF(STR_TO_DATE(Ship_Date, '%d-%m-%Y'), STR_TO_DATE(Order_Date, '%d-%m-%Y'))), 0)
                  FROM super_store_analysis.superstore
                  WHERE Ship_Date IS NOT NULL AND Order_Date IS NOT NULL)
GROUP BY Region
ORDER BY Number_of_late_orders DESC;

-- Calculate correlation coefficient between Sales and Profit
SELECT 
    ROUND(
        (COUNT(*) * SUM(Sales * Profit) - SUM(Sales) * SUM(Profit)) /
        SQRT((COUNT(*) * SUM(Sales * Sales) - POW(SUM(Sales), 2)) * (COUNT(*) * SUM(Profit * Profit) - POW(SUM(Profit), 2))),
        2
    ) AS sales_profit_correlation
FROM 
    super_store_analysis.superstore;

-- Calculate correlation coefficient between Quantity and Profit
SELECT 
    ROUND(
        (COUNT(*) * SUM(Quantity * Profit) - SUM(Quantity) * SUM(Profit)) /
        SQRT((COUNT(*) * SUM(Quantity * Quantity) - POW(SUM(Quantity), 2)) * (COUNT(*) * SUM(Profit * Profit) - POW(SUM(Profit), 2))),2) 
        AS Quantiy_profit_correlation
FROM 
    super_store_analysis.superstore;
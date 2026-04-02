

-- Atlas Retail Enterprise Sales & Profitability Analytics


-- SECTION 1: Data Quality Checks

-- Checking for Missing Order IDs (Primary Key Validation)
-----------------------------------------------------------

SELECT [Order_ID],
          [Order_Date],
          [Ship_Date],
          [Customer_ID],
          [Product_ID],
          [Sales],
          [Profit],
          [Discount],
          [Quantity],
          [Country],
          [Region],
          [State],
          [City],
          [Postal_Code]
   FROM [dbo].[raw_sales_order]
   WHERE Order_ID IS NULL


-- Checking for Missing Customer IDs (Customer Dimension Validation)
---------------------------------------------------------------------

SELECT [Customer_ID],
          [Customer_Name],
          [Segment]
   FROM [dbo].[raw_sales_customer]
   WHERE Customer_ID IS NULL


-- Checking for Missing Product IDs (Product Dimension Validation)
-------------------------------------------------------------------

SELECT [Product_ID],
          [Product_Name],
          [Category],
          [Sub_Category]
   FROM [dbo].[raw_sales_product]
   WHERE Product_ID IS NULL


-- Checking for Duplicate Order IDs (Initial Detection)
--------------------------------------------------------

SELECT [Order_ID],
          COUNT(*) Cnt_duplicate
   FROM [dbo].[raw_sales_order]
   GROUP BY [Order_ID]
   HAVING count(*) > 1


-- Checking for Duplicate Order Line Items (Full Row Match)
------------------------------------------------------------

SELECT [Order_ID],
       [Order_Date],
       [Ship_Date],
       [Customer_ID],
       [Product_ID],
       [Sales],
       [Profit],
       [Discount],
       [Quantity],
       [Country],
       [Region],
       [State],
       [City],
       [Postal_Code],
       COUNT(*) Cnt_duplicate
FROM [dbo].[raw_sales_order]
GROUP BY [Order_ID],
         [Order_Date],
         [Ship_Date],
         [Customer_ID],
         [Product_ID],
         [Sales],
         [Profit],
         [Discount],
         [Quantity],
         [Country],
         [Region],
         [State],
         [City],
         [Postal_Code]
HAVING count(*) > 1


-- Checking for Duplicate Customer IDs (Dimension Integrity Check)
-------------------------------------------------------------------

SELECT [Customer_ID],
          COUNT(*) Cnt_duplicate
   FROM [dbo].[raw_sales_customer]
   GROUP BY [Customer_ID]
   HAVING count(*) > 1


-- Checking for Duplicate Product IDs (Dimension Integrity Check)
------------------------------------------------------------------

SELECT [Product_ID],
          COUNT(*) Cnt_duplicate
   FROM [dbo].[raw_sales_product]
   GROUP BY [Product_ID]
   HAVING count(*) > 1


-- Checking For Duplicate Product Records
-------------------------------------------

SELECT [Product_ID],
       [Product_Name],
       [Category],
       [Sub_Category],
       COUNT(*) Cnt_duplicate
FROM [dbo].[raw_sales_product]
GROUP BY [Product_ID],
         [Product_Name],
         [Category],
         [Sub_Category]
HAVING count(*) > 1


-- Creating Clean Products View (Deduplicated Product Dimension)
-----------------------------------------------------------------

CREATE VIEW vw_Sales_Product_Clean AS
WITH Product_Dedup AS (
SELECT [Product_ID],
       [Product_Name],
       [Category],
       [Sub_Category],
       ROW_NUMBER() OVER(PARTITION BY [Product_ID]
                         ORDER BY ([Product_ID])) AS Cnt_Duplicate
FROM [dbo].[raw_sales_product])

SELECT [Product_ID],
       [Product_Name],
       [Category],
       [Sub_Category]
FROM Product_Dedup
WHERE Cnt_Duplicate = 1
GO


-- Checking for Invalid Sales Values (Negative Sales Check)
------------------------------------------------------------

SELECT [Order_ID],
          [Order_Date],
          [Ship_Date],
          [Customer_ID],
          [Product_ID],
          [Sales],
          [Profit],
          [Discount],
          [Quantity],
          [Country],
          [Region],
          [State],
          [City],
          [Postal_Code]
   FROM [dbo].[raw_sales_order]
   WHERE sales < 0


-- Identifying Loss-Making Transactions (Negative Profit)
----------------------------------------------------------

SELECT [Order_ID],
          [Order_Date],
          [Ship_Date],
          [Customer_ID],
          [Product_ID],
          [Sales],
          [Profit],
          [Discount],
          [Quantity],
          [Country],
          [Region],
          [State],
          [City],
          [Postal_Code]
   FROM [dbo].[raw_sales_order]
   WHERE profit < 0


-- Identifying Loss-Making Transactions (Negative Profit)
----------------------------------------------------------

SELECT [Order_ID],
          [Order_Date],
          [Ship_Date],
          [Customer_ID],
          [Product_ID],
          [Sales],
          [Profit],
          [Discount],
          [Quantity],
          [Country],
          [Region],
          [State],
          [City],
          [Postal_Code]
   FROM [dbo].[raw_sales_order]
   WHERE quantity <= 0





-- SECTION 2: Data Modeling & Relationship Validation

-- Data Modeling Preview (Fact–Dimension Join Structure)
---------------------------------------------------------

SELECT *
FROM [dbo].[raw_sales_order] AS o
LEFT JOIN [dbo].[raw_sales_customer] AS c ON o.customer_id = c.customer_id
SELECT *
FROM [dbo].[raw_sales_order] AS o
LEFT JOIN [dbo].[vw_Sales_Product_Clean] AS p ON o.Product_ID = p.Product_ID 


-- Relationship Validation — Orders to Customers
-------------------------------------------------

SELECT o.[Order_ID],
       o.[Order_Date],
       c.[Customer_ID],
       c.[Customer_Name],
       c.[Segment]
FROM [dbo].[raw_sales_order] AS o
LEFT JOIN [dbo].[raw_sales_customer] AS c ON o.customer_id = c.customer_id
WHERE o.Customer_ID IS NOT NULL
AND c.Customer_ID IS NULL 
  

-- Relationship Validation — Orders to Products
------------------------------------------------

SELECT o.[Order_ID],
         o.[Order_Date],
         p.[Product_ID],
         p.[Product_Name],
         p.[Category]
FROM [dbo].[raw_sales_order] AS o
LEFT JOIN [dbo].[vw_Sales_Product_Clean] AS p ON o.Product_ID = p.Product_ID 
WHERE o.Product_ID IS NOT NULL
AND p.Product_ID IS NULL





-- SECTION 3: Business Rules & Logic

-- Discount Status Classification (Discounted vs Non-Discounted)
-----------------------------------------------------------------

  SELECT [Order_ID],
         o.[Product_ID],
         [Customer_ID],
         [Product_Name],
         [Category],
         [Sub_Category],
         [Quantity],
         [Discount],
         [Sales],
         [Profit],
         CASE
             WHEN discount = 0 THEN 'discounted'
             ELSE 'non-discounted'
         END AS Discount_Status
  FROM [dbo].[raw_sales_order] AS o
  INNER JOIN [dbo].[vw_Sales_Product_Clean] AS c ON o.Product_ID = c.Product_ID 
  

  -- Profitability Classification
  --------------------------------

  SELECT [Order_ID],
         o.[Product_ID],
         [Customer_ID],
         [Product_Name],
         [Category],
         [Sub_Category],
         [Quantity],
         [Discount],
         [Sales],
         [Profit],
         CASE
             WHEN profit <= 0 THEN 'Loss'
             WHEN profit > 0 THEN 'Profit'
             ELSE 'Break-even'
         END AS Profit_Status
  FROM [dbo].[raw_sales_order] AS o
  INNER JOIN [dbo].[vw_Sales_Product_Clean] AS c ON o.Product_ID = c.Product_ID 
  

  -- Order Quantity Size Classification (Small / Medium / Large)
  ---------------------------------------------------------------

  SELECT [Order_ID],
         o.[Product_ID],
         [Customer_ID],
         [Product_Name],
         [Category],
         [Sub_Category],
         [Quantity],
         [Discount],
         [Sales],
         [Profit],
         CASE
             WHEN quantity < 5 THEN 'Small'
             WHEN quantity BETWEEN 5 AND 9 THEN 'Medium'
             ELSE 'Large'
         END AS Size_Status
  FROM [dbo].[raw_sales_order] AS o
  INNER JOIN [dbo].[vw_Sales_Product_Clean] AS c ON o.Product_ID = c.Product_ID 
  

  -- Product Revenue Ranking
  ---------------------------

  SELECT [Order_ID],
         o.[Product_ID],
         [Customer_ID],
         [Product_Name],
         [Category],
         [Sub_Category],
         [Sales],
         RANK() over(
                     ORDER BY (sales) DESC) AS Revenue_Rank
  FROM [dbo].[raw_sales_order] AS o
  INNER JOIN [dbo].[vw_Sales_Product_Clean] AS c ON o.Product_ID = c.Product_ID
GROUP BY [Order_ID],
         o.[Product_ID],
         [Customer_ID],
         [Product_Name],
         [Category],
         [Sub_Category],
         [Sales] 
         

-- Customer Revenue Ranking
----------------------------

SELECT [Order_ID],
       o.[Customer_ID],
       [Customer_Name],
       [Segment],
       [Sales],
       RANK() over(
                   ORDER BY (sales) DESC) AS Revenue_Rank
FROM [dbo].[raw_sales_order] AS o
INNER JOIN [dbo].[raw_sales_customer] AS c ON o.Customer_ID = c.Customer_ID
GROUP BY [Order_ID],
         o.[Customer_ID],
         [Customer_Name],
         [Segment],
         [Sales]





-- SECTION 4: Aggregations & Business Insights

-- Executive Business Performance Overview
-------------------------------------------

SELECT sum(sales) AS TotalRevenue,
       sum(profit) AS TotalProfit,
       sum(quantity)TotalQuantity,
       count(DISTINCT order_id) TotalOrders
FROM [dbo].[raw_sales_order] 


-- Monthly sales & profit trend
--------------------------------

SELECT year(order_date) OrderYear,
       MONTH(order_date)OrderMonthNumber,
       datename(MONTH, order_date) OrderMonth,
       sum(sales) MonthlyRevenue,
       sum(profit) MonthlyProfit
FROM [dbo].[raw_sales_order]
GROUP BY year(order_date),
         MONTH(order_date),
         datename(MONTH, order_date)
ORDER BY OrderYear,
         OrderMonthNumber 
         

-- Product performance analysis
--------------------------------

SELECT o.[Product_ID],
       [Product_Name],
       [Category],
       [Sub_Category],
       sum(sales) TotalRevenue,
       sum(profit) TotalProfit,
       sum(quantity) TotalQuantity
FROM [dbo].[raw_sales_order] o
INNER JOIN [dbo].[vw_Sales_Product_Clean] p ON o.Product_ID = p.Product_ID 
GROUP  BY o.[Product_ID],
          [Product_Name],
          [Category],
          [Sub_Category]
ORDER BY TotalRevenue DESC,
         TotalProfit DESC,
         TotalQuantity DESC 
         

-- Customer performance analysis
---------------------------------

SELECT o.[Customer_ID],
       [Customer_Name],
       [Segment],
       sum(sales) TotalRevenue,
       sum(profit) TotalProfit,
       sum(quantity) TotalQuantity
FROM [dbo].[raw_sales_order] o
INNER JOIN [dbo].[raw_sales_customer] c ON o.customer_ID = c.customer_ID 
GROUP  BY o.[Customer_ID],
          [Customer_Name],
          [Segment]
ORDER BY TotalRevenue DESC,
         TotalProfit DESC,
         TotalQuantity DESC 
         

-- Average Sales Value per Customer
------------------------------------

SELECT o.[Customer_ID],
       [Customer_Name],
       avg(sales) AvgSales
FROM [dbo].[raw_sales_order] o
INNER JOIN [dbo].[raw_sales_customer] c ON o.customer_ID = c.customer_ID
GROUP BY o.[Customer_ID],
         [Customer_Name]
ORDER BY AvgSales DESC 


-- Profitability Analysis by Discount Status
---------------------------------------------

SELECT 
       CASE
           WHEN discount = 0 THEN 'Non-discounted'
           ELSE 'Discounted'
       END AS DiscountStatus,
       sum(sales) TotalRevenue,
       sum(profit) TotalProfit
FROM [dbo].[raw_sales_order]
GROUP BY 
       CASE
           WHEN discount = 0 THEN 'Non-discounted'
           ELSE 'Discounted'
         END 
         

-- Top 10 products by revenue
------------------------------

SELECT top 10 [Product_Name],
           sum([Sales]) TotalRevenue
FROM [dbo].[raw_sales_order] o
INNER JOIN [dbo].[vw_Sales_Product_Clean] p ON o.Product_ID = p.product_ID
GROUP BY [Product_Name]
ORDER BY TotalRevenue DESC




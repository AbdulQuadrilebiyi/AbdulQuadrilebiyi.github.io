

-- Orion Global Retail — Supply Chain Performance & Enterprise Sales Analytics


-- SECTION 1: Data Quality Checks

-- Checking for Missing Order IDs (Primary Key Validation)
-----------------------------------------------------------

SELECT [Order_ID],
	   [Customer_ID],
	   [Product_ID],
	   [Ship_Date],
	   [Sales],
       [Quantity],
       [Discount],
       [Profit],
       [Country],
	   [Postal_Code]
FROM [dbo].[raw_sales_order]
WHERE [Order_ID] IS NULL


-- Checking for Missing Customer IDs (Customer Dimension Key Validation)
-------------------------------------------------------------------------

SELECT [Customer_ID],
	   [Customer_Name],
	   [Segment],
	   [Country],
	   [Region]
FROM [dbo].[raw_sales_customer]
WHERE [Customer_ID] IS NULL


-- Checking for Missing Product IDs (Product Dimension Key Validation)
-----------------------------------------------------------------------

SELECT [Product_ID],
	   [Product_Name],
	   [Category],
	   [Sub_Category]
FROM [dbo].[raw_sales_product]
WHERE [Product_ID] IS NULL


-- Checking for Missing Customer IDs in Orders (Foreign Key Validation)
------------------------------------------------------------------------

SELECT [Order_ID],
	   [Customer_ID],
	   [Product_ID],
	   [Ship_Date],
	   [Sales],
       [Quantity],
       [Discount],
       [Profit],
       [Country]
FROM [dbo].[raw_sales_order]
WHERE [Customer_ID] IS NULL


-- Checking for Missing Product IDs in Orders (Foreign Key Validation)
-----------------------------------------------------------------------

SELECT [Order_ID],
	   [Customer_ID],
	   [Product_ID],
	   [Ship_Date],
	   [Sales],
       [Quantity],
       [Discount],
       [Profit],
       [Country]
FROM [dbo].[raw_sales_order]
WHERE [Product_ID] IS NULL


-- Checking For Duplicate Order_IDs
------------------------------------

SELECT [Order_ID],
       COUNT(*)
FROM [dbo].[raw_sales_order]
GROUP BY [Order_ID]
HAVING COUNT(*) > 1


-- Checking for Duplicate Order Line Items (Full Row Duplication Check)
------------------------------------------------------------------------

SELECT [Order_ID],
	   [Customer_ID],
	   [Product_ID],
	   [Ship_Date],
	   [Sales],
       [Quantity],
       [Discount],
       [Profit],
       [Country],
       [Market],
       COUNT(*)
FROM [dbo].[raw_sales_order]
GROUP BY [Order_ID],
         [Customer_ID],
	     [Product_ID],
	     [Ship_Date],
	     [Sales],
         [Quantity],
         [Discount],
         [Profit],
         [Country],
         [Market]
HAVING COUNT(*) > 1


-- Creating Clean Orders View (Deduplicated Line Items for Reporting)
----------------------------------------------------------------------

CREATE VIEW vw_Sales_Order_Clean AS
WITH Order_Dedup AS (
SELECT [Order_ID],
	   [Customer_ID],
	   [Product_ID],
       [Order_Date],
	   [Ship_Date],
       [Ship_Mode],
	   [Sales],
       [Quantity],
       [Discount],
       [Profit],
       [Country],
       [Region],
       [State],
       [City],
       [Market],
       ROW_NUMBER() OVER(
                        PARTITION BY [Order_ID],
	                                 [Customer_ID],
	                                 [Product_ID],
                                     [Order_Date],
	                                 [Ship_Date],
                                     [Ship_Mode],
	                                 [Sales],
                                     [Quantity],
                                     [Discount],
                                     [Profit],
                                     [Country],
                                     [Region],
                                     [State],
                                     [City],
                                     [Market]
                        ORDER BY ([Order_ID]) 
                         )Cnt_Duplicate
FROM [dbo].[raw_sales_order])

SELECT [Order_ID],
	   [Customer_ID],
	   [Product_ID],
       [Order_Date],
	   [Ship_Date],
       [Ship_Mode],
	   [Sales],
       [Quantity],
       [Discount],
       [Profit],
       [Country],
       [Region],
       [State],
       [City],
       [Market]
FROM Order_Dedup
WHERE Cnt_Duplicate = 1
GO

-- Checking For Duplicate Customer_IDs
---------------------------------------

SELECT [Customer_ID],
       COUNT(*)
FROM [dbo].[raw_sales_customer]
GROUP BY [Customer_ID]
HAVING COUNT(*) > 1


-- Checking For Duplicate Customer Records
-------------------------------------------

SELECT [Customer_ID],
       [Customer_Name],
       [Segment],
       [Country],
       [Region],
       COUNT(*) as cnt
FROM [dbo].[raw_sales_customer]
GROUP BY [Customer_ID],
         [Customer_Name],
         [Segment],
         [Country],
         [Region]
HAVING COUNT(*) > 1


-- Creating Clean Customers View (Deduplicated Customer Dimension)
-------------------------------------------------------------------

CREATE VIEW vw_Sales_Customer_Clean AS
WITH Customer_Dedup AS (
SELECT [Customer_ID],
       [Customer_Name],
       [Segment],
       [Country],
       [Region],
       ROW_NUMBER() OVER(
                        PARTITION BY [Customer_ID]
                        ORDER BY ([Customer_ID])
                        ) AS Cnt_Duplicate
FROM [dbo].[raw_sales_customer])

SELECT [Customer_ID],
       [Customer_Name],
       [Segment],
       [Country],
       [Region]
FROM Customer_Dedup
WHERE Cnt_Duplicate = 1
GO


-- Checking For Duplicate Product IDs
--------------------------------------

SELECT [Product_ID],
       COUNT(*)
FROM [dbo].[raw_sales_product]
GROUP BY [Product_ID]
HAVING COUNT(*) > 1


-- Checking For Duplicate Product Records
------------------------------------------

SELECT [Product_ID],
       [Product_Name],
       [Category],
       [Sub_Category],
       COUNT(*)
FROM [dbo].[raw_sales_product]
GROUP BY [Product_ID],
         [Product_Name],
         [Category],
         [Sub_Category]
HAVING COUNT(*) > 1


-- Creating Clean Products View (Deduplicated Product Dimension)
-----------------------------------------------------------------

CREATE VIEW vw_Sales_Product_Clean AS
WITH Product_Dedup AS (
SELECT [Product_ID],
       [Product_Name],
       [Category],
       [Sub_Category],
       ROW_NUMBER() OVER(PARTITION BY [Product_ID]
                         ORDER BY ([Product_ID])
                         ) AS Cnt_Duplicate
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
       [City]
FROM [dbo].[raw_sales_order]
WHERE sales < 0


-- Checking for Negative Profit Values (Loss Transactions Identification)
--------------------------------------------------------------------------

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


-- Checking for Invalid Quantity Values (Zero/Negative Quantity Check)
-----------------------------------------------------------------------

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

-- Data Modeling Preview (Join Structure Check)
---------------------------------------------------

SELECT *
FROM [dbo].[vw_Sales_Order_Clean] AS o
LEFT JOIN [dbo].[vw_Sales_Customer_Clean] AS c
ON o.Customer_ID = c.Customer_ID

SELECT *
FROM [dbo].[vw_Sales_Order_Clean] AS o
LEFT JOIN [dbo].[vw_Sales_Product_Clean] AS p
ON o.Product_ID = p.Product_ID


-- Validate Orders > Customers (Orphan Customer Key Check)
-----------------------------------------------------------

SELECT o.[Order_ID],
       o.[Customer_ID],
       c.[Customer_Name],
       c.[Segment],
       o.[Country]
FROM [dbo].[vw_Sales_Order_Clean] AS o
LEFT JOIN [dbo].[vw_Sales_Customer_Clean] AS c
ON o.Customer_ID = c.Customer_ID
WHERE o.Customer_ID IS NOT NULL
AND c.Customer_ID IS NULL


-- Validate Orders > Products (Orphan Product Key Check)
---------------------------------------------------------

SELECT o.[Order_ID],
       o.[Product_ID],
       p.[Product_Name],
       p.[Category],
       p.[Sub_Category]
FROM [dbo].[vw_Sales_Order_Clean] AS o
LEFT JOIN [dbo].[vw_Sales_Product_Clean] AS p
ON o.Product_ID = p.Product_ID
WHERE o.Product_ID IS NOT NULL
AND p.Product_ID IS NULL





-- SECTION 3: Business Rules & Supply Chain Logic

-- Supply Chain KPI: Delivery Lead Time (Days)
---------------------------------------------------

SELECT o.[Order_ID], 
       o.[Order_Date], 
       o.[Ship_Date], 
       o.[Ship_Mode], 
       o.[Customer_ID], 
       o.[Product_ID], 
       o.[Sales], 
       o.[Quantity], 
       o.[Discount], 
       o.[Profit],
       DATEDIFF(DAY, [Order_Date], [Ship_Date]) AS LeadTimeDays
FROM [dbo].[vw_Sales_Order_Clean] AS o
INNER JOIN [dbo].[vw_Sales_Customer_Clean] AS c
ON o.Customer_ID = c.Customer_ID
INNER JOIN [dbo].[vw_Sales_Product_Clean] AS p
ON o.Product_ID = p.Product_ID


-- Delivery Speed Classification (Fast / Standard / Slow)
----------------------------------------------------------

WITH Speed_Category AS (
SELECT o.[Order_ID], 
       o.[Order_Date], 
       o.[Ship_Date], 
       o.[Ship_Mode], 
       o.[Customer_ID], 
       o.[Product_ID], 
       o.[Sales], 
       o.[Quantity], 
       o.[Discount], 
       o.[Profit],
       DATEDIFF(DAY, [Order_Date], [Ship_Date]) AS LeadTimeDays
FROM [dbo].[vw_Sales_Order_Clean] AS o
INNER JOIN [dbo].[vw_Sales_Customer_Clean] AS c
ON o.Customer_ID = c.Customer_ID
INNER JOIN [dbo].[vw_Sales_Product_Clean] AS p
ON o.Product_ID = p.Product_ID)

SELECT *,
     CASE
            WHEN LeadTimeDays <= 2 THEN 'Fast'
            WHEN LeadTimeDays BETWEEN 3 AND 5 THEN 'Standard'
            ELSE 'Slow'
       END AS DeliverySpeedCategory
FROM Speed_Category


-- On-Time vs Delayed Flag
---------------------------

WITH Time_Diff AS (
SELECT o.[Order_ID], 
       o.[Order_Date], 
       o.[Ship_Date], 
       o.[Ship_Mode], 
       o.[Customer_ID], 
       o.[Product_ID], 
       o.[Sales], 
       o.[Quantity], 
       o.[Discount], 
       o.[Profit],
       DATEDIFF(DAY, [Order_Date], [Ship_Date]) AS LeadTimeDays
FROM [dbo].[vw_Sales_Order_Clean] AS o
INNER JOIN [dbo].[vw_Sales_Customer_Clean] AS c
ON o.Customer_ID = c.Customer_ID
INNER JOIN [dbo].[vw_Sales_Product_Clean] AS p
ON o.Product_ID = p.Product_ID)

SELECT *,
     CASE
            WHEN LeadTimeDays <= 5 THEN 'On-Time'
            ELSE 'Delayed'
     END AS DeliveryTimeCategory
FROM Time_Diff


-- Commercial Flag: Discounted vs Non-Discounted
--------------------------------------------------

SELECT [Order_ID], 
       [Order_Date], 
       [Customer_ID], 
       o.[Product_ID], 
       [Product_Name],
       [Category],
       [Sub_Category],
       [Sales], 
       [Quantity], 
       [Profit],
       [Discount], 
       CASE
            WHEN Discount <= 0 THEN 'Non_Discounted'
            ELSE 'Discounted'
       END AS DiscountStatus
FROM [dbo].[vw_Sales_Order_Clean] AS o
INNER JOIN [dbo].[vw_Sales_Product_Clean] AS p
ON o.Product_ID = p.Product_ID


-- Profitability Classification (Profitable / Loss / Break-even)
-----------------------------------------------------------------

SELECT [Order_ID], 
       [Order_Date], 
       [Customer_ID], 
       o.[Product_ID], 
       [Product_Name],
       [Category],
       [Sub_Category],
       [Sales], 
       [Quantity], 
       [Discount],
       [Profit], 
       CASE
           WHEN profit < 0 THEN 'Loss-Making'
           WHEN profit > 0 THEN 'Profitable'
           ELSE 'Break-even'
       END AS Profit_Status
FROM [dbo].[vw_Sales_Order_Clean] AS o
INNER JOIN [dbo].[vw_Sales_Product_Clean] AS p
ON o.Product_ID = p.Product_ID


-- Order Quantity Size Category (Small / Medium / Large)
---------------------------------------------------------

SELECT [Order_ID], 
       [Order_Date], 
       [Customer_ID], 
       o.[Product_ID], 
       [Product_Name],
       [Category],
       [Sub_Category],
       [Sales], 
       [Discount],
       [Profit],
       [Quantity],
       CASE
           WHEN quantity <= 2 THEN 'Small'
           WHEN quantity BETWEEN 3 AND 5 THEN 'Medium'
           ELSE 'Large'
       END AS Size_Status
FROM [dbo].[vw_Sales_Order_Clean] AS o
INNER JOIN [dbo].[vw_Sales_Product_Clean] AS p
ON o.Product_ID = p.Product_ID


-- Combined Enriched Dataset (Supply Chain + Commercial Flags)
---------------------------------------------------------------

WITH Business_Logic AS(
SELECT o.[Order_ID], 
       o.[Order_Date], 
       o.[Ship_Date], 
       o.[Ship_Mode], 
       o.[Customer_ID], 
       o.[Product_ID], 
       p.[Product_Name],
       p.[Category],
       p.[Sub_Category],
       o.[Sales], 
       o.[Quantity], 
       o.[Discount], 
       o.[Profit],
       DATEDIFF(DAY, [Order_Date], [Ship_Date]) AS LeadTimeDays
FROM [dbo].[vw_Sales_Order_Clean] AS o
INNER JOIN [dbo].[vw_Sales_Customer_Clean] AS c
ON o.Customer_ID = c.Customer_ID
INNER JOIN [dbo].[vw_Sales_Product_Clean] AS p
ON o.Product_ID = p.Product_ID)

SELECT *,
        CASE
            WHEN LeadTimeDays <= 2 THEN 'Fast'
            WHEN LeadTimeDays BETWEEN 3 AND 5 THEN 'Standard'
            ELSE 'Slow'
        END AS DeliverySpeedCategory,
        CASE
            WHEN LeadTimeDays <= 5 THEN 'On-Time'
            ELSE 'Delayed'
        END AS DeliveryTimeCategory,
        CASE
            WHEN Discount <= 0 THEN 'Non_Discounted'
            ELSE 'Discounted'
        END AS DiscountStatus,
        CASE
           WHEN profit < 0 THEN 'Loss-Making'
           WHEN profit > 0 THEN 'Profitable'
           ELSE 'Break-even'
        END AS Profit_Status,
        CASE
           WHEN quantity <= 2 THEN 'Small'
           WHEN quantity BETWEEN 3 AND 5 THEN 'Medium'
           ELSE 'Large'
        END AS Size_Status
FROM Business_Logic





-- SECTION 4: Aggregations & Business Insights

-- Executive KPIs — Sales Overview
-----------------------------------------------

SELECT SUM([Sales]) AS TotalRevenue,
       SUM([Profit]) AS TotalProfit,
       SUM([Quantity]) AS TotalQuantity,
       COUNT(DISTINCT [Order_ID]) AS TotalOrders
FROM [dbo].[vw_Sales_Order_Clean]


-- Monthly Revenue & Profit Trend
----------------------------------

SELECT DATENAME(YEAR,[Order_Date]) AS Year,
       MONTH([Order_Date]) AS MonthNumber,
       DATENAME(MONTH,[Order_Date]) AS Month,
       SUM([Sales]) AS TotalRevenue,
       SUM([Profit]) AS TotalProfit
FROM [dbo].[vw_Sales_Order_Clean]
GROUP BY DATENAME(MONTH,[Order_Date]),
         DATENAME(YEAR,[Order_Date]),
         MONTH([Order_Date])
ORDER BY Year, MonthNumber


-- Supply Chain KPI — Average Lead Time (Days)
-----------------------------------------------

SELECT AVG(DATEDIFF(DAY, [Order_Date], [Ship_Date])) AS AvgLeadTimeDays
FROM [dbo].[vw_Sales_Order_Clean]


-- Supply Chain Performance by Ship Mode
-----------------------------------------

SELECT [Ship_Mode],
       SUM([Sales]) AS TotalRevenue,
       SUM([Profit]) AS TotalProfit,
       SUM([Quantity]) AS TotalQuantity,
       AVG(DATEDIFF(DAY, [Order_Date], [Ship_Date])) AS AvgLeadTimeDays,
       COUNT(DISTINCT [Order_ID]) AS TotalOrders
FROM [dbo].[vw_Sales_Order_Clean]
GROUP BY [Ship_Mode]


-- Delivery Speed Category Summary (Fast/Standard/Slow)
--------------------------------------------------------

WITH Category_Summary AS (
SELECT  DATEDIFF(DAY, [Order_Date], [Ship_Date]) AS LeadTimeDays
FROM [dbo].[vw_Sales_Order_Clean])

SELECT 
        CASE
            WHEN LeadTimeDays <= 2 THEN 'Fast'
            WHEN LeadTimeDays BETWEEN 3 AND 5 THEN 'Standard'
            ELSE 'Slow'
        END AS DeliverySpeedCategory,
        COUNT(LeadTimeDays) AS Cnt_Speed
FROM Category_Summary
GROUP BY CASE
            WHEN LeadTimeDays <= 2 THEN 'Fast'
            WHEN LeadTimeDays BETWEEN 3 AND 5 THEN 'Standard'
            ELSE 'Slow'
         END
ORDER BY Cnt_Speed DESC


-- On-Time vs Delayed Orders (Threshold = 5 Days)
--------------------------------------------------

WITH OnTime_Delayed_Orders AS (
SELECT  DATEDIFF(DAY, [Order_Date], [Ship_Date]) AS LeadTimeDays
FROM [dbo].[vw_Sales_Order_Clean])

SELECT  
        CASE
            WHEN LeadTimeDays <= 5 THEN 'On-Time'
            ELSE 'Delayed'
        END AS DeliveryTimeCategory,
        COUNT(LeadTimeDays) AS Cnt_Time
FROM OnTime_Delayed_Orders
GROUP BY CASE
            WHEN LeadTimeDays <= 5 THEN 'On-Time'
            ELSE 'Delayed'
         END
ORDER BY Cnt_Time DESC


-- Discount Impact — Revenue & Profit by Discount Flag
-------------------------------------------------------

SELECT 
        CASE
            WHEN Discount <= 0 THEN 'Non_Discounted'
            ELSE 'Discounted'
        END AS DiscountStatus,
        SUM([Sales]) AS TotalRevenue,
        SUM([Profit]) AS TotalProfit
FROM [dbo].[vw_Sales_Order_Clean]
GROUP BY  CASE
            WHEN Discount <= 0 THEN 'Non_Discounted'
            ELSE 'Discounted'
          END


-- Product Category Performance (Revenue/Profit/Qty)
-----------------------------------------------------

SELECT p.[Category],
       p.[Sub_Category],
       SUM([Sales]) AS TotalRevenue,
       SUM([Profit]) AS TotalProfit,
       SUM([Quantity]) AS TotalQuantity
FROM [dbo].[vw_Sales_Order_Clean] AS o
INNER JOIN [dbo].[vw_Sales_Product_Clean] AS p
ON o.Product_ID = p.Product_ID
GROUP BY p.[Category],
         p.[Sub_Category]
ORDER BY [Category], [Sub_Category]


-- Top 10 Products by Revenue
------------------------------

SELECT TOP 10 p.[Product_Name],
              SUM([Sales]) AS TotalRevenue
FROM [dbo].[vw_Sales_Order_Clean] AS o
INNER JOIN [dbo].[vw_Sales_Product_Clean] AS p
ON o.Product_ID = p.Product_ID
GROUP BY p.[Product_Name]
ORDER BY TotalRevenue DESC


-- Customer Segment Performance
--------------------------------

SELECT c.[Segment],
       SUM([Sales]) AS TotalRevenue,
       SUM([Profit]) AS TotalProfit
FROM [dbo].[vw_Sales_Order_Clean] AS o
INNER JOIN [dbo].[vw_Sales_Customer_Clean] AS c
ON o.Customer_ID = c.Customer_ID
GROUP BY c.[Segment]
ORDER BY TotalRevenue DESC, TotalProfit DESC


-- Top 10 Customers by Revenue
-------------------------------

SELECT TOP 10 c.[Customer_Name],
              SUM([Sales]) AS TotalRevenue
FROM [dbo].[vw_Sales_Order_Clean] AS o
INNER JOIN [dbo].[vw_Sales_Customer_Clean] AS c
ON o.Customer_ID = c.Customer_ID
GROUP BY c.[Customer_Name]
ORDER BY TotalRevenue DESC


-- Revenue by Country/Region
-----------------------------

SELECT [Country],
       [Region],
       SUM([Sales]) AS TotalRevenue
FROM [dbo].[vw_Sales_Order_Clean]
GROUP BY [Country],
         [Region]
ORDER BY TotalRevenue DESC







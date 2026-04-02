# Data Analytics Portfolio
# Project 1

**Title:** 

# Orion Global Retail — Supply Chain & Sales Performance Dashboard

**Tools:** SQL Server | Power BI

[Orion Global Retail — Supply Chain & Sales Performance Dashboard](https://github.com/AbdulQuadrilebiyi/AbdulQuadrilebiyi.github.io/blob/main/Orion%20Global%20Retail_Dashboard.pbix)

**Purpose:**
To build an end-to-end business intelligence solution providing 
visibility into global supply chain performance, sales trends 
and profitability across regions, shipping modes and product categories.

**Business Problem:**
The business had raw transactional data with no structured way 
to monitor delivery performance, revenue trends or profitability. 
Key questions included which shipping modes cause delays, which 
regions and products drive the most revenue, and how discounting 
impacts profit.

**Approach:**
- Imported raw Excel data into SQL Server and performed full 
  data quality checks — null validation, duplicate detection 
  and foreign key integrity across orders, customers and products
- Used CTEs, JOINs and CASE statements to clean, deduplicate 
  and apply business logic — delivery lead times, on-time vs 
  delayed classification, discount flags and profitability status
- Imported clean views into Power BI, verified data integrity 
  and built a star schema — orders as the central fact table 
  connected to customers, products and a Calendar table
- Created DAX measures including Total Revenue, Total Profit, 
  On-Time Orders, Avg Lead Time, Profit Margin % and 
  Month-over-Month Revenue
- Designed an interactive dashboard with KPI cards, trend charts, 
  delivery performance visuals, category analysis and dynamic slicers

**Outcome:**
- Dashboard reveals overall revenue and profit performance 
  across all regions and time periods at a glance
- Over 80% of orders are delivered on time globally with 
  clear visibility into delayed shipments by region
- Standard Class shipping consistently shows the highest 
  average lead time compared to all other shipping modes
- Technology leads all product categories in revenue 
  generation followed closely by Furniture
- Top 5 customers are ranked by both revenue and profit 
  enabling targeted account management decisions

**Recommendations:**
- Review Standard Class shipping strategy to reduce lead 
  times and improve overall delivery performance
- Prioritise Technology and Furniture for inventory and 
  sales investment as they drive the highest revenue
- Reduce heavy discounting on low margin products to 
  protect overall profitability across all regions

**Tech Stack:**
- SQL Server — CTEs, JOINs, CASE statements, data quality 
  checks and clean view creation
- Power BI — star schema modelling, DAX measures, Calendar 
  table and interactive dashboard design

📥 [Download Power BI File (.pbix)](Orion_Global_Retail_Dashboard.pbix)

📄 [View SQL Script (.sql)](OrionGlobalRetail.sql)

# Data Analytics Portfolio
# Project 1

**Title: [Orion Global Retail - Supply Chain & Sales Performance Dashboard](https://github.com/AbdulQuadrilebiyi/AbdulQuadrilebiyi.github.io/blob/main/Orion%20Global%20Retail_Dashboard.pbix)**

**Tools:** SQL Server, Power BI

![Orion Global Retail - Supply Chain & Sales Performance Dashboard](SCREEN1.PNG)

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
  data quality checks, null validation, duplicate detection 
  and foreign key integrity across orders, customers and products
- Used CTEs, JOINs and CASE statements to clean, deduplicate 
  and apply business logic, delivery lead times, on-time vs 
  delayed classification, discount flags and profitability status
- Imported clean views into Power BI, verified data integrity 
  and built a star schema, orders as the central fact table 
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
- SQL Server - CTEs, Window Functions, JOINs, CASE statements,
  data quality checks and clean view creation
- Power BI - DAX measures, KPI cards, star schema data modelling
  with one-to-many relationships, calculated column, Calendar
  table, slicers and interactive dashboard design

[Download Power BI File (.pbix)](https://github.com/AbdulQuadrilebiyi/AbdulQuadrilebiyi.github.io/blob/main/Orion%20Global%20Retail_Dashboard.pbix) | [View SQL Script (.sql)](OrionRetail.sql)

















# Project 2

**Title: [Atlas Retail - Sales & Profitability Analytics Dashboard](https://github.com/AbdulQuadrilebiyi/AbdulQuadrilebiyi.github.io/blob/main/Atlas%20Retail_Dashboard.pbix)**

**Tools:** SQL Server, Power BI

![Orion Global Retail - Supply Chain & Sales Performance Dashboard](SCREEN2.PNG)

**Purpose:**

To build an end-to-end business intelligence solution that 
transforms raw retail sales data into actionable insights 
on revenue performance, profitability trends and customer 
behaviour across regions, product categories and segments.

**Business Problem:**

The business had raw transactional sales data with no structured 
way to monitor profitability, track revenue trends or understand 
the impact of discounting on overall performance. Key questions 
included which product categories and regions drive the most 
revenue, how discounting affects profit and which customer 
segments are most valuable.

**Approach:**

- Imported raw Excel data into SQL Server and performed full
  data quality checks — null validation, duplicate detection
  and negative value identification across orders, customers
  and products
- Used CTEs, Window Functions including ROW_NUMBER() and RANK(),
  INNER JOINs and CASE statements to clean, deduplicate and
  apply business logic — discount status, profitability
  classification and revenue ranking
- Imported data into Power BI, verified integrity and built
  a star schema — raw_sales_order as the central fact table
  connected to customers, products and a Calendar table
- Created DAX measures including Total Revenue, Total Profit,
  Profit Margin %, Average Order Value, Revenue MoM %,
  Profit MoM % and Last Month Revenue and Profit
- Designed interactive dashboard with KPI cards, trend charts,
  regional and category performance visuals and dynamic slicers

**Outcome:**

- Dashboard provides clear visibility into overall revenue
  and profitability performance across all regions and periods
- Technology is consistently the highest revenue and profit
  generating category followed by Furniture
- West region leads all regions in total revenue generation
- Discounted orders represent a higher volume than
  non-discounted orders indicating heavy discount dependency
- Profit Margin % and Month-over-Month trends give management
  clear signals for performance monitoring and planning

**Recommendations:**

- Review discounting strategy as high discount volume is
  likely suppressing overall profit margins
- Prioritise investment in Technology and Furniture categories
  as they consistently drive the highest revenue and profit
- Focus sales efforts on the West and East regions which
  show the strongest revenue performance
- Monitor Profit MoM % trends closely to detect and respond
  to early signs of revenue or margin decline

**Tech Stack:**

- SQL Server — CTEs, Window Functions including ROW_NUMBER()
  and RANK(), INNER and LEFT JOINs, CASE statements,
  data quality checks and clean view creation
- Power BI — DAX measures, KPI cards, star schema data
  modelling with one-to-many relationships, calculated
  columns, Calendar table, slicers and interactive
  dashboard design

[Download Power BI File (.pbix)](https://github.com/AbdulQuadrilebiyi/AbdulQuadrilebiyi.github.io/blob/main/Atlas%20Retail_Dashboard.pbix)) | [View SQL Script (.sql)](AtlasRetail.sql)

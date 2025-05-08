# Inventory Optimization with SQL

This project showcases an end-to-end inventory analysis and optimization workflow using Microsoft SQL Server. It focuses on deriving actionable insights from transactional data (sales), master data (products), and inventory records using advanced SQL techniques.

## Objective

- Calculate total units sold and revenue per product
- Generate month-wise sales summaries
- Use rolling 3-month average to understand product demand
- Recommend reorder decisions based on average demand
- Rank top products by revenue within each category

## Datasets

1. products.csv  
   - Contains product_id, name, category, supplier_id, and unit price

2. sales.csv  
   - Contains sales transactions: product_id, sale_date, quantity, region, and channel

3. inventory.csv  
   - Includes current stock, warehouse info, and restock timelines per product

## Techniques Used

- Joins across multiple tables  
- CTEs (Common Table Expressions) for logical clarity  
- Window functions (AVG() OVER, RANK() OVER) for rolling metrics and rankings  
- Data type casting and format cleaning for string-number compatibility  
- CASE logic to automate reorder tagging

## Key SQL Queries

- View total records and sample data  
- Total units sold and revenue per product  
- Join sales with product master for full view  
- Monthly sales breakdown using FORMAT()  
- 3-month rolling average with windowing  
- Reorder suggestion based on average demand multiplied by 7  
- Top 5 products by revenue per category using RANK() OVER

## How to Use

1. Load all .csv files into your SQL Server using BULK INSERT or Import Wizard.  
2. Ensure all product_id formats match (e.g., P0093).  
3. Run the SQL queries in the order provided (sql_inventory_queries.sql).  
4. Optionally, visualize outputs in Power BI or Excel.

## Potential Extensions

- Integrate supplier lead time for smarter reorder suggestions  
- Add safety stock buffers per product type  
- Include outlier detection for seasonal spikes  
- Build Power BI dashboards for real-time monitoring

## Author

Akshay Prajapati  
Data and Business Analytics | Power BI, SQL, Python  
https://www.linkedin.com/in/akshay-prajapati-888668122

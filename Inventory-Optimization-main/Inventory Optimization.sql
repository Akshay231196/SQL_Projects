-- STEP 1: View raw sales data
SELECT TOP 10 *
FROM sales;

-- STEP 2: Count total records
SELECT COUNT(*) AS total_sales_records
FROM sales;


-- STEP 3: Total units sold overall
SELECT SUM(quantity_sold) AS total_units_sold
FROM sales;

-- STEP 4: Total units sold by product
SELECT 
    product_id,
    SUM(quantity_sold) AS total_units_sold
FROM sales
GROUP BY product_id
ORDER BY total_units_sold DESC;

-- STEP 5: Total revenue by product
SELECT 
    product_id,
    round(SUM(quantity_sold * sale_price),2) AS total_revenue
FROM sales
GROUP BY product_id
ORDER BY total_revenue DESC;


-- STEP 6: Join sales with product details
SELECT 
    s.product_id,
    p.product_name,
    p.category,
    SUM(s.quantity_sold) AS total_units_sold,
    ROUND(SUM(s.quantity_sold * s.sale_price), 2) AS total_revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY s.product_id, p.product_name, p.category
ORDER BY total_units_sold DESC;



-- STEP 7: Monthly sales per product
SELECT 
    product_id,
    FORMAT(sale_date, 'yyyy-MM') AS sale_month,
    SUM(quantity_sold) AS monthly_units_sold
FROM sales
GROUP BY product_id, FORMAT(sale_date, 'yyyy-MM')
ORDER BY product_id, sale_month;



-- STEP 8: Rolling 3-month average demand using CTE and window function
WITH MonthlySales AS (
    SELECT 
        product_id,
        FORMAT(sale_date, 'yyyy-MM') AS sale_month,
        SUM(quantity_sold) AS monthly_units_sold
    FROM sales
    GROUP BY product_id, FORMAT(sale_date, 'yyyy-MM')
)
SELECT 
    product_id,
    sale_month,
    monthly_units_sold,
    ROUND(AVG(CAST(monthly_units_sold AS FLOAT)) OVER (
        PARTITION BY product_id
        ORDER BY sale_month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_3_month_avg
FROM MonthlySales;




-- STEP 9: Reorder suggestion based on average demand

SELECT DISTINCT product_id FROM sales ORDER BY product_id;
SELECT DISTINCT product_id FROM inventory ORDER BY product_id;

WITH AverageDemand AS (
    SELECT 
        'P' + RIGHT('0000' + CAST(product_id AS VARCHAR(4)), 4) AS product_id,
        ROUND(AVG(CAST(quantity_sold AS FLOAT)), 2) AS avg_daily_demand
    FROM sales
    GROUP BY product_id
)
SELECT 
    i.product_id,
    i.current_stock,
    a.avg_daily_demand,
    CASE 
        WHEN i.current_stock < a.avg_daily_demand * 7 THEN 'REORDER'
        ELSE 'STOCK OK'
    END AS reorder_status
FROM inventory i
JOIN AverageDemand a ON i.product_id = a.product_id;



-- STEP 10: Top 5 selling products by revenue in each category
WITH ProductRevenue AS (
    SELECT 
        s.product_id,
        p.category,
        round(SUM(s.quantity_sold * s.sale_price),2) AS total_revenue
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    GROUP BY s.product_id, p.category
),
RankedRevenue AS (
    SELECT *,
           RANK() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS rank_within_category
    FROM ProductRevenue
)
SELECT *
FROM RankedRevenue
WHERE rank_within_category <= 5;

---SQL Retail Sales Database - P1
Create Database SQL_Project_P2;

-- Create Table 
Drop Table if exists Retail_Sales;
Create Table Retail_sales(transactions_id INT Primary key, sale_date DATE, sale_time TIME, customer_id INT, gender VARCHAR(15), age INT	, category VARCHAR(30)	, quantiy INT, price_per_unit FLOAT, cogs FLOAT, total_sale FLOAT);

Select * From Retail_Sales
Limit 10;

Select count(*) From Retail_Sales;

Select * From Retail_Sales
where transactions_id is null 
or sale_date is null 
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null

Delete from retail_sales
where transactions_id is null 
or sale_date is null 
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null

----Data Exploration
---How many sales do we have ?
Select count(*) as total_Sales from retail_sales

---How many customers do we have it?
Select count(Distinct(Customer_id)) as Unique_Customers from retail_sales

---How many categories do we have it?
Select Distinct(category) as Total_Categories from retail_sales

--- Data Analysis & Business Key Problems and Answers
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

select * from retail_sales
where sale_date = '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--     and the quantity sold is more than 10 in the month of Nov-2022

select * from retail_sales
where To_char(sale_date,'yyyy-mm') = '2022-11' and category ='Clothing' and Quantiy >= 4


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category

Select category, sum(total_sale) as Total_sales 
from retail_sales
group by category

-- Q.4 Write a SQL query to find the average age of customers who purchased items 
--     from the 'Beauty' category

select Customer_id, round(Avg(age),2) as avg_age 
from retail_sales
where category = 'Beauty'
group by customer_id

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000

select * from retail_sales
where total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) 
--     made by each gender in each category

select gender,category, sum(transactions_id) as Total_Transaction_Ids 
from retail_sales
group by gender, category

-- Q.7 Write a SQL query to calculate the average sale for each month. 
--     Find out best selling month in each year

with retail_summary as(
Select extract (year from sale_date) as Selling_year,extract (month from sale_date) as Selling_Month, Round(Avg(total_sale)) as Average_sale , Dense_rank() over( partition by extract (year from sale_date) order by Round(Avg(total_sale)) DESC ) as Dr 
from retail_sales
group by 1,2)
select * from retail_summary
where dr =1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

Select customer_id, Sum(total_sale) as Total_Sales from retail_sales
group by customer_id
order by Sum(total_sale) Desc
limit 5


-- Q.9 Write a SQL query to find the number of unique customers 
--     who purchased items from each category

select category, count(Distinct(Customer_id)) as unique_customers
from retail_sales
group by category

-- Q.10 Write a SQL query to create each shift and number of orders 
--      (Example: Morning <=12, Afternoon Between 12 & 17, Evening >17)

SELECT 
  CASE 
    WHEN sale_time::time < '12:00:00' THEN 'Morning'
    WHEN sale_time::time >= '12:00:00' AND sale_time::time <= '17:00:00' THEN 'Afternoon'
    ELSE 'Evening'
  END AS Shift,
  COUNT(transactions_id) AS total_orders
FROM retail_sales
GROUP BY Shift;

----End of Project





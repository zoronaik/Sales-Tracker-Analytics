create database sales_analysis_data;
use sales_analysis_data;
drop database sales_analysis_data;

use sales_analysis_data;
drop table if exists sales_data;
create table sales_data (
order_id int,
product varchar(255),
quantity_ordered int,
price_each double,
order_date date,
purchase_address varchar(255),
months int,
sales double,
city varchar(255),
hour int
);

select * from sales_data;
   
select count(*)from sales_data;

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales data.csv' 
into table sales_data fields terminated by ','
 enclosed by '"' lines terminated by '\r\n' ignore 1 rows;
 
 select month from sales_data;
 
-- Retrieve all columns for orders with a quantity_ordered greater than 5
select quantity_ordered from sales_data
where quantity_ordered > 5;

-- Find the total sales for each product. 
select product, sum(sales) as total_sales, count(*) as total_orders from sales_data
group by product;

-- List the unique cities where purchases were made. 
select  distinct city from sales_data;

-- Calculate the average price for each product. 
select product, avg(price_each) from sales_data
group by product;

-- Identify the month with the highest total sales. 
select month, sum(sales) from sales_data
group by month
order by month desc limit 1;

-- Retrieve the orders made on a specific date. 
select order_id, product, order_date from sales_data
where order_date = '2019-05-28';

-- Find the top 5 products with the highest sales.
select product, sum(sales) from sales_data
group by product
order by product desc limit 5;

-- Determine the total sales for each city. 
select city, sum(sales) from sales_data
group by city;

-- Calculate the average quantity_ordered per month. 
select month, avg(quantity_ordered) as average_quantity_ordered_permonth from sales_data
group by month;

-- Retrieve the orders with a purchase_address containing the word 'Street'. 
select order_id, product from sales_data
where purchase_address = 'street' ;
-- OR
select purchase_address from sales_data
where purchase_address = 'street';

-- Retrieve the total sales and percentage contribution of each city to the overall sales. 
select city, sum(sales) / (select sum(sales) from sales_data) * 100 as total_percentage 
from sales_data
group by city;

-- Calculate the average quantity of products ordered per month.
select product, month, avg(quantity_ordered) as avg_quantity_ordered from sales_data
group by product, month;  

-- Identify the best-selling product in each city based on the total quantity ordered. 
 select city, max(product) as best_selling_product, sum(quantity_ordered) as total_quantity_ordered
from sales_data
group by city;

-- Determine the distribution of sales across different hours of the day.


-- Find the top 5 months with the highest total sales.
select month ,sum(sales) as highest_total_sales from sales_data
group by month 
order by month desc limit 5;

-- Calculate the average price and quantity ordered for each product. 
select product, avg(price_each) as average_price, avg(quantity_ordered) as average_quantity_ordered
from sales_data
group by product;

-- Calculate the monthly sales growth rate, indicating the percentage change in sales from the previous month.
    with monthlysales as (
    select month, sum(sales) as monthly_sales from sales_data
    group by month 
    ) 
    select a.month,
    a.monthly_sales, 
    (a.monthly_sales - b.monthly_sales) / b.monthly_sales * 100 as growth_rate
    from monthlysales a
    join monthlysales b on a.month = b.month + 1
     order by a.month;

-- Find distinct addresses where the number of orders is above a certain threshold, indicating frequent buyers. 
with addressordercounts as (
select purchase_address, count(distinct order_id) as order_count
from sales_data 
group by purchase_address
) 
select purchase_address from addressordercounts 
where order_count > 4;
       
       
    
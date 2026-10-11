DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);


select * from retail_sales;

-- data cleaning --
select * from retail_sales
where 
transactions_id is null
or
sale_date is null
or
sale_time is null
or
gender is null
or
category is null
or
quantity is null
or
cogs is null
or
total_sale is null;


delete from retail_sales
where

transactions_id is null
or
sale_date is null
or
sale_time is null
or
gender is null
or
category is null
or
quantity is null
or
cogs is null
or
total_sale is null;

-- how many sales do we have --

select count(*) as Total_Sales from retail_sales;

-- how many customers do we have --

select count(distinct(customer_id)) as ToTal_Customers from retail_sales;

-- Different Catogeries in the Data --

select distinct category as unique_categories from retail_sales;



----------------------------------- Data Analysis & business key Questions & Answers ---------------------------------------

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05' --

select * from retail_sales 
where sale_date = '2022-11-05';


-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022--

select * from retail_sales
where 
category = 'Clothing'
and
to_char(sale_date,'yyyy-mm')='2022-11'
and
quantity >= 4;

-- Write a SQL query to calculate the total sales (total_sale) for each category --

select category,sum(total_sale)as Total_Sales,count(*) as Total_Orders from retail_sales
group by category;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category --

select category,round(avg(age),0) as Average_Age from retail_sales 
where category = 'Beauty'
group by category;

-- Write a SQL query to find all transactions where the total_sale is greater than 1000 --

select * from retail_sales
where total_sale >= 1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category --

select category,gender,count(*)as total_Transactions from retail_sales
group by gender,category;


-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year --

select
extract(year from sale_date) as year,
extract(month from sale_date) as month,
avg(total_sale) as average_sale
from retail_sales
group by 1,2
order by 1,3 desc;


-- Write a SQL query to find the top 5 customers based on the highest total sales --

select customer_id,sum(total_sale) as total_sales from retail_sales
group by customer_id
order by total_sales desc limit 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category --

select category,count(distinct customer_id) as unique_customers
from retail_sales
group by category;


-- Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17) --
with hourly_sales
as
(
select *,
case
when extract(hour from sale_time) < 12 then 'Morning'
when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
else 'Evening'
end as shifts
from retail_sales
)
select 
shifts,
count(total_sale)
from hourly_sales
group by shifts;
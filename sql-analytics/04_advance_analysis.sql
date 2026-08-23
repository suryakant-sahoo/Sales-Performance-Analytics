/*What are the Top 3 Products in each Region by Sales?*/
with ranked_products as 
(select  
Product,
Region,
round(sum(Sales),2) as total_sales,
rank() over (partition by Region order by round(sum(Sales),2) desc) as products_rank
from saless
group by 1,2)
select * from ranked_products
where products_rank < 3;

/*MoM growth sales*/
select * from saless limit 1;
describe saless;

With monthly_sales as 
(select
year (
case 
when `Order Date` like '%/%' then str_to_date(`Order Date` ,'%m/%d/%Y')
when `Order Date` like '%-%' then str_to_date(`Order Date` , '%m-%d-%Y')
end) as sales_year ,
month(
case
 when `Order Date` like '%/%' then str_to_date(`Order Date`  , '%m/%d/%Y')
when `Order Date` like '%-%' then str_to_date(`Order Date` ,'%m-%d-%Y')
end) as sales_month,
sum(Sales) as total_Sales
from saless
group by 1, 2)

select 
sales_year,
sales_month,
total_Sales,
lag(total_sales) over (order by sales_year , sales_month) as previous_sales,
round((total_Sales - lag(total_sales) over (order by sales_year , sales_month))/lag(total_sales) over (order by sales_year , sales_month) * 100,2) as MoM_growth_percentage
from monthly_Sales;


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

#I have used str_to_date and case statement as "Order Date" coulmn was not standardised data type.So , to make it standardized I have used#
 
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


/*What is the cumulative/running Sales by month*/

with monthly_sales as 
(select
year(
case
when `Order Date` like '%/%' then str_to_date (`Order Date` , '%m/%d/%Y')
when `Order Date` like '%-%' then str_to_date (`Order Date` , '%m-%d-%Y')
end) as sales_year, 
month(
case 
when `Order Date` like '%/%' then str_to_date(`Order Date`, '%m/%d/%Y')
WHEN `Order Date` like '%-%' then str_to_date(`Order Date` , '%m-%d-%Y')
End) as sales_month,
sum(Sales) as total_sales
from saless
group by 1,2)

select 
sales_year , 
sales_month,
total_sales,
round(sum(total_Sales) over (order by sales_year , sales_month),2) as running_total
from monthly_Sales;



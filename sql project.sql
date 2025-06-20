CREATE DATABASE ecommerce_db;
USE ecommerce_db;

alter table df_customers
rename to customers;

alter table df_orderitems
rename to orderitems;

alter table df_orders
rename to orders;

alter table df_payments
rename to payments;

alter table df_products
rename to products;

select * from products limit 2;
select * from payments limit 2;
select * from orders limit 2;
select * from orderitems limit 2;
select * from customers limit 2;

desc orderitems;
desc orders;
desc payments;
desc products;
desc customers;

alter table customers modify customer_id varchar(50);
alter table customers add primary key(customer_id);

alter table orders modify customer_id varchar(50);
alter table orders add foreign key (customer_id) references customers(customer_id);
alter table orders modify order_id varchar(50);
alter table orders add primary key(order_id);


alter table orderitems modify order_id varchar(50);
alter table orderitems add foreign key (order_id) references orders(order_id);
alter table orderitems modify product_id varchar(50);
alter table orderitems modify seller_id varchar(50);
select * from orderitems
where product_id="zX9HL81jfvr2";


alter table payments modify order_id varchar(50);
alter table payments add foreign key (order_id) references orders(order_id);

alter table products modify product_id varchar(50);
alter table products modify product_category_name varchar(100);
select product_id, count(*) as count
from products
group by product_id
having count > 1;

create table products_clean as select distinct * from products;
drop table products;
rename table products_clean to products;
alter table products add primary key(product_id);

select product_category_name from products
group by product_category_name; 

set sql_safe_updates = 0;

update products
set product_category_name = 'Uncategorized'
where product_category_name='';
select product_category_name from products
where product_category_name = 'Uncategorized';

set sql_safe_updates = 1;


--- SUMMARIZING QUESTIONS ---
-- 1. What is our total revenue, number of customers, and number of orders?

select count(distinct o.order_id) as total_orders,
count(distinct o.customer_id) as total_customers,
sum(oi.price + oi.shipping_charges) as total_revenue
from orders o
join orderitems oi on o.order_id = oi.order_id;

-- 2. Which 5 product categories bring in the highest revenue?

select p.product_category_name, sum(oi.price + oi.shipping_charges) as total_revenue
from orderitems oi
join products p on oi.product_id=p.product_id
group by p.product_category_name
order by total_revenue desc
limit 5;

-- 3. Which states or cities have the highest  number of customers?

select customer_state,customer_city, count(*) as customer_count
from customers
group by customer_state,customer_city
order by customer_count desc
limit 10;

-- 4. What is the average order value and average shipping charge?

select avg(shipping_charges)as avg_shipping_charge, avg(price+shipping_charges)as avg_order_value
from orderitems;

-- 5. Which payment methods are most used by customers?

select payment_type, count(*) as payment_count
from payments
group by payment_type
order by payment_count desc;


---- SALES AND PRODUCT PERFORMANCE ---
-- 6. Which are the top 10 best selling products by quantity sold?

select product_id,product_id
from orderitems
group by product_id
order by total_units_sold desc
limit 10;

-- 7. Which products generated the highest total revenue?
  
select*from orderitems;
select product_id, sum(shipping_charges+ price) as revenue
from orderitems
group by product_id
order by revenue desc;


--8. What products are frequently ordered together?

select oi1.product_id as prod_a, oi2.product_id as prod_b, count(distinct oi1.order_id) as times_ordered_together
from orderitems oi1
join orderitems oi2
on oi1.order_id = oi2.order_id
aND oi1.product_id < oi2.product_id
group by prod_a, prod_b
ORDER BY times_ordered_together desc;

--9. What are the top 5 sellers by total revenue and how does their average price compare to others?

select seller_id, sum(price+shipping_charges)as total_revenue, avg(price) as avg_price
from orderitems
group by seller_id
order by total_revenue desc
limit 5;
with seller_stats as (
  select
    seller_id,
    sum(price + shipping_charges) as total_rev,
    avg(price) as avg_price
  from orderitems
  group by seller_id
),
top5 as (select*from seller_stats order by total_rev desc limit 5),
others as (select
    'others' as seller_id,
    sum(total_rev) as total_rev,
    avg(avg_price) as avg_price
  from seller_stats
  where seller_id not in(select seller_id from top5))
select seller_id, total_rev, avg_price from top5
union all
select * from others
order by total_rev desc;

-- 10. Which product categories have the highest shipping costs and do they correspond with high revenue?
select p.product_category_name,
avg(oi.shipping_charges)as avg_shippingcharge,
sum(oi.price+oi.shipping_charges) as revenue
from products p
join orderitems oi on oi.product_id=p.product_id
group by p.product_category_name
order by avg_shippingcharge desc;


--- CUSTOMER BEHAVIOUR ANALYSIS ---
--1. Who are our top spending and most loyal customers?

select o.customer_id,count(distinct o.order_id) as total_orders,
sum(oi.price + oi.shipping_charges) as total_spent
from orders o
join orderitems oi on o.order_id = oi.order_id
group by o.customer_id
order by total_spent desc
limit 10;

-- 2. What percentage of customers are repeat buyers?

select round(sum(case when order_count > 1 then 1 else 0 end)
  / count(*) * 100, 2) as repeat_buyer_%
from (select customer_id,count(distinct order_id) as order_count
from orders
group by customer_id) as customer_orders;


--3. Which states or cities have the highest average order value?

select c.customer_state,c.customer_city,
  round(avg(oi.price + oi.shipping_charges), 2) as avg_order_value
from customers c
join orders o on c.customer_id = o.customer_id
join orderitems oi on o.order_id = oi.order_id
group by c.customer_state, c.customer_city
order by avg_order_value desc
limit 10;

--4. How does customer behavior differ across regions?

select c.customer_state,count(o.order_id) as order_volume,
  round(avg(oi.shipping_charges),2) as avg_shipping_cost
from customers c
join orders o on c.customer_id = o.customer_id
join orderitems oi on o.order_id = oi.order_id
group by c.customer_state
order by order_volume desc, avg_shipping_cost desc
limit 10;

-- 5. What is the lifetime value of each customer?

select 
  c.customer_id,
  count(distinct o.order_id) as total_orders,
  round(sum(oi.price + oi.shipping_charges), 2) as lifetime_value
from customers c
join orders o on c.customer_id = o.customer_id
join orderitems oi on o.order_id = oi.order_id
group by c.customer_id
order by lifetime_value desc
limit 10;


--- TIME SERIES AND TRENDS ---
-- 1. Monthly trends in orders and revenue

select 
  date_format(o.order_purchase_timestamp, '%y-%m') as month,
  count(distinct o.order_id) as orders_count,
  round(sum(oi.price + oi.shipping_charges), 2) as monthly_revenue
from orders o
join orderitems oi on o.order_id = oi.order_id
group by month
order by month;

-- 2. Peak sales months and days of the week

select 
  date_format(o.order_purchase_timestamp, '%y-%m') as month,
  count(distinct o.order_id) as orders_count
from orders o
group by month
order by orders_count desc
limit 5;
select 
  dayname(o.order_purchase_timestamp) as day_of_week,
  count(distinct o.order_id) as orders_count
from orders o
group by day_of_week
order by orders_count desc;

-- 3. Change in average order value over time

select 
  date_format(o.order_purchase_timestamp, '%y-%m') as month,
  round(avg(oi.price + oi.shipping_charges), 2) as avg_order_value
from orders o
join orderitems oi on o.order_id = oi.order_id
group by month
order by month;

-- 4. Shift in payment method preferences

select 
  date_format(o.order_purchase_timestamp, '%y-%m') as month,
  p.payment_type,
  count(*) as count_payments
from payments p
join orders o on p.order_id = o.order_id
group by month, p.payment_type
order by month;

-- 5. Products growing in popularity over time
select 
  date_format(o.order_purchase_timestamp, '%y-%m') as month,
  oi.product_id,
  count(*) as units_sold
from orders o
join orderitems oi on o.order_id = oi.order_id
group by month, oi.product_id
having units_sold > 10
order by month, units_sold desc;

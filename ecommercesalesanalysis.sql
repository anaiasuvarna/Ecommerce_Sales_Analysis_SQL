create database ecommerce_sales;
use ecommerce_sales;

create table customers(
customer_id varchar(15) primary key,
customer_signup_date date,
gender varchar(10),
age int,
state varchar(20),
city varchar(20),
pincode_prefix int,
customer_segment varchar(30),
preferred_payment_method varchar(30),
total_orders int,
total_spend float,
last_order_date date,
customer_status varchar(30),
loyalty_tier varchar(30)
);

select * from customers;

create table products(
product_id varchar(15) primary key,
category varchar(50),
subcategory varchar(50),
brand varchar(50),
price float,
cost_price float,
discount_range varchar(10),
rating_average float,
rating_count int,
stock_quantity int,
product_launch_date date,
product_type varchar(20)
);

select * from products;

create table orders(
order_id varchar(15) primary key,
customer_id varchar(15),
constraint fk_orders_customers
foreign key (customer_id) references customers(customer_id),
order_date date,
order_status varchar(20),
shipping_method varchar(20),
delivery_city varchar(20),
delivery_state varchar(20),
discount_percentage int,
subtotal float,
tax_amount float,
final_amount float
);

select * from orders;

create table order_items(
order_item_id varchar(15) primary key,
order_id varchar(15),
constraint fk_orderitems_orders
foreign key (order_id) references orders(order_id),
product_id varchar(15),
constraint fk_orderitems_products
foreign key (product_id) references products(product_id),
quantity int,
unit_price float,
discount_percentage float,
item_revenue float,
item_cost float,
profit float
);

select * from order_items;

create table returns(
return_id varchar(15) primary key,
order_id varchar(15),
constraint fk_returns_orders
foreign key (order_id) references orders(order_id),
customer_id varchar(15),
constraint fk_returns_customers
foreign key (customer_id) references customers(customer_id),
product_id varchar(15),
constraint fk_returns_products
foreign key (product_id) references products(product_id),
return_date date,
refund_amount float,
return_reason varchar(100),
return_status varchar(20)
);

select * from returns;

/*CUSTOMER TABLE*/

select * from customers;

#How many customers are registered from each state?
select state, count(customer_id) as customers_in_state
from customers
group by state
order by customers_in_state desc;

#How many customers are male, female or other genders?
select gender, count(*) as total_customers
from customers
group by gender;

#What is the age demographic breakdown of the customer base?
select 
case
when age between 18 and 24 then "young adult"
when age between 25 and 34 then "millennials"
when age between 35 and 44 then "middle-aged"
when age between 45 and 54 then "older adult"
else "n/a"
end as Age_Group,
count(customer_id) as customer_count
from customers
group by Age_Group;

#What is the average and total spending of each customer segment?
select customer_segment, count(customer_id) as total_customers,
round(avg(total_orders),0) as average_orders_per_customer,
round(avg(total_spend), 2) as average_customer_spend,
round(sum(total_spend), 2) as total_segment_spend
from customers
group by customer_segment
order by average_customer_spend desc;

/*PRODUCTS TABLE*/

select * from products;

#What products are available, and what are their prices?
select product_id, category, price 
from products
order by price desc;

#How many products are present of each type?
select product_type, count(*) as product_count
from products
group by product_type;

#How many products are present in each category and what is their average price? 
select category, count(*) as product_count, 
round(avg(price),2) as average_price, 
min(price) as min_price, max(price) as max_price
from products
group by category
order by average_price desc;

#Compare the prices of the most expensive product in each category and the other products in the category.
select product_id, category, brand, price,
max(price) over(partition by category order by price desc) as max_price,
rank() over(partition by category order by price desc) as price_rank
from products
order by max_price desc;

#Compare the average ratings of the products (weighted by rating count).
alter table products
add rating_percentage int
generated always as (((rating_average*rating_count/(5*rating_count))*100)) stored;

/*ORDERS TABLE*/

select * from orders;

#What are the order ids and customer ids of the orders that were not delivered? How many are there?
select order_id, customer_id, order_status
from orders
where order_status not in ("Delivered","Returned");
select count(order_status) 
from orders
where order_status not in ("Delivered","Returned");

#Display all the details of ONLY the orders that were delivered.
create view Delivered_Orders as
select * from orders
where order_status="Delivered";
show create view Delivered_Orders;
select * from Delivered_Orders;

#What are the order ids and customer ids of the top 5 highest paying customers?
select order_id, customer_id,final_amount from orders
where order_status="Delivered"
order by final_amount desc
limit 5;

#How many orders were delivered from states starting with the letter ""M"?
select delivery_state ,count(delivery_state) from orders
where delivery_state like "M%"
and order_status="Delivered"
group by delivery_state ;

/*ORDER_ITEMS TABLE*/

select * from order_items;

#What are the top 10 highest selling products by quantity?
select product_id, sum(quantity) as units_sold
FROM order_items
GROUP BY product_id
ORDER BY units_sold DESC
LIMIT 10;

#What are the top 10 products that generate the highest profit?
select product_id, round(sum(profit), 2) as total_profit
from order_items
group by product_id
order by total_profit desc
limit 10;

#For each order id, list the different types of items and total number of items purchased.
select order_id, count(order_item_id) as types_of_items, sum(quantity) as total_items
from order_items
group by order_id
order by total_items desc;

#What was the price of the item before applying the discount? 
alter table order_items
add price_before_discount int
generated always as (quantity*unit_price) stored after unit_price;

#Which were the top 5 highest-ordered products? How much profit or loss did they contribute?
select product_id, sum(quantity) as no_of_products, round(sum(profit),2) as total_profit
from order_items
group by product_id
order by no_of_products desc
limit 5;

select product_id, profit from order_items
where profit<0;

/*RETURNS TABLE*/

select * from returns;

#What are the most common reasons for returns?
select return_reason, count(*) as total_returns
from returns
group by return_reason
order by total_returns desc;

#Which return reasons cause the highest financial losses?
select return_reason, count(return_id) as total_returns, round(sum(refund_amount), 2) as total_refunds
from returns
group by return_reason
order by total_refunds desc;

#How many customers have not been refunded yet? How many customers have returned their orders in total?
select count(case when return_status not in ("Refunded","Approved") then customer_id end) as unrefunded,
count(customer_id) as total_returns from returns;

#How many returns occur per month for each year?
select year(return_date) as return_year, 
month(return_date) AS return_month,
count(*) as total_returns
from returns
group by return_year, return_month
order by return_year desc, return_month desc;

#What are the product ids of the top three most commonly returned products?
select count(product_id) as products_returned, product_id from returns
group by product_id
order by products_returned desc 
limit 3;

/*JOINS*/

#INNER JOINS

#How many products were purchased in each order? What are the order ids and product ids?
select o.order_id, p.product_id, oi.quantity
from orders o inner join order_items oi on o.order_id = oi.order_id 
inner join products p on oi.product_id = p.product_id
order by oi.quantity desc;

#Which product categories generated the most sales?
select p.category, round(sum(oi.item_revenue),2) as total_revenue
from order_items oi inner join products p on oi.product_id = p.product_id
group by p.category
order by total_revenue desc;

#LEFT JOINS

#How many products were returned out of all the products purchased?
select count(distinct r.product_id) as products_returned, 
count(distinct p.product_id)-count(distinct r.product_id) as products_not_returned
from products p left join returns r on p.product_id=r.product_id;

#Which customers have never placed an order?
select c.customer_id, c.city
from customers c left join orders o 
on c.customer_id = o.customer_id
where o.order_id is null;

#SELF JOIN

#Which pairs of customers live in the same city?
select c1.customer_id as customer_1_id, c2.customer_id as customer_2_id, c1.city
from customers c1 inner join customers c2
on c1.city = c2.city
and c1.customer_id < c2.customer_id
order by c1.city;

#REVENUE AND PROFIT 

#Rank products within each category by total revenue.
select p.category, p.product_id, round(sum(oi.item_revenue),2) as total_revenue,
rank() over (partition by p.category order by sum(oi.item_revenue) desc) as revenue_rank,
dense_rank() over (partition by p.category order by sum(oi.item_revenue) desc) as dense_revenue_rank
from products p inner join order_items oi on p.product_id = oi.product_id
group by p.category, p.product_id
order by p.category, total_revenue desc;

#What is the month-wise order count, revenue and profit for each year?
select year(o.order_date) as sales_year, month(o.order_date) as sales_month,
count(distinct o.order_id) as total_orders,
round(sum(oi.item_revenue), 2) as revenue,
round(sum(oi.profit), 2) as profit
from orders o join order_items oi on o.order_id = oi.order_id
where o.order_status = 'Delivered'
group by year(o.order_date), month(o.order_date)
order by sales_year desc, sales_month;

#What is the total revenue and profit generated by each product category?
select p.category, 
round(sum(oi.item_revenue), 2) as total_revenue, 
round(sum(oi.profit), 2) as total_profit
from products p join order_items oi on p.product_id = oi.product_id
group by p.category
order by total_profit desc;

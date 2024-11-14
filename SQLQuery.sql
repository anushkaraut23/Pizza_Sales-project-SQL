create database Pizza_Sales
use Pizza_Sales

select * from pizza_types --dim

select * from pizza --dim

select * from orders --dim
alter table orders alter column date date 
alter table orders alter column time time
select * from order_details --fact


--Retrieve the total number of orders placed.
select count(order_id) as Total_order from orders

--Calculate the total revenue generated from pizza sales.
select round(sum(order_details.quantity * pizza.price),0) as Total_Sales 
from order_details 
join pizza on order_details.pizza_id = pizza.pizza_id

--Identify the highest-priced pizza.
select top 1 pizza.price ,pizza_types.name from pizza
join pizza_types on pizza.pizza_type_id = pizza_types.pizza_type_id 
where price = (select max(price) as  highest_priced_pizza from pizza)

--Identify the most common pizza size ordered.
select pizza.size,(count(order_details.quantity)) as Count_quantity from pizza 
join order_details on pizza.pizza_id = order_details.pizza_id
group by pizza.size
order by pizza.size asc


-- List the top 5 most ordered pizza types along with their quantities.
select top 5 pizza_types.name , sum(order_details.quantity) AS Quantity from pizza_types
join pizza on pizza_types.pizza_type_id =pizza.pizza_type_id
join order_details on order_details.pizza_id = pizza.pizza_id
group by pizza_types.name
order by Quantity desc

--Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category , sum(order_details.quantity) as Total_Quantity
from pizza_types join pizza on pizza_types.pizza_type_id = pizza.pizza_type_id
join order_details on order_details.pizza_id=pizza.pizza_id
group by  pizza_types.category

delete from orders where time is null

--Determine the distribution of orders by hour of the day.
select distinct(datepart(HOUR,time))as Hour ,count(order_id) as Order_count  from orders 
group by datepart(HOUR,time)
order by hour asc 

--Join relevant tables to find the category-wise distribution of pizzas.
select category,count(name) as CountS_pizza from pizza_types
group by category


--Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(Quantity),0) as AVG_pizza_perday from
(select orders.date,sum(order_details.quantity) as Quantity from orders 
join order_details on order_details.order_id=orders.order_id
group by orders.date) as order_quantity

select orders.date,sum(order_details.quantity) as Quantity from orders 
join order_details on order_details.order_id=orders.order_id
group by orders.date
order by orders.date asc

--Determine the top 3 most ordered pizza types based on revenue.
select top 3 pizza_types.name,round(sum(order_details.quantity * pizza.price),0) as Total_Sales
from order_details join pizza 
on order_details.pizza_id =pizza.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizza.pizza_type_id
group by pizza_types.name
order by Total_Sales desc


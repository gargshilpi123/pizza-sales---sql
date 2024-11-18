--  Retrieve the total number of orders placed.
select count(*) as total_orderplaced from orders;

-- Calculate the total revenue generated from pizza sales.
select sum(price * quantity) as total_revenue from pizzas p
inner join order_details o 
on p.pizza_id=o.pizza_id;

-- Identify the highest-priced pizza.
select pt.name ,p.price from pizzas p 
inner join pizza_types pt
on p.pizza_type_id=pt.pizza_type_id
order by p.price Desc limit 1;

-- Identify the most common pizza size ordered. 
select p.size,count(o.order_details_id) as order_max from pizzas p
inner join order_Details o
on o.pizza_id=p.pizza_id
group by p.size
order by order_max DESc
limit 1;

-- List the top 5 most ordered pizza types along with their quantities.
select pt.name ,sum(o.quantity) as most_order 
from order_details o
inner join pizzas p
on p.pizza_id=o.pizza_id 
inner join pizza_types pt
on p.pizza_type_id=pt.pizza_type_id
group by name
order by most_order Desc limit 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.
select pt.category ,sum(o.quantity) as most_order 
from order_details o
inner join pizzas p
on p.pizza_id=o.pizza_id 
inner join pizza_types pt
on p.pizza_type_id=pt.pizza_type_id
group by pt.category;

-- Determine the distribution of orders by hour of the day.
select hour(order_time) each_order ,count(order_id) from orders group by  each_order;

-- Join relevant tables to find the category-wise distribution of pizzas. 
select count(pizza_type_id ) ,category from pizza_types group by category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
select avg(total_order) from (select sum(quantity) as total_order from orders o
inner join order_details od 
on o.order_id=od.order_id 
group by order_date) as d; 

-- Determine the top 3 most ordered pizza types based on revenue.
select name,sum(quantity*price) as cn from pizza_types pt
inner join pizzas p
on p.pizza_type_id=pt.pizza_type_id
inner join order_details o
on o.pizza_id=p.pizza_id
group by name order by cn DESC limit 3;

-- calculate the percentage contribution of each pizza type to total revenue.
select category,(sum(quantity*price)/(select sum(price * quantity) from pizzas p
inner join order_details o 
on p.pizza_id=o.pizza_id)*100) as percentage from pizza_types pt
inner join pizzas p
on p.pizza_type_id=pt.pizza_type_id
inner join order_details o
on o.pizza_id=p.pizza_id
group by category ;

-- Analyze the cumulative revenue generated over time.
select sum(cn) over (order by order_date)from (select order_date,sum(quantity*price) as cn from orders od
inner join order_details o
on o.order_id=od.order_id
inner join pizzas p
on o.pizza_id=p.pizza_id
group by order_date ) as d ;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select pt.name from (select category,sum(quantity*price) as cn from pizza_types pt
inner join pizzas p
on p.pizza_type_id=pt.pizza_type_id
inner join order_details o
on o.pizza_id=p.pizza_id
group by category ) as d ;
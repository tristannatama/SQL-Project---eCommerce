create table anual_revenue as
select years, sum(rev) as revenue
from (
	select
	date_part('year', order_purchase_timestamp) as years, 
	sum(price+freight_value) as rev, order_status
	from order_items oi
	join orders o
	on oi.order_id = o.order_id
	where order_status = 'delivered'
	group by 1,3) as status
group by 1
order by 1;


create table anual_cancel_orders as
select date_part('year', order_purchase_timestamp) as years, count(order_id) cancel_orders
from orders
where order_status = 'canceled'
group by 1;


create table anual_top_categories as
select years, product_category_name as top_categories
from
(select 
	date_part('year', order_purchase_timestamp) as years,
	product_category_name,
	sum(price+freight_value) as rev,
 	RANK() OVER (PARTITION BY date_part('year', order_purchase_timestamp) 
				 ORDER BY SUM(price+freight_value) DESC) AS ranks
from order_items oi
join orders o on oi.order_id = o.order_id
join product p on oi.product_id = p.product_id
where order_status = 'delivered'
group by 1,2) cats
where ranks = 1
order by years;


create table anual_most_canceled_categories as
select years, product_category_name as most_canceled_categories
from
(select 
	date_part('year', order_purchase_timestamp) as years,
	product_category_name,
	count(oi.order_id) as canceles,
 	RANK() OVER (PARTITION BY date_part('year', order_purchase_timestamp) 
				 ORDER BY count(oi.order_id) DESC) AS canceles_rank
from order_items oi
join orders o on oi.order_id = o.order_id
join product p on oi.product_id = p.product_id
where order_status = 'canceled'
group by 1,2) cans
where canceles_rank = 1
order by years;

select anual_revenue.years, revenue, cancel_orders, top_categories, most_canceled_categories
from anual_revenue
join anual_cancel_orders on anual_revenue.years = anual_cancel_orders.years
join anual_top_categories on anual_revenue.years = anual_top_categories.years
join anual_most_canceled_categories on anual_revenue.years = anual_most_canceled_categories.years
select year, round(avg(total_customer),0) as average_active_user
from
(select date_part('year', od.order_purchase_timestamp) as year,
 		date_part('month', od.order_purchase_timestamp) as month,
 		count(distinct cd.customer_unique_id) as total_customer
from orders as od
join customers as cd on od.customer_id = cd.customer_id
group by 1,2) new
group by 1;

select 
	date_part('year', first_time_order) as year, 
	count(new.customer_unique_id) as new_customers 
from (
        select 
			c.customer_unique_id,
            min(o.order_purchase_timestamp) as first_time_order
		from orders o
		inner join customers c on c.customer_id = o.customer_id
		group by 1
) as new
group by 1
order by 1;

select year, count(total_customer) as repeat_order_user
from
(select date_part('year', od.order_purchase_timestamp) as year,
 		cd.customer_unique_id,
 		count(cd.customer_unique_id) as total_customer,
 		count(od.order_id) as total_order
from orders as od
join customers as cd on od.customer_id = cd.customer_id
group by 1,2
having count(order_id) >1
) new
group by 1
order by 1;


select year, round(avg(total_order),2) as average_frequency_order
from
(select date_part('year', od.order_purchase_timestamp) as year,
 		cd.customer_unique_id,
 		count(distinct order_id) as total_order
from orders as od
join customers as cd on od.customer_id = cd.customer_id
group by 1,2
) new
group by 1
order by 1;

with count_mau as (
select year, round(avg(total_customer),0) as average_active_user
from
(select date_part('year', od.order_purchase_timestamp) as year,
 		date_part('month', od.order_purchase_timestamp) as month,
 		count(distinct cd.customer_unique_id) as total_customer
from orders as od
join customers as cd on od.customer_id = cd.customer_id
group by 1,2) a
group by 1
),

count_newcust as(
select 
	date_part('year', first_time_order) as year, 
	count(new.customer_unique_id) as new_customers 
from (
        select 
			c.customer_unique_id,
            min(o.order_purchase_timestamp) as first_time_order
		from orders o
		inner join customers c on c.customer_id = o.customer_id
		group by 1
) as new
group by 1
order by 1
),

count_repeat_order as(
select year, count(total_customer) as repeat_order_user
from
(select date_part('year', od.order_purchase_timestamp) as year,
 		cd.customer_unique_id,
 		count(cd.customer_unique_id) as total_customer,
 		count(od.order_id) as total_order
from orders as od
join customers as cd on od.customer_id = cd.customer_id
group by 1,2
having count(order_id) >1
) new
group by 1
order by 1
),

avg_order as (
select year, round(avg(total_order),2) as average_frequency_order
from
(select date_part('year', od.order_purchase_timestamp) as year,
 		cd.customer_unique_id,
 		count(distinct order_id) as total_order
from orders as od
join customers as cd on od.customer_id = cd.customer_id
group by 1,2
) new
group by 1
order by 1)

select 
cm.year,
cm.average_active_user,
cn.new_customers,
cro.repeat_order_user,
ao.average_frequency_order
from count_mau cm 
join count_newcust cn on cm.year=cn.year
join count_repeat_order cro on cm.year=cro.year
join avg_order ao on cm.year=ao.year;
select tahun, bulan, count(bulan) as jumlah, round(AVG(bulan), 0) as rataan
from
	(select 	
		customers.customer_id, 
		customers.customer_unique_id, 
		extract(month from(order_purchase_timestamp))as bulan,
		extract(year from(order_purchase_timestamp))as tahun
	from customers
	left join orders
	on customers.customer_id = orders.customer_id
	order by 4,3) as c
group by 1,2
;

select to_char(order_purchase_timestamp, 'yyyy-mm') as bulan,
       count(*) filter (where new_customer) as new_customers
from (       
  select customer_id,
         order_purchase_timestamp, 
         order_purchase_timestamp = min(order_purchase_timestamp) over w as new_customer
  from orders
  window w as (partition by customer_id)
) tmp
group by to_char(order_purchase_timestamp, 'yyyy-mm')
order by to_char(order_purchase_timestamp, 'yyyy-mm');

select customer_id, count(customer_id)
from orders
group by 1
having count(customer_id) > 1;

with mp as(
select 
	extract(year from(order_purchase_timestamp))as tahun, 
	count(order_purchase_timestamp) as total_orders
from orders 
group by 1)
select round(avg(total_orders), 0) from mp





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

-- select date (order_purchase_timestamp) 
-- from orders
-- order by date;

-- select 
-- extract(year from(order_purchase_timestamp))as years, count(extract(year from(order_purchase_timestamp)))
-- from orders
-- group by 1



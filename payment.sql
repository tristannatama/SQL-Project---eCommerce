select
	payment_type,
	sum(case when year = '2016' then total else 0 end) as "2016",
	sum(case when year = '2017' then total else 0 end) as "2017",
	sum(case when year = '2018' then total else 0 end) as "2018"
from (
	select
	date_part('year', o.order_purchase_timestamp) AS year,
	payment_type,
	COUNT(o.order_id) AS total
from order_payments op
join orders o 
on op.order_id = o.order_id
group by 1,2) as payment_total
group by 1
order by 2,3,4
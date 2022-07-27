-- alter table sellers add constraint sellers_zip_code_prefix_fkey FOREIGN KEY (seller_zip_code_prefix) REFERENCES geolocation (geolocation_zip_code_prefix)
select distinct order_item_id, count(order_item_id)
from order_items
group by 1
order by 1

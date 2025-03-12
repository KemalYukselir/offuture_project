	
select  
	*
from 
	offuture.address


select 
	* 
from 
	offuture.customer 
	
	
select  
	*
from 
	offuture.master
	
select 
	*
from 
	offuture.master_backup
	
select  
	*
from 
	offuture.order 
	
select 
	*
from 
	offuture.order_item 
	
	
select 
	*
from 
	offuture.product
	
	
	----Total Sales across each year----

SELECT
	EXTRACT(YEAR FROM order_date),
	SUM(profit)
FROM 
	offuture.order_item
INNER JOIN offuture.order
	USING(order_id)
GROUP BY
	EXTRACT(YEAR FROM order_date)	
	
	
SELECT
	EXTRACT(MONTH FROM order_date),
	SUM(profit)
FROM 
	offuture.order_item
INNER JOIN offuture.order
	USING(order_id)
GROUP BY
	EXTRACT(MONTH FROM order_date)	
	
	
create view offuture_whole_table as
select
	*from
	offuture.order
inner join
 offuture.order_item
		using
 (order_id)
inner join
 offuture.product
		using
 (product_id)
inner join
 offuture.address
		using
 (address_id)
inner join
    offuture.customer
on
	offuture.customer.customer_id_short = offuture.order.customer_id
	
	

	
	
	
select 
	p.product_name,
	sum(oi.sales) as total_sales,
	sum(oi.quantity)  as total_quantity 
from 
	 offuture.order_item oi
inner join 
	offuture.product p  
on  
	p.product_id = oi.product_id 
group by 
	product_name 
order by 
	total_sales desc
limit 10



select 
	p.product_name,
	sum(oi.sales) as total_sales,
	sum(oi.quantity)  as total_quantity 
from 
	 offuture.order_item oi
inner join 
	offuture.product p  
on  
	p.product_id = oi.product_id 
group by 
	product_name 
order by 
	total_sales asc
limit 10	


---COUNT OF NULLS IN TOTAL----
select 
	count(*) as total_rows,
	sum(case when address_id is null then 1 else 0 end) as address_id_nulls,
	sum(case when city is null then 1 else 0 end) as city_nulls,
	sum (case when state is null then 1 else 0 end) as state_nulls,
	sum (case when country is null then 1 else 0 end) as state_nulls,
	sum (case when postal_code is null then 1 else 0 end) as postal_code_nulls,
	sum (case when address_line_1 is null then 1 else 0 end) as address_line_1_nulls,
	sum (case when address_line_2 is null then 1 else 0 end) as address_line_2_nulls
from  
	offuture.address;
	


select 
	count(*) as total_rows,
	sum(case when address_id is null then 1 else 0 end) as address_id_nulls,
	sum(case when city is null then 1 else 0 end) as city_nulls,
	sum (case when state is null then 1 else 0 end) as state_nulls,
	sum (case when country is null then 1 else 0 end) as state_nulls,
	sum (case when postal_code is null then 1 else 0 end) as postal_code_nulls,
	sum (case when address_line_1 is null then 1 else 0 end) as address_line_1_nulls,
	sum (case when address_line_2 is null then 1 else 0 end) as address_line_2_nulls
from  
	offuture.address;



select 
	count(address_id) 
from 
	offuture.address
where 
	address_id ='' or null 
	
	
select 
	count(city)
from 
	offuture.address
where 
	city ='' or null 
	
	
select 
	count(state)
from 
	offuture.address
where 
	state ='' or null 
	
	
select 
	count(country)
from 
	offuture.address
where 
	country =''	or null 
		
	

select 
	count(postal_code)
from 
	offuture.address
where 
	postal_code =''	or null
---20,745---



select 
	count(address_line_1)
from 
	offuture.address
where 
	address_line_1 ='' or null

	
select 
	count(address_line_2)
from 
	offuture.address
where 
	address_line_2 =''	or null 
	
	

select 
	count(customer_id_short)
from 
	offuture.customer
where 
	customer_id_short =''	or null 
	
	
	
select 
	count(customer_id_long)
from 
	offuture.customer
where 
	customer_id_long ='' or null
	
	
	
select 
	count(customer_name)
from 
	offuture.customer
where 
	customer_name ='' or null
	
	
select 
	count(segment)
from 
	offuture.customer
where 
	segment =''	or null
	
	
select 
	count(order_id)
from 
	offuture.order
where 
	order_id ='' or null
	
	
	
select 
	count(order_date)
from 
	offuture.order
where 
	order_date is null
	
select 
	count(ship_date)
from 
	offuture.order
where 
	ship_date is null
	
	
select 
	count(ship_mode)
from 
	offuture.order
where 
	ship_mode =''	
	
	
select 
	count(customer_id)
from 
	offuture.order
where 
	customer_id =''	or null
	

select 
	count(address_id)
from 
	offuture.order
where 
	address_id ='' or null
	
	
select 
	count(market)
from 
	offuture.order
where 
	market ='' or null
	
	
select 
	count(region)
from 
	offuture.order
where 
	region =''	or null
	
select 
	count(order_priority)
from 
	offuture.order
where 
	order_priority ='' or null
	
	
	
select 
	count(order_id)
from 
	offuture.order_item
where 
	order_id ='' or null
	
	
select 
	count(product_id)
from 
	offuture.order_item
where 
	product_id ='' or null
	
	
select 
	count(sales)
from 
	offuture.order_item
where 
	sales is null	
	
	
select 
	count(quantity)
from 
	offuture.order_item
where 
	quantity is null 
	
	
select 
	count(profit)
from 
	offuture.order_item
where 
	profit is null 
	
	
select 
	count(shipping_cost)
from 
	offuture.order_item
where 
	shipping_cost is null	
	
	

select 
	count(product_id)
from 
	offuture.product
where 
	product_id =''	or null
	

select 
	count(product_name)
from 
	offuture.product
where 
	product_name =''	or null
	

select 
	count(category)
from 
	offuture.product
where 
	category ='' or null
	

select 
	count(sub_category)
from 
	offuture.product
where 
	sub_category ='' or null	
	
	
	
	

	
	


	
	
	
	
	
	
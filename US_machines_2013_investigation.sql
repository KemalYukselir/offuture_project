-- Investigating massive dip in machine profits in US 2013 Q4 - which specific products were so unprofitable
SELECT
	ord.order_date,
	prod.product_id,
	prod.product_name,
	ord_it.profit
FROM -- Joining ORDER, order_item and product table
	offuture.ORDER AS ord
INNER JOIN offuture.order_item AS ord_it
	ON ord.order_id = ord_it.order_id
INNER JOIN offuture.product AS prod
	ON ord_it.product_id = prod.product_id
WHERE -- Selecting the orders from Oct-Dec 2013 where profit from US machine sales is negative
	market = 'US' 
	AND 
	profit <= 0 
	AND
	sub_category = 'Machines'
	AND
	(CAST(order_date AS varchar) LIKE '2013%' AND
	(CAST(order_date AS varchar) LIKE '%-10-%' OR
	CAST(order_date AS varchar) LIKE '%-11-%' OR
	CAST(order_date AS varchar) LIKE '%-12-%'))
ORDER BY -- ORDER results BY most negative profit first
	profit ASC;

-- The Cubify CubeX 3D Printer Double Head Print with product_id TEC-MA-10000418 had a -6.6k profit.
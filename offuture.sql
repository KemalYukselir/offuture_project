-- Create view
CREATE OR REPLACE VIEW student.offuture_whole_kem AS
SELECT
	*
FROM 
	offuture.order
INNER JOIN
	offuture.order_item
USING
	(order_id)
INNER JOIN
	offuture.product
USING
	(product_id)
INNER JOIN
	offuture.address
USING
	(address_id)



-- Total Sales across each year / month / qtr
-- year
SELECT 
	SUM(sales) total_sales,
	DATE_PART('year',order_date) AS year_date
FROM 
	offuture.order
INNER JOIN
	offuture.order_item
USING 
	(order_id)
GROUP BY
	year_date
	
	
-- month
SELECT 
	SUM(sales) total_sales,
	DATE_PART('month',order_date) AS month_date
FROM 
	offuture.order
INNER JOIN
	offuture.order_item
USING 
	(order_id)
GROUP BY
	month_date
ORDER BY
	total_sales DESC;

-- qtr
SELECT 
	SUM(sales) total_sales,
	DATE_PART('quarter',order_date) AS quarter_date
FROM 
	offuture.order
INNER JOIN
	offuture.order_item
USING 
	(order_id)
GROUP BY
	quarter_date
ORDER BY
	total_sales DESC;	


-- Total Profit across each year / month / qtr
-- year
SELECT 
	SUM(profit) total_profit,
	DATE_PART('year',order_date) AS year_date
FROM 
	offuture.order
INNER JOIN
	offuture.order_item
USING 
	(order_id)
GROUP BY
	year_date
	
	
-- month
SELECT 
	SUM(profit) total_profit,
	DATE_PART('month',order_date) AS month_date
FROM 
	offuture.order
INNER JOIN
	offuture.order_item
USING 
	(order_id)
GROUP BY
	month_date
ORDER BY
	total_profit DESC;

-- qtr
SELECT 
	SUM(profit) total_profit,
	DATE_PART('quarter',order_date) AS quarter_date
FROM 
	offuture.order
INNER JOIN
	offuture.order_item
USING 
	(order_id)
GROUP BY
	quarter_date
ORDER BY
	total_profit DESC;	

SELECT 
	*
FROM
	student.offuture_whole

--Total sales/profit across each year …. By
--Category, sub-category, or segment 
	
SELECT 
	SUM(sales) total_sales,
	category
FROM 
	offuture.order
INNER JOIN
	offuture.order_item
USING 
	(order_id)
INNER JOIN
	offuture.product
USING
	(product_id)
GROUP BY
	category
ORDER BY
	total_sales DESC;
	
	
--- By sub category
SELECT 
	SUM(sales) total_sales,
	sub_category
FROM 
	offuture.order
INNER JOIN
	offuture.order_item
USING 
	(order_id)
INNER JOIN
	offuture.product
USING
	(product_id)
GROUP BY
	sub_category
ORDER BY
	total_sales DESC;


-- By segment
SELECT
	customer_id_long AS customer_id,
	customer_name,
	segment
FROM
    offuture.customer
UNION
SELECT
	customer_id_short AS customer_id,
	customer_name,
	segment
FROM
    offuture.customer;




SELECT 
	*
FROM
	student.offuture_whole_kem;




-- Quality control checks (MM)	
----- Data Integrity
-- Number of rows

SELECT 	
	COUNT(order_id) AS total_orders
    COUNT(*) AS total_rows
FROM
	offuture.order_item
UNION ALL
SELECT
	COUNT(order_id) AS total_orders_2
FROM
	offuture.ORDER

-- Number of distinct rows
SELECT
	count(*) AS total_distinct_rows
FROM
	(SELECT DISTINCT * FROM offuture.order_item);
	
-- Number of columns per table
SELECT
	COUNT(column_name) AS total_cols,
	table_name
FROM 
	information_schema.COLUMNS
WHERE 
	table_schema = 'offuture'
GROUP BY
	table_name
	
----- Data Completeness
SELECT 
	order_id AS null_primary_keys
FROM
	offuture.order_item
WHERE
	order_id = ''
UNION ALL
SELECT 
	product_id
FROM
	offuture.order_item
WHERE
	product_id = ''
UNION ALL
SELECT 
	address_id
FROM
	offuture.order
WHERE
	address_id = ''

----- Data Accuracy





	
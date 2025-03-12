/*
- PostgreSQL 16.4:
  DATE_PART()
  CREATE OR REPLACE VIEW
  RANDOM()

Documentation - https://www.postgresql.org/docs/current/sql.html
These functions may need to change depending on which SQL you use.
*/

/*
Some caluculations with the customer table since we realised there is short and long ids 
after checking ER Diagram.
-- Findings: 
    -- There are 795 rows in the customer table
    -- The primary keys (customer_id_long) are unique as expected
    -- The short IDs (customer_id_short) are also unique
    -- All long IDs are 8 characters long
    -- The short IDs have varying lengths including some that are 8 character long (same as long ID length)
*/
SELECT
    COUNT(*) AS num_rows,
    COUNT(customer_id_long) AS num_long_ids,                        -- 
    COUNT(DISTINCT customer_id_long) AS num_long_ids_distinct,        -- customer_id_long is the primary key so should be unique
    COUNT(customer_id_short) AS num_long_ids,                        -- 
    COUNT(DISTINCT customer_id_short) AS num_short_ids_distinct        -- checking whether short IDs are unique
FROM
    offuture.customer;

    
-- Lengths of the long IDs
SELECT 
    LENGTH(customer_id_long) AS long_length,
    COUNT(*)
FROM
    offuture.customer
GROUP BY
    long_length;


-- Lengths of the short IDs
SELECT
    LENGTH(customer_id_short) AS short_length,
    COUNT(*)
FROM
    offuture.customer
GROUP BY
    short_length;


-- Check if there is any overlap between naming of short and long IDs 
SELECT DISTINCT
    COUNT(*)
FROM (
    SELECT
        customer_id_long AS customer_id
    FROM
        offuture.customer
    UNION
    SELECT
        customer_id_short
    FROM
        offuture.customer
);

/*
View of all tables connected. This is for reference.
Customer table had some IDs in short and long, so we use a separate condition.
*/
CREATE OR REPLACE VIEW student.offuture_whole_kem AS
SELECT *
FROM offuture.order
INNER JOIN offuture.order_item USING (order_id)
INNER JOIN offuture.product USING (product_id)
INNER JOIN offuture.address USING (address_id)
INNER JOIN offuture.customer
ON offuture.order.customer_id = offuture.customer.customer_id_long
                   OR offuture.order.customer_id = offuture.customer.customer_id_short;

/* Total Sales Analysis */
SELECT
                SUM(sales) AS total_sales,
                DATE_PART('year', order_date) AS year_date
FROM offuture.order
INNER JOIN offuture.order_item USING (order_id)
GROUP BY year_date;

-- Month
SELECT SUM(sales) AS total_sales,
                   DATE_PART('month', order_date) AS month_date
FROM offuture.order
INNER JOIN offuture.order_item USING (order_id)
GROUP BY month_date
ORDER BY total_sales DESC;

-- Quarter
SELECT SUM(sales) AS total_sales,
                   DATE_PART('quarter', order_date) AS quarter_date
FROM offuture.order
INNER JOIN offuture.order_item USING (order_id)
GROUP BY quarter_date
ORDER BY total_sales DESC;

/* Total Profit Analysis */
-- Year
SELECT SUM(profit) AS total_profit,
                   DATE_PART('year', order_date) AS year_date
FROM offuture.order
INNER JOIN offuture.order_item USING (order_id)
GROUP BY year_date;

-- Month
SELECT SUM(profit) AS total_profit,
                   DATE_PART('month', order_date) AS month_date
FROM offuture.order
INNER JOIN offuture.order_item USING (order_id)
GROUP BY month_date
ORDER BY total_profit DESC;

-- Quarter
SELECT SUM(profit) AS total_profit,
                   DATE_PART('quarter', order_date) AS quarter_date
FROM offuture.order
INNER JOIN offuture.order_item USING (order_id)
GROUP BY quarter_date
ORDER BY total_profit DESC;

/* Sales/Profit by Category, Sub-category, and Segment */
-- Category
SELECT SUM(sales) AS total_sales,
                   category
FROM offuture.order
INNER JOIN offuture.order_item USING (order_id)
INNER JOIN offuture.product USING (product_id)
GROUP BY category
ORDER BY total_sales DESC;

-- Sub-category
SELECT SUM(sales) AS total_sales,
                   sub_category
FROM offuture.order
INNER JOIN offuture.order_item USING (order_id)
INNER JOIN offuture.product USING (product_id)
GROUP BY sub_category
ORDER BY total_sales DESC;

-- By Segment
SELECT SUM(sales) AS total_sales,
                   segment
FROM offuture.order
INNER JOIN offuture.order_item USING (order_id)
INNER JOIN offuture.customer
ON offuture.order.customer_id = offuture.customer.customer_id_long
                   OR offuture.order.customer_id = offuture.customer.customer_id_short
GROUP BY segment
ORDER BY total_sales DESC;

/* Quality Control Checks */
-- Data Integrity
-- Number of rows
SELECT COUNT(order_id) AS total_orders,
                   COUNT(*) AS total_rows
FROM offuture.order_item;

-- Number of distinct rows
SELECT COUNT(*) AS total_distinct_rows
FROM (SELECT DISTINCT * FROM offuture.order_item) AS distinct_orders;

-- Number of columns per table
SELECT COUNT(column_name) AS total_cols,
                   table_name
FROM information_schema.COLUMNS
WHERE table_schema = 'offuture'
GROUP BY table_name;

-- Data Completeness: Checking NULL or empty values
SELECT COUNT(*) AS total_rows,
                SUM(CASE WHEN address_id IS NULL OR address_id = '' THEN 1 ELSE 0 END) AS address_id_missing,
                SUM(CASE WHEN city IS NULL OR city = '' THEN 1 ELSE 0 END) AS city_missing,
                SUM(CASE WHEN state IS NULL OR state = '' THEN 1 ELSE 0 END) AS state_missing,
                SUM(CASE WHEN country IS NULL OR country = '' THEN 1 ELSE 0 END) AS country_missing
FROM offuture.address;

-- Data Accuracy: Checking duplicate order IDs
SELECT order_id,
                   COUNT(order_id) AS order_count
FROM offuture.order_item
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Eyeball Check
SELECT order_date, ship_date
FROM offuture.order
ORDER BY RANDOM()
LIMIT 5;

-- Check date formats
SELECT order_date
FROM offuture.order
WHERE DATE_PART('year', order_date) BETWEEN 2011 AND 2015;

-- Data Freshness
SELECT MIN(order_date) AS earliest_order,
                   MAX(order_date) AS latest_order
FROM offuture.order;

SELECT MIN(sales) AS min_sales,
                   MAX(sales) AS max_sales
FROM offuture.order_item;

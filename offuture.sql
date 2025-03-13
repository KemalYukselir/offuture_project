/*
- PostgreSQL 16.4:
  DATE_PART()
  CREATE OR REPLACE VIEW
  RANDOM()

Documentation - https://www.postgresql.org/docs/current/sql.html
These functions may need to change depending on which SQL you use.
*/


----------------------------
-- Quality Control Checks --
----------------------------

-- Customer Table Investigation
-- We decided to investigate the customer table since we realised
-- each customer had a short and a long id.
-- Findings:
--     There are 795 rows in the customer table
--     The primary keys (customer_id_long) are unique as expected
--     The short IDs (customer_id_short) are also unique
--     All long IDs are 8 characters long
--     The short IDs have varying lengths and
--     some have 8 character long (same as long ID length)
--     There is no overlap between the naming of long + short IDs

-- Check how many IDs there are and whether they are unique
SELECT
    COUNT(*) AS num_rows,
    COUNT(customer_id_long) AS num_long_ids,
    COUNT(DISTINCT customer_id_long) AS num_long_ids_distinct,
    COUNT(customer_id_short) AS num_short_ids,
    COUNT(DISTINCT customer_id_short) AS num_short_ids_distinct
FROM
    offuture.customer;


-- Lengths of the long IDs
SELECT
    LENGTH(customer_id_long) AS long_length,
    COUNT(*) AS length_counts
FROM
    offuture.customer
GROUP BY
    long_length;


-- Lengths of the short IDs
SELECT
    LENGTH(customer_id_short) AS short_length,
    COUNT(*) AS length_counts
FROM
    offuture.customer
GROUP BY
    short_length;


-- Check if there is any overlap between naming of short and long IDs
-- Should be 795*2=1590 distinct short and long IDs if there is no overlap
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


-- Data Integrity
-- Number of rows
SELECT
    COUNT(order_id) AS total_orders,
    COUNT(*) AS total_rows
FROM
    offuture.order_item;


-- Number of distinct rows
SELECT
    COUNT(*) AS total_distinct_rows
FROM
    (
        SELECT DISTINCT *
        FROM
            offuture.order_item
    ) AS distinct_orders;


-- Number of columns per table
SELECT
    table_name,
    COUNT(column_name) AS total_cols
FROM
    information_schema.columns
WHERE
    table_schema = 'offuture'
GROUP BY
    table_name;


-- Data Completeness: Checking NULL or empty values
SELECT
    COUNT(*) AS total_rows,
    SUM(
        CASE WHEN address_id IS NULL OR address_id = '' THEN 1 ELSE 0 END
    ) AS address_id_missing,
    SUM(
        CASE WHEN city IS NULL OR city = '' THEN 1 ELSE 0 END
    ) AS city_missing,
    SUM(
        CASE WHEN state IS NULL OR state = '' THEN 1 ELSE 0 END
    ) AS state_missing,
    SUM(
        CASE WHEN country IS NULL OR country = '' THEN 1 ELSE 0 END
    ) AS country_missing,
    SUM(
        CASE WHEN postal_code IS NULL OR postal_code = '' THEN 1 ELSE 0 END
    ) AS postcode_missing,
    SUM(
        CASE
            WHEN address_line_1 IS NULL OR address_line_1 = ''
                THEN 1
            ELSE 0
        END
    ) AS address_line_1_missing,
    SUM(
        CASE
            WHEN address_line_2 IS NULL OR address_line_2 = ''
                THEN 1
            ELSE 0
        END
    ) AS address_line_2_missing
FROM
    offuture.address;


-- Investigating missing postcodes
SELECT
    country,
    COUNT(*) AS empty_count
FROM
    offuture.address
WHERE
    postal_code IS NULL OR postal_code = ''
GROUP BY
    country
ORDER BY
    empty_count DESC;


-- Data Accuracy: Checking duplicate order IDs
SELECT
    order_id,
    COUNT(order_id) AS order_count
FROM
    offuture.order_item
GROUP BY
    order_id
HAVING
    COUNT(*) > 1;


-- Eyeball Check
SELECT
    order_date,
    ship_date
FROM
    offuture."order"
ORDER BY
    RANDOM()
LIMIT 5;


-- Check date formats
SELECT
    order_date
FROM
    offuture."order"
WHERE
    DATE_PART('year', order_date) BETWEEN 2011 AND 2015;

-- Data Freshness
SELECT
    MIN(order_date) AS earliest_order,
    MAX(order_date) AS latest_order
FROM
    offuture."order";

SELECT
    MIN(sales) AS min_sales,
    MAX(sales) AS max_sales
FROM
    offuture.order_item;





---------
-- EDA --
---------

/* Total Sales Analysis */
SELECT
    DATE_PART('year', "order".order_date) AS year_date,
    SUM(order_item.sales) AS total_sales
FROM
    offuture."order"
INNER JOIN offuture.order_item
    ON "order".order_id = order_item.order_id
GROUP BY
    year_date;

-- Month
SELECT
    DATE_PART('month', "order".order_date) AS month_date,
    SUM(order_item.sales) AS total_sales
FROM
    offuture."order"
INNER JOIN offuture.order_item
    ON "order".order_id = order_item.order_id
GROUP BY
    month_date
ORDER BY
    total_sales DESC;

-- Quarter
SELECT
    DATE_PART('quarter', "order".order_date) AS quarter_date,
    SUM(order_item.sales) AS total_sales
FROM
    offuture."order"
INNER JOIN offuture.order_item
    ON "order".order_id = order_item.order_id
GROUP BY
    quarter_date
ORDER BY
    total_sales DESC;

/* Total Profit Analysis */
-- Year
SELECT
    DATE_PART('year', "order".order_date) AS year_date,
    SUM(order_item.profit) AS total_profit
FROM
    offuture."order"
INNER JOIN offuture.order_item
    ON "order".order_id = order_item.order_id
GROUP BY
    year_date;

-- Month
SELECT
    DATE_PART('month', "order".order_date) AS month_date,
    SUM(order_item.profit) AS total_profit
FROM
    offuture."order"
INNER JOIN offuture.order_item
    ON "order".order_id = order_item.order_id
GROUP BY
    month_date
ORDER BY
    total_profit DESC;

-- Quarter
SELECT
    DATE_PART('quarter', "order".order_date) AS quarter_date,
    SUM(order_item.profit) AS total_profit
FROM
    offuture."order"
INNER JOIN offuture.order_item
    ON "order".order_id = order_item.order_id
GROUP BY
    quarter_date
ORDER BY
    total_profit DESC;

/* Sales/Profit by Category, Sub-category, and Segment */
-- Category
SELECT
    product.category,
    SUM(order_item.sales) AS total_sales
FROM
    offuture."order"
INNER JOIN offuture.order_item
    ON "order".order_id = order_item.order_id
INNER JOIN offuture.product
    ON order_item.product_id = product.product_id
GROUP BY
    product.category
ORDER BY
    total_sales DESC;

-- Sub-category
SELECT
    product.sub_category,
    SUM(order_item.sales) AS total_sales
FROM
    offuture."order"
INNER JOIN offuture.order_item
    ON "order".order_id = order_item.order_id
INNER JOIN offuture.product
    ON order_item.product_id = product.product_id
GROUP BY
    product.sub_category
ORDER BY
    total_sales DESC;

-- By Segment
SELECT
    customer.segment,
    SUM(order_item.sales) AS total_sales
FROM
    offuture."order"
INNER JOIN offuture.order_item
    ON "order".order_id = order_item.order_id
INNER JOIN offuture.customer
    ON
        "order".customer_id = offuture.customer.customer_id_long OR
        "order".customer_id = offuture.customer.customer_id_short
GROUP BY
    customer.segment
ORDER BY
    total_sales DESC;


-- Extra checks
-- Investigating massive dip in machine profits in US 2013 Q4
-- Which specific products were so unprofitable?
SELECT
    "order".order_date,
    product.product_id,
    product.product_name,
    order_item.profit
FROM -- Joining ORDER, order_item and product table
    offuture."order"
INNER JOIN offuture.order_item
    ON "order".order_id = order_item.order_id
INNER JOIN offuture.product
    ON order_item.product_id = product.product_id
-- Selecting the orders from Oct-Dec 2013
-- where profit from US machine sales is negative
WHERE
    "order".market = 'US'
    AND
    order_item.profit <= 0
    AND
    product.sub_category = 'Machines'
    AND
    (
        CAST("order".order_date AS varchar) LIKE '2013%' AND
        (
            CAST("order".order_date AS varchar) LIKE '%-10-%' OR
            CAST("order".order_date AS varchar) LIKE '%-11-%' OR
            CAST("order".order_date AS varchar) LIKE '%-12-%'
        )
    )
ORDER BY -- ORDER results BY most negative profit first
    order_item.profit ASC;
-- The Cubify CubeX 3D Printer Double Head Print
-- with product_id TEC-MA-10000418 had a -6.6k profit.

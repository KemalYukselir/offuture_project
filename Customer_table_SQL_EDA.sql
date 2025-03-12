-- Exploring the differences between the short and long IDs

-- Eye check
-- Findings:
	-- customer_id_long is the primary key so should be unique 
	-- customer_id_long seems to have a consistent format of customer's initials + a unique 5 digit number
	-- customer_id_short seems a shortened version of customer_id_long but has varying legnth
	-- Segment seems to indicate whether the customer is 
SELECT 
	*
FROM
    offuture.customer;



-- How many customers are there
-- Findings: 
	-- There are 795 rows in the customer table
	-- The primary keys (customer_id_long) are unique as expected
	-- The short IDs (customer_id_short) are also unique
SELECT
	COUNT(*) AS num_rows,
	COUNT(customer_id_long) AS num_long_ids,						-- 
	COUNT(DISTINCT customer_id_long) AS num_long_ids_distinct,		-- customer_id_long is the primary key so should be unique
	COUNT(customer_id_short) AS num_long_ids,						-- 
	COUNT(DISTINCT customer_id_short) AS num_short_ids_distinct		-- checking whether short IDs are unique
FROM
    offuture.customer;

	
-- Lengths of the long IDs
-- Finding: All long IDs are 8 characters long
SELECT 
	LENGTH(customer_id_long) AS long_length,
	COUNT(*)
FROM
    offuture.customer
GROUP BY
	long_length;



-- Lengths of the short IDs
-- Findings: the short IDs have varying lengths including some that are 8 character long (same as long ID length)
SELECT
	LENGTH(customer_id_short) AS short_length,
	COUNT(*)
FROM
    offuture.customer
GROUP BY
	short_length;


-- Check if there is any overlap between naming of short and long IDs (should be 795 * 2 = 1590 unique IDs if we combine ID columns)
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



-- Creating a view where for every row in customer there is a row with the short ID and a row with the long ID
-- Why we did this?:
	-- 
CREATE OR REPLACE VIEW student.customer_id_fixed AS
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

-- Grant access to other students so my team can use this table
GRANT SELECT ON student.customer_id_fixed TO df_student;

-- Eyeball check to see if everything looks good
SELECT
	*
FROM
	student.customer_id_fixed;




-- Count of segments
-- Finding: there are 3 segments: Consumer(409), Corporate(238), Home Office(148)
SELECT 
	segment,
	COUNT(*) AS num_customers
FROM
    offuture.customer
GROUP BY
	segment;


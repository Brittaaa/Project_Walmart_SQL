-- ----------------------------------------------------------------------------------------
-- Data Cleaning
-- ----------------------------------------------------------------------------------------

-- when importing the data, most of the columns have already been set as NOT NULL
-- check for "gross_margin_pct" and "rating" only (since they are not designed as NOT NULL)
SELECT gross_margin_pct, rating
FROM sales
WHERE (gross_margin_pct IS NULL) OR (rating IS NULL);		-- NOTE: missing values

-- deal with missing date (mean fill)  -- NOTE: python's panda, pd.interpolate(method = 'linear')
WITH rating_means AS ( 
	SELECT branch, city, product_line, 
	AVG(rating) AS avg_rating 
	FROM sales
	WHERE rating IS NOT NULL 
	GROUP BY branch, city, product_line 
)
UPDATE sales_data AS sd 
SET rating = rm.avg_rating 			-- fill
FROM rating_means AS rm 
WHERE sd.rating IS NULL 
	AND sd.branch = rm.branch 
	AND sd.city = rm.city 
	AND sd.product_line = rm.product_line;



-- check outliers in gross_margin_pct ("3-sigma rule")
SELECT *
FROM sales
WHERE ABS(gross_margin_pct - AVG(gross_margin_pct) / STDDEV(gross_margin_pct)) > 3
	OR gross_margin_pct > 1 OR gross_margin_pct < 0;

-- check outliers in gross_margin_pct ("IQR rule")
WITH gmp_q1_q3 AS (
	SELECT invoice_id,		-- key
		gross_margin_pct,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY gross_margin_pct) AS gmp_ql,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY gross_margin_pct) AS gmp_q3
	FROM sales
),
gmp_iqr AS (						-- also can use ORDER BY gross_margin_pct LIMIT 25,1 (or 75,1) for LB and UB
	SELECT invoice_id,
		gross_margin_pct,
        (gmp_q1 - 1.5*(gmp_q3 - gmp_q1)) AS gmp_lb,
        (gmp_q3 + 1.5*(gmp_q3 - gmp_q1)) AS gmp_ub
	FROM gmp_q1_q3
)
SELECT	invoice_id
FROM gmp_q1_q3
WHERE gross_margin_pct < gmp_lb		-- verify Y as acceptable = verify N as outliers (AND to OR)
	OR gross_margin_pct > gmp_ub;



-- check for date format consistency and correct them (add 0s in missing digits)
WITH date_consist_check AS (
	SELECT 	*
    FROM sales
    WHERE TO_DATE(date, 'YYYY-MM-DD') IS NULL		-- find date instances with unmatched format 
) date_inconsist
SELECT *
FROM date_inconsist
ORDER BY invoice_id

UPDATE sales
SET date = CONCAT(
				LEFT(date, 4),							-- take 4 letters from LHS
                '-',
                LPAD(SUBSTRING(date, 6, 2), 2, '0'),	-- LPAD(*string, *total length after added, *what to fill) is to add elements from LHS
                '-',
                LPAD(SUBSTRING(date, 9, 2), 2, '0')
)
WHERE LENGTH(SUBSTRING(date_column, 6, 1)) < 2
    OR LENGTH(SUBSTRING(date_column, 9, 1)) < 2;





-- ----------------------------------------------------------------------------------------
-- Feature Engineering: 3 steps in total
-- ----------------------------------------------------------------------------------------

-- ADD "time_of_day": most sales made are normally related to the part of the day
-- 				  	  devided into "Morning", "Afternoon", and "Evening" to give insight on this, below use lower cases.
SELECT time
FROM sales;		-- NOTE: time format in "XX:XX:XX"

SELECT time,
    (CASE
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "morning"		-- define "morning"
        WHEN time BETWEEN "12:00:01" AND "16:00:00" THEN "afternoon"	-- define "afternoon"
        ELSE "evening"		
	END					-- here the column name 'time' should NOT use quotation mark, or wont have correct transformation!!!
    ) AS time_of_day
    FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);		-- create a new column called "time_of_day"

UPDATE sales
SET time_of_day = (
	CASE
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "morning"		
        WHEN time BETWEEN "12:00:01" AND "16:00:00" THEN "afternoon"	
        ELSE "evening"		
	END		
);



-- ADD "day_name": whether or not on workdays or weekends can affect the amount of sales
-- 				   if recorded on workdays, fewer people are available for shopping behaviour
-- 				   divided into "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" and "Sunday", below use abbriviations.

SELECT date,
	DAYNAME(date) AS day_name		-- built-in function DAYNAME(·), required format： "XXXX-XX-XX xx:xx:xx", return the day name 
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);		-- create a new column "day_name"

UPDATE sales
SET day_name = DAYNAME(date);



-- ADD "month_name": monthly (or seasonal) changes often occour in sales market,
-- 					 during certain periods of time, more people are intend to buy more
-- 					 divided into "January", "Feburary", and "March", below use abbriviations. All dates are in these three months.

SELECT date,
	MONTHNAME(date) AS month_name		-- built-in function MONTHNAME(·)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);



-- add "customer_type_gender" to capture interaction effects between membership and gender for future analysis
ALTER TABLE sales ADD COLUMN type_gender_interact VARCHAR(50);

UPDATE sales
SET type_gender_interact = CONCAT(customer_type, '-', gender);



























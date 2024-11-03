-- ----------------------------------------------------------------------------------------
-- Data Cleaning
-- ----------------------------------------------------------------------------------------

-- when importing the data, most of the columns have already been set as NOT NULL
-- check for "gross_margin_pct" and "rating" only (since they are not designed as NOT NULL)
SELECT gross_margin_pct, rating
FROM sales
WHERE (gross_margin_pct IS NULL) OR (rating IS NULL);		-- NOTE: no missing values





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































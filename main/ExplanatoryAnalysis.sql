-- -------------------------------------------------------------------------------------------------------
-- Generic questions
-- -------------------------------------------------------------------------------------------------------

USE project_walmartsales;

-- 1. How many unique cities does the data have?
SELECT 
	DISTINCT city
FROM sales;
-- Ans: 3 distinct cities in total: Yangon, Naypyitaw, Mandalay.

-- 2. In which city is each branch?
SELECT 
	DISTINCT city,
    branch
FROM sales;
-- Ans: one city is corresponded with one branch, Yangon-A, Naypyitaw-C, Mandalay-B.





-- -------------------------------------------------------------------------------------------------------
-- In-depth questions: about the products
-- -------------------------------------------------------------------------------------------------------

-- 1. How many unique product lines does the data have?
SELECT
	COUNT(DISTINCT product_line)
FROM sales;
-- Ans: 6 product_lines in total. (to get detailed info, delete "COUNT()")

-- 2. What is the most common payment method?
SELECT 
	payment_method,				
	COUNT(payment_method) AS pm_count		-- get the total count of payment method, rename the column as "count"
FROM sales
GROUP BY payment_method					-- get the count number of each payment method
										-- "GROUP BY" allows to get seperate search outcomes
ORDER BY pm_count DESC;					-- descending order
-- Ans: Cash-344 (leading payment method), Ewallet-342, Credit card-309.

-- 3. What is the most selling product line?
SELECT
	product_line,
    COUNT(product_line) AS pl_count
FROM sales
GROUP BY product_line
ORDER BY pl_count DESC;
-- Ans: "Fashion accessories" is the most selling product line.

-- 4. What is the total revenue by month?
SELECT
	DISTINCT month_name AS month,
	SUM(total) AS monthly_revenue
FROM sales
GROUP BY month_name
ORDER BY monthly_revenue DESC;
-- Ans: January-116292.11, March-108867.38, February-95727.58.

-- 5. What month had the largest COGS?
SELECT
	month_name AS month,
	SUM(cogs) AS COGS
FROM sales
GROUP BY month_name
ORDER BY COGS DESC;
-- Ans: January-110754.16, March-103683.00, February-91168.93.

-- 6. What product line had the largest revenue?
SELECT
	product_line,
    SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;
-- Ans: "Food and beverages" had the largest total revenue of 56144.96.

-- 7. What is the city with the largest revenue?
SELECT
	city,
    branch,
	SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch				-- if not include "branch", an error will be throwed out
ORDER BY total_revenue DESC;		-- SQL引擎要求SELECT列中所有要么在聚合函数（即内置函数如： MAX(), SUM(), COUNT(), etc.），要么在GROUP BY语句中，否则产生错误
-- Ans: Naypyitaw, branch C, 110490.93.
    

-- 8. What product line had the largest average tax (VAT)?
SELECT
	product_line,
    AVG(VAT) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;
-- Ans: "Home and lifestyle" had the largest average tax of 16.03033124.

-- 9. Fetch each product line and add a column to those product line
-- 	  showing "Good", "Bad". Good if its greater than average sales.


-- 10. Which branch sold more products than average product sold?
SELECT
	branch,
    SUM(quantity) AS total_sales
FROM sales
GROUP BY branch
HAVING total_sales > (SELECT AVG(quantity) FROM sales);			-- **difference between "WHERE" clause and "HAVING" clause:
																--
-- 11. What is the most common product line by gender?
SELECT
	gender,
	product_line,
    COUNT(gender) AS gender_count		-- each sale is recorded noted with gender of that buyer
FROM sales
GROUP BY gender, product_line
ORDER BY gender, gender_count DESC;
-- Ans: For females-"Fashion accessories" is the most common, while for males-"Health and beauty" is the most common.

-- 12. What is the average rating of each product line?
SELECT 
	product_line,
    AVG(rating) AS avg_rating		-- use "ROUND(AVG(rating), 2)" to round the average to 2 decimal places
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;
-- Ans: "Food and beverages"-7.11322 (leading), "Fashion accessories"- 7.02921, "Health and beauty"-6.98344,
-- 	    "Electronic accessories"-6.90651, "Sports and travel"-6.85951, "Home and lifestyle"-6.83750.





-- -------------------------------------------------------------------------------------------------------
-- In-depth questions: about the sales
-- -------------------------------------------------------------------------------------------------------

-- 1. Number of sales made in each time of the day per weekday?
SELECT 
	time_of_day,
    COUNT(*) AS total_sales
FROM sales						-- for a specific weekday, add "WHERE day_name = "XXX"" clause
GROUP BY time_of_day
ORDER BY total_sales DESC;
-- Ans: evening-429, afternoon-376, morning-190. Mostly, after work, people tend to go shopping.

-- 2. Which of the customer types brings the most revenue?
SELECT
	customer_type,
    SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;
-- Ans: "Member" brings the most revenue of 163625.47. But not significantly different from "Normal".

-- 3. Which city has the largest tax percentage (VAT: value added tax)?
SELECT 
	city,
    branch,
    AVG(VAT) AS avg_tax
FROM sales
GROUP BY city, branch
ORDER BY avg_tax DESC;
-- Ans: Naypyitaw, branch C, has the largest average tax percentage, of  16.09010850,
-- 		Mandalay, B, 15.13020824; Yangon, A, 14.87020798.

-- 4. Which customer type pays the most in VAT?
SELECT
	customer_type,
    AVG(VAT) AS avg_tax
FROM sales
GROUP BY customer_type
ORDER BY avg_tax DESC;
-- Ans: "Member" pays the most in average tax, of 15.61457214; "Normal"-15.09805040. Alomost the same, then being a member cannot provide significant advantage in VAT.





-- -------------------------------------------------------------------------------------------------------
-- In-depth questions: about the customers
-- -------------------------------------------------------------------------------------------------------

-- 1. How many unique customer types dose the data have?
SELECT 
	DISTINCT customer_type
FROM sales;
-- Ans: 2 types-"Normal" and "Member".

-- 2. Howmany unique payment method does the data have?
SELECT
	COUNT(DISTINCT payment_method)		-- only returns the number of unique entries (won't give the "names" of them)
FROM sales;
-- Ans: 3 types-"Credit card", "Ewallet" and "Cash".

-- 3. What is the most common customer type?
SELECT
	customer_type,
	COUNT(customer_type) AS customer_count
FROM sales
GROUP BY customer_type
ORDER BY customer_count DESC;
-- Ans: "Member" is the most common customer type, of 499; "Normal"-496. More like a 50-50.

-- 4. Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*) AS total_sales
FROM sales
GROUP BY customer_type
ORDER BY total_sales DESC;
-- Ans: "Member" buys the most. But the two figures-499 and 496 are not that different.

-- 5. What is the gender of most of the customers?
SELECT
	gender,
    COUNT(customer_type) AS customer_count
FROM sales
GROUP BY gender
ORDER BY customer_count DESC;
-- Ans: "Male" is slightly more than "Female"-498 vs. 497. Roughly 50-50.

-- 5.1(added by Weixi Yang) Which gender tends to have more members' purchases?
SELECT 
	gender,
    customer_type,
    (COUNT(GROUP BY gender,customer_type) / ) AS customer_count	-- 这里要改，有点问题
FROM sales
GROUP BY gender, customer_type
ORDER BY gender, customer_count DESC;
-- Ans: In both genders, "Member" had made more purchases, but "Female" has larger proportion of members' purchases.

-- 6. What is the gender distribution per branch?
SELECT
	branch,
    gender,
    COUNT(*) AS total_sales
FROM sales
GROUP BY branch, gender
ORDER BY branch;
-- Ans: branches "A" amd "B" have more male buyers, but "C" gets substaintially more female buyers.alter
-- 		This might be due to the chosen target client when designing products for the specific brand.

-- 7. Which time of the day do customers give most ratings?
SELECT
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Ans: In the afternoons, the ratings are the largest. But the differences are not big.
-- 		This might be that all the delivery service qualities are the same regardless of the time og that day.

-- 8. Which time of the day do customers give most ratings per branch?
SELECT
	branch,
    time_of_day,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY branch, time_of_day
ORDER BY branch, avg_rating DESC;
-- Ans: For branch "A"-"afternoon" with 7.18889 average rating;
-- 		For branch "B"-"morning" with 6.83793 average rating;
-- 		For branch "C"-"evening" with 7.09859 average rating.
-- 		It seems that each branch might not give the same service qualities during a day, and branch "B" is the worst (with the highest rating below 7 only).

-- 9. Which day of the week has the worst average rating?
SELECT
	day_name,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating;
-- Ans: "Wednesday" is the day of the week that receives the worst rating.
-- 		It is the middle of the workday when people tend to feel tired thus probably giving bad services dur to the low moods,
-- 		while Monday, however, is the first workday and then with the highest rating of 7.13065 (0.37037 higher than that of Wednesday) probably because of the energy restored in weekends..

-- 10. Which day of week has the best average rating per branch?
SELECT
	branch,
    day_name,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY branch, day_name
ORDER BY branch, avg_rating DESC;
-- Ans: branch "A"-Friday of 7.31200; branch "B"-Monday of 7.26579; branch "C"-Saturday of 7.22963.












 








































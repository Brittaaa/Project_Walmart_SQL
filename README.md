# Project_Walmart_SQL （Under Update!!! 维护中！！！！sql文档内容更新中！！！）

*NOTE: This project was inspired by **Code With Prince**\*. Dataset was retrieved from* [Kaggle Walmart Recruiting - Store Sales Forecasting](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting).

*\* The project was done following the [tutorial](https://www.youtube.com/watch?v=Qr1Go2gP8fo) aside with personal understanding.*

## Project Purpose

> - Get familiar with `MySQL` language and utilities as a fresh beginner.
> - Conduct an in-depth analysis of the real market with statistical knowledge.
> - Practice business analysis (BA) skills.

## Data Description

''You are provided with historical sales data for 45 Walmart stores located in different regions. Each store contains a number of departments, and you are tasked with predicting the department-wide sales for each store.''

The original dataset contains 17 features and 995 samples.

<style>     
table
{
    margin: auto;       % table centered
}
</style>



| Feature | Desription | Datatype | Setting |
| -------- | -------- | -------- | -------- |
| *invoice_id* | Num. of invoices made 销售发票编号 | VARCHAR(30) | Primary Key
| *branch* | Branches of Walmart 销售分店 | VARCHAR(5) | Not null
| *city* | Location of the branch 分店城市 | VARCHAR(30) | Not null
| *customer_type* | Type of the customer 客户类型 | VARCHAR(30) | Not null
| *gender* | Gender of the customer 客户性别 | VARCHAR(10) | Not null
| *product_line* | Product line 产品线 | VARCHAR(30) | Not null
| *unit_price* | Price of each product 产品单价 | VARCHAR(30) | Not null
| *quantity* | Amount of product sold 销售数量 | VARCHAR(30) | Not null
| *VAT* | Amount of tax on the purchase 销售税额 | VARCHAR(30) | Not null
| *total* | Total cost of the purchase 销售总额 | VARCHAR(30) | Not null
| *date* | Date on which the purchase was made 销售日期 | VARCHAR(30) | Not null
| *time* | Time at which the purchase was made 销售时间 | VARCHAR(30) | Not null
| *payment_method* | Total amount paid 付款总额 | VARCHAR(30) | Not null
| *cogs* | 行3，列2 | Cost of goods sold 成本价格 | Not null
| *gross_margin_pct* | Gross margin percentage 毛利率 | VARCHAR(30) | -
| *gross_income* | Gross income 毛利收入 | VARCHAR(30) | Not null
| *rating* | rating 评分 | VARCHAR(30) | -

## Data Preprocessing

- ### Import the dataset

  ***Code:** see CreateDatabase.sql*

- ### Check for missing values

  Before conducting any analysis, feature inspection needs to be carried to deal with NULLs or missing values. 

  --> If any, replacement methods are needed with respect to different situations. Typically cubic linear spline interpolation, mean replacement, median replacement, nearest neighbor interpolation, etc.

  Here, only "gross_margin_pct" and "rating" are not required to be NOT NULL during data entry. 

- ### Feature engineering

  Generate three new features for later analysis purposes.

  ***Code:** see DataPreprocessing.sql*

  1. Add "*time_of_day*" to give guidance on the relationship between the amount of sales and the part of the day - morning, afternoon, evening.

  2. Add "*day_name*" to specify what day of week the transaction was made - Monday, Tuesday, Wednesday, Thursday, Friday.

  3. Add "*month_name*" to specify what month of year the trasaction was made - January, Feburary, March*. 

     *\* The sales data provided only spans through these three months.*

## Explanatory Data Analysis (EDA)*

*\* This section will provide basic analysis of Walmart sales. Here, the advanced statistic techniques won't be used.*

Main questions to answer (e.g.) :

> - Which product lines perform the best and which ones need further improvement?
> - What's the sales trend? And what strategies could be designed to gain more sales?
> - What's the most profitable customer, i.e. the core target client?

*Note: all expository questions are noted in ExpositoryAnalysis.sql file, with codes to extract data and generate the answers.*

## Project Wrap-up
This project has hepled me in getting SQL language quickly on hand. Being able to process data from actual world is mind-blowing and also so much more rewarding compared to courses taken in uni.
But, future learning is still needed since this project haven't used advanced statistic models, as well as complex data sourcing structures.
Keep going with R, Python, SAS, Machine Learning, Deep Learning, etc. -- get fully equipped with required abilities for a data analyst or a data science.

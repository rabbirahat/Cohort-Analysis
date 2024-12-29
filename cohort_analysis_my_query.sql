create schema mysales;

use mysales;

CREATE TABLE IF NOT EXISTS RETAIL (
	InvoiceNo VARCHAR(10),
    StockCode VARCHAR(20),
    Description VARCHAR(100),
    Quantity DECIMAL(8,2),    -- Use Decimal for numbers with precision in MySQL
    InvoiceDate VARCHAR(25),
    UnitPrice Decimal(8,2),   -- Use DECIMAL for numbers with precision in MySQL
    CustomerID BIGINT,       -- Use BIGINT for large integer IDs
    Country VARCHAR(25)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Online Retail Data.csv'
INTO TABLE retail
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(InvoiceNo, StockCode, Description, Quantity, @date_str,
UnitPrice, CustomerID, Country)
SET InvoiceDate = STR_TO_DATE(@date_str, '%d/%m/%Y %H:%i');    



-- Cohort Analysis by Number of Orders

select count(distinct InvoiceNo) from retail;


with cte1 as (
	select InvoiceNo, InvoiceDate, CustomerID
	from retail
	where customerid is not null
),

cte2 as (
	select *,
    date_format(InvoiceDate, '%Y-%m-01') as purchase_month,
    date_format(min(InvoiceDate) over (partition by CustomerID order by InvoiceDate), '%Y-%m-01') as first_purchase_month
    from cte1
),

cte3 as(
	select 
    InvoiceNo,
    purchase_month,
    first_purchase_month,
	concat('Month_', timestampdiff(Month, first_purchase_month, purchase_month)) as cohort_month
    from cte2
)    

SELECT 
    first_purchase_month,
    SUM(CASE WHEN cohort_month = 'Month_0' THEN 1 ELSE 0 END) AS Month_0,
    SUM(CASE WHEN cohort_month = 'Month_1' THEN 1 ELSE 0 END) AS Month_1,
    SUM(CASE WHEN cohort_month = 'Month_2' THEN 1 ELSE 0 END) AS Month_2,
    SUM(CASE WHEN cohort_month = 'Month_3' THEN 1 ELSE 0 END) AS Month_3,
    SUM(CASE WHEN cohort_month = 'Month_4' THEN 1 ELSE 0 END) AS Month_4,
    SUM(CASE WHEN cohort_month = 'Month_5' THEN 1 ELSE 0 END) AS Month_5,
    SUM(CASE WHEN cohort_month = 'Month_6' THEN 1 ELSE 0 END) AS Month_6,
    SUM(CASE WHEN cohort_month = 'Month_7' THEN 1 ELSE 0 END) AS Month_7,
    SUM(CASE WHEN cohort_month = 'Month_8' THEN 1 ELSE 0 END) AS Month_8,
    SUM(CASE WHEN cohort_month = 'Month_9' THEN 1 ELSE 0 END) AS Month_9,
    SUM(CASE WHEN cohort_month = 'Month_10' THEN 1 ELSE 0 END) AS Month_10,
    SUM(CASE WHEN cohort_month = 'Month_11' THEN 1 ELSE 0 END) AS Month_11,
    SUM(CASE WHEN cohort_month = 'Month_12' THEN 1 ELSE 0 END) AS Month_12
FROM cte3
GROUP BY first_purchase_month
ORDER BY first_purchase_month;









-- Cohort Analysis for Customer

with cte1 as (
	select InvoiceNo, InvoiceDate, CustomerID
	from retail
	where customerid is not null
),

cte2 as (
	select *,
    date_format(InvoiceDate, '%Y-%m-01') as purchase_month,
    date_format(min(InvoiceDate) over (partition by CustomerID order by InvoiceDate), '%Y-%m-01') as first_purchase_month
    from cte1
),

cte3 as(
	select 
    CustomerID,
    purchase_month,
    first_purchase_month,
	concat('Month_', timestampdiff(Month, first_purchase_month, purchase_month)) as cohort_month
    from cte2
)    

SELECT 
    first_purchase_month,
    SUM(CASE WHEN cohort_month = 'Month_0' THEN 1 ELSE 0 END) AS Month_0,
    SUM(CASE WHEN cohort_month = 'Month_1' THEN 1 ELSE 0 END) AS Month_1,
    SUM(CASE WHEN cohort_month = 'Month_2' THEN 1 ELSE 0 END) AS Month_2,
    SUM(CASE WHEN cohort_month = 'Month_3' THEN 1 ELSE 0 END) AS Month_3,
    SUM(CASE WHEN cohort_month = 'Month_4' THEN 1 ELSE 0 END) AS Month_4,
    SUM(CASE WHEN cohort_month = 'Month_5' THEN 1 ELSE 0 END) AS Month_5,
    SUM(CASE WHEN cohort_month = 'Month_6' THEN 1 ELSE 0 END) AS Month_6,
    SUM(CASE WHEN cohort_month = 'Month_7' THEN 1 ELSE 0 END) AS Month_7,
    SUM(CASE WHEN cohort_month = 'Month_8' THEN 1 ELSE 0 END) AS Month_8,
    SUM(CASE WHEN cohort_month = 'Month_9' THEN 1 ELSE 0 END) AS Month_9,
    SUM(CASE WHEN cohort_month = 'Month_10' THEN 1 ELSE 0 END) AS Month_10,
    SUM(CASE WHEN cohort_month = 'Month_11' THEN 1 ELSE 0 END) AS Month_11,
    SUM(CASE WHEN cohort_month = 'Month_12' THEN 1 ELSE 0 END) AS Month_12
FROM cte3
GROUP BY first_purchase_month
ORDER BY first_purchase_month;

-- select count(distinct CustomerID) from retail;


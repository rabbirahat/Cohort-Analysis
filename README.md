# Cohort Analysis

This repository shows cohort analysis, starting from SQL queries to visualize the results in Python. The analysis focuses on understanding customer retention and purchase trends over time.

### Contents
1. SQL Queries
2. Data Overview
3. Visualizations
___


## 1. SQL Queries
- ###  Cohort Analysis by Number of Orders
```sql
WITH cte1 AS (
	SELECT InvoiceNo, InvoiceDate, CustomerID
	FROM retail
	WHERE customerid IS NOT NULL
),
cte2 AS (
	SELECT *,
		DATE_FORMAT(InvoiceDate, '%Y-%m-01') AS purchase_month,
		DATE_FORMAT(MIN(InvoiceDate) OVER (PARTITION BY CustomerID ORDER BY InvoiceDate), '%Y-%m-01') AS first_purchase_month
	FROM cte1
),
cte3 AS (
	SELECT 
		InvoiceNo,
		purchase_month,
		first_purchase_month,
		CONCAT('Month_', TIMESTAMPDIFF(MONTH, first_purchase_month, purchase_month)) AS cohort_month
	FROM cte2
)
SELECT 
	first_purchase_month,
	SUM(CASE WHEN cohort_month = 'Month_0' THEN 1 ELSE 0 END) AS Month_0,
	SUM(CASE WHEN cohort_month = 'Month_1' THEN 1 ELSE 0 END) AS Month_1,
	... -- Repeat for up to Month_12
FROM cte3
GROUP BY first_purchase_month
ORDER BY first_purchase_month;
```

- ###  Cohort Analysis for Customer Count
```sql
WITH cte1 AS (
	SELECT InvoiceNo, InvoiceDate, CustomerID
	FROM retail
	WHERE customerid IS NOT NULL
),
cte2 AS (
	SELECT *,
		DATE_FORMAT(InvoiceDate, '%Y-%m-01') AS purchase_month,
		DATE_FORMAT(MIN(InvoiceDate) OVER (PARTITION BY CustomerID ORDER BY InvoiceDate), '%Y-%m-01') AS first_purchase_month
	FROM cte1
),
cte3 AS (
	SELECT 
		CustomerID,
		purchase_month,
		first_purchase_month,
		CONCAT('Month_', TIMESTAMPDIFF(MONTH, first_purchase_month, purchase_month)) AS cohort_month
	FROM cte2
)
SELECT 
	first_purchase_month,
	SUM(CASE WHEN cohort_month = 'Month_0' THEN 1 ELSE 0 END) AS Month_0,
	SUM(CASE WHEN cohort_month = 'Month_1' THEN 1 ELSE 0 END) AS Month_1,
	... -- Repeat for up to Month_12
FROM cte3
GROUP BY first_purchase_month
ORDER BY first_purchase_month;

```
___

## 2. Data Overview
- The output of the SQL queries generates a CSV file named cohort_output.csv
![image](https://github.com/user-attachments/assets/784beada-ac8c-4f5b-ad1e-6f3576f0c091)

___

## 3. Visualizations
- ### Heatmap Visualization
![image](https://github.com/user-attachments/assets/4d79f4f2-7120-455a-a85e-bcf73098a22a)

- ### Percentage Heatmap Visualization
![image](https://github.com/user-attachments/assets/cdd35f8c-1068-4abd-a2b8-b63d4247cf76)

- ### Line Chart of Retention Trends Across Cohorts: Understand how retention varies for each cohort over time
![image](https://github.com/user-attachments/assets/b0ab8504-84b1-46f3-95e9-3337f64dcccc)

- ### Stacked Bar Chart for Monthly Orders: Analyze contributions of cohorts to total orders over time.
![image](https://github.com/user-attachments/assets/fa61b620-e550-4131-9ea5-17c4d37c1ea6)

- ### Waterfall Chart for Retention Drop-Off: Track cumulative retention drop-off across months.
![image](https://github.com/user-attachments/assets/e56957ba-28ed-483a-8c38-ce339aec941c)

- ### Box Plot of Retention Rates by Cohort Month: Explore the variability in retention rates across cohorts.
![image](https://github.com/user-attachments/assets/af2113f8-4a52-4628-b880-7140ad6879c1)

- ### Heatmap of Cumulative Retention: See how retention builds up cumulatively across months.
![image](https://github.com/user-attachments/assets/af03357c-77d1-4c6a-a99b-016cf78f9b98)












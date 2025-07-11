# Website traffic analysis in E-commerce Using SQL 
<img width="1600" height="840" alt="website-traffic-602f6449e0824" src="https://github.com/user-attachments/assets/f707573a-7f29-4df1-ae79-7d8584ed53a7" />


Author: Nguyen Anh Huy

Date: 19/02/2025

Tools used: SQL (Google BigQuery)

## Table of Contents
[📌 Background & Overview](https://github.com/yuhanguyen/Explore-E-Commerce-Dataset/blob/main/README.md#i-background--overview)

[📂 Dataset Description & Data Structure](https://github.com/yuhanguyen/Explore-E-Commerce-Dataset/blob/main/README.md#ii-requirement)

[⚒️ Main Process](https://github.com/yuhanguyen/Explore-E-Commerce-Dataset/blob/main/README.md#iii-dataset-access)

[🔎 Final Conclusion & Recommendations](https://github.com/yuhanguyen/Explore-E-Commerce-Dataset/blob/main/README.md#iv-main-process)


## 📌 Background & Overview

### 📌 What is this project about?

This project leverages **SQL** and **Google BigQuery** to analyze an e-commerce website’s performance by answering key business questions related to **user traffic**, **customer engagement**, and **purchase behavior** over time.

By exploring real-world web session data, the project provides a comprehensive view of how users interact with the website—from landing on a page to completing a transaction.

---

### 🧠 Business Questions Addressed

- 📈 How does **website traffic, engagement, and revenue** change over time?
- 🌐 Which **traffic sources** (e.g., Google, YouTube, Direct, etc.) contribute most to **revenue**, both weekly and monthly?
- 👥 What is the behavioral difference in **pageviews and transaction rates** between **purchasers vs. non-purchasers**?
- 🔄 What does the **customer journey** look like—from product view → add-to-cart → checkout → final purchase?

---

### 👥 Who is this project for?

This analysis is designed to support:

- 📊 **Data Analysts & Business Analysts** — for extracting actionable insights.
- 📣 **Digital Marketing Teams** — to optimize traffic sources and reduce bounce rates.
- 🛍️ **E-commerce Managers & Stakeholders** — to monitor KPIs and understand customer behavior.
- 📈 **Business Intelligence (BI) Teams** — to integrate funnel performance into dashboards and reporting.

---


## 📂 Dataset Description & Access

### 📊 Dataset Overview

This project uses the **public Google Analytics Sample Dataset**, specifically the `ga_sessions_2017` tables. These tables contain detailed information on user interactions with an e-commerce website, including sessions, pageviews, purchases, and revenue data.

The dataset is hosted on **Google BigQuery** and includes both standard and nested fields representing user activity at session and hit levels.

---

### 🔑 Key Fields

| Field Name | Description |
|------------|-------------|
| `date` | Date of the session in `YYYYMMDD` format |
| `fullVisitorId` | Unique identifier for each website visitor |
| `totals.visits` | Number of visits during the session |
| `totals.pageviews` | Number of pages viewed in the session |
| `totals.transactions` | Number of completed transactions |
| `totals.totalTransactionRevenue` | Total revenue from the session (in micros, divide by 1,000,000 for USD) |
| `hits.eCommerceAction.action_type` | User interaction type (e.g. product view, add-to-cart, checkout, purchase) |
| `hits.product` | Product details (name, quantity, revenue per item) |

> **Note**: Fields like `hits` and `product` are **nested records**, requiring use of `UNNEST()` in BigQuery SQL queries.

---

### 🗂️ How to Access the Dataset

Follow the steps below to access the dataset using Google BigQuery:

1. Log in to your **Google Cloud Platform (GCP)** account.
2. Create a new project (or select an existing one).
3. Go to the **BigQuery Console**.
4. In the left-hand panel, click **"Add data"** > **"Search for a project"**.
5. Enter the project ID: bigquery-public-data
6. In the dataset list, locate and click:  
google_analytics_sample > ga_sessions_2017*
7. Click on any `ga_sessions_2017XX` table to explore session data by day.

> This dataset is publicly available, so no billing is incurred for querying within the free tier limits.
 


## ⚒️ Main Process

In this project, I wrote 8 SQL queries using BigQuery to uncover key insights from an e-commerce dataset.

---

### 📌 Query 01: Monthly total visits, pageviews, and transactions (Jan–Mar 2017)

> 🎯 Analyze the overall traffic and transaction trends over the first quarter of 2017.

```sql
SELECT
  SUBSTR(date, 1, 6) AS month,
  SUM(totals.visits) AS visits,
  SUM(totals.pageviews) AS pageviews,
  SUM(totals.transactions) AS transactions
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
WHERE _table_suffix between '0101' AND '0331'
GROUP BY month
ORDER BY month
```

Result:

![image](https://github.com/user-attachments/assets/60fac2ca-cc39-4b37-8584-86f710f298d4)

---

### 📌 Query 02: Bounce rate per traffic source (July 2017)

> 🎯 Identify which traffic sources had the highest bounce rates and which retained users better.

```SQL
SELECT
  DISTINCT trafficSource.source AS source,
  SUM(totals.visits) AS total_visit,
  SUM(totals.bounces) AS total_no_of_bounces,
  ROUND(100.00 * SUM(totals.bounces) / SUM(totals.visits), 3) AS bounce_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
WHERE _table_suffix between '0701' AND '0731'
GROUP BY source
ORDER BY total_visit DESC
;
```

Result:

![image](https://github.com/user-attachments/assets/32830887-8d91-4aec-9a57-aee822faa71e)

---

### 📌 Query 03: Revenue by traffic source by week and month (June 2017)

> 🎯 Understand which channels contributed the most revenue weekly and monthly in June.

```SQL
SELECT
  'Month' as time_type, --month
  SUBSTR(date, 1, 6) AS time,
  trafficSource.source AS source,
  ROUND(SUM(productRevenue) / 1000000.0, 4) AS revenue
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
UNNEST (hits) hits,
UNNEST (hits.product) product
WHERE product.productRevenue is not null
AND _table_suffix between '0601' AND '0631'
GROUP BY time_type, time, source
UNION DISTINCT
SELECT
  'Week' as time_type,
  FORMAT_TIMESTAMP('%Y%W', PARSE_TIMESTAMP('%Y%m%d', date)) AS time,
  trafficSource.source AS source,
  ROUND(SUM(productRevenue) / 1000000.0, 4) AS revenue
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
UNNEST (hits) hits,
UNNEST (hits.product) product
WHERE product.productRevenue is not null
AND _table_suffix between '0601' AND '0631'
GROUP BY time_type, time, source
ORDER BY revenue DESC
;
```

Result:

![image](https://github.com/user-attachments/assets/18135301-947d-482f-ad00-6597c96943e0)

---

### 📌 Query 04: Average pageviews by purchaser vs non-purchaser (June–July 2017)

> 🎯 Compare engagement between users who purchased and those who didn’t.

```SQL
WITH purchasers AS (
SELECT
  SUBSTR(date, 1, 6) AS month,
  SUM(totals.pageviews) / COUNT(DISTINCT fullVisitorId) AS avg_pageviews_purchase
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
UNNEST (hits) hits,
UNNEST (hits.product) product
WHERE _table_suffix between '0601' AND '0731'
AND totals.transactions >= 1
AND productRevenue IS NOT NULL
GROUP BY month
ORDER BY month
)
,
non_purchasers AS (
SELECT
  SUBSTR(date, 1, 6) AS month,
  SUM(totals.pageviews) / COUNT(DISTINCT fullVisitorId) AS avg_pageviews_non_purchase
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
UNNEST (hits) hits,
UNNEST (hits.product) product
WHERE _table_suffix between '0601' AND '0731'
AND totals.transactions IS NULL
AND productRevenue IS NULL
GROUP BY month
ORDER BY month
)

SELECT
  p.month,
  avg_pageviews_purchase,
  avg_pageviews_non_purchase
FROM purchasers AS p
LEFT JOIN non_purchasers AS n
ON p.month = n.month
ORDER BY month
;
```

Result:

![image](https://github.com/user-attachments/assets/07f8b001-e606-4837-8bba-2a39e829eb5e)

---

### 📌 Query 05: Average number of transactions per purchasing user (July 2017)

> 🎯 Measure how many purchases each buyer typically makes in a month.

```SQL
SELECT
  SUBSTR(date, 1, 6) AS month,
  SUM(totals.transactions) / COUNT(DISTINCT fullVisitorId) AS Avg_total_transactions_per_user
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
UNNEST (hits) hits,
UNNEST (hits.product) product
WHERE _table_suffix between '0701' AND '0731'
AND totals.transactions >= 1
AND productRevenue IS NOT NULL
GROUP BY month
;
```

Result:

![image](https://github.com/user-attachments/assets/f1271ac3-4a68-417a-baac-be917827bc74)

---

### 📌 Query 06: Average revenue per session for purchasers (July 2017)

> 🎯 Estimate how much revenue each purchasing session generates on average.

```SQL
SELECT
  SUBSTR(date, 1, 6) AS month,
  ROUND((SUM(productRevenue) / SUM(totals.visits)) / 1000000, 2) AS avg_revenue_by_user_per_visit
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
UNNEST (hits) hits,
UNNEST (hits.product) product
WHERE _table_suffix between '0701' AND '0731'
AND totals.transactions IS NOT NULL
AND productRevenue IS NOT NULL
GROUP BY month
;
```

Result:

![image](https://github.com/user-attachments/assets/7e061f65-5fbe-47fb-8112-1999337be49f)

---

### 📌 Query 07: Other products purchased by customers who bought "YouTube Men's Vintage Henley" (July 2017)

> 🎯 Find product associations by identifying frequently co-purchased items.

```SQL
WITH t1 AS (
SELECT
  DISTINCT fullVisitorId,
  v2ProductName,
  productQuantity
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
UNNEST (hits) hits,
UNNEST (hits.product) product
WHERE _table_suffix between '0701' AND '0731'
AND v2ProductName = "YouTube Men's Vintage Henley"
AND productQuantity IS NOT NULL
AND totals.transactions IS NOT NULL
)
,
t2 AS (
SELECT
  DISTINCT fullVisitorId,
  v2ProductName,
  productQuantity
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
UNNEST (hits) hits,
UNNEST (hits.product) product
WHERE _table_suffix between '0701' AND '0731'
AND v2ProductName <> "YouTube Men's Vintage Henley"
AND productQuantity IS NOT NULL
AND totals.transactions IS NOT NULL
)


SELECT
  t2.v2ProductName AS other_purchased_products,
  SUM(t2.productQuantity) AS quantity
FROM t1
LEFT JOIN t2
ON t1.fullVisitorId = t2.fullVisitorId
GROUP BY t2.v2ProductName
ORDER BY quantity DESC
;
```

Result:

![image](https://github.com/user-attachments/assets/36c85c20-6053-4063-99ae-30f3030c2a84)

---

### 📌 Query 08: Funnel analysis from product view → add to cart → purchase (Jan–Mar 2017)

> 🎯 Build a conversion funnel to track drop-off rates between product view, add-to-cart, and final purchase.

```SQL
WITH pview AS (
SELECT
  SUBSTR(date, 1, 6) AS month,
  COUNT(eCommerceAction.action_type) AS num_product_view
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
UNNEST (hits) hits
WHERE _table_suffix between '0101' AND '0331'
AND eCommerceAction.action_type = '2'
GROUP BY month
ORDER BY month
)
,
add_to_cart AS (
SELECT
  SUBSTR(date, 1, 6) AS month,
  COUNT(eCommerceAction.action_type) AS num_addtocart
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
UNNEST (hits) hits
WHERE _table_suffix between '0101' AND '0331'
AND eCommerceAction.action_type = '3'
GROUP BY month
ORDER BY month
)
,
purchase AS (
SELECT
  SUBSTR(date, 1, 6) AS month,
  COUNT(eCommerceAction.action_type) AS num_purchase
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
UNNEST (hits) hits,
UNNEST (hits.product) product
WHERE _table_suffix between '0101' AND '0331'
AND eCommerceAction.action_type = '6'
AND productRevenue IS NOT NULL
GROUP BY month
ORDER BY month
)

SELECT
  pview.month,
  num_product_view,
  num_addtocart,
  num_purchase,
  ROUND(100.00 * num_addtocart / num_product_view , 2) AS add_to_cart_rate,
  ROUND(100.00 * num_purchase / num_product_view , 2) AS purchase_rate
FROM pview
LEFT JOIN add_to_cart
ON pview.month = add_to_cart.month
LEFT JOIN purchase
ON add_to_cart.month = purchase.month
ORDER BY pview.month
;
```

Result:

![image](https://github.com/user-attachments/assets/e4764ad9-a403-4897-8871-3fba4a1a0b54)

---

## 🔎 Final Conclusion & Recommendations

📌 Insights

+ **Traffic trends**: Website traffic shows steady growth, with March 2017 recorded the highest traffic (69931). Pageviews and Transactions also had similar patterns.
+ **Revenue per traffic sources**: Direct source recorded the highest revenue (97333.6197) in June 2017, followed by Google Search (18757.1799) and dfa (Direct, From Address bar) with 8862.23. Other sources like mail.google.com and search.myway.com recorded negligible revenue.
+ **User behavior trends**: About 75% users who visited the website didn't purchase anything. For purchasers, they made an average of 4.16 transactions and spent about 43.86 per session in July 2017. Cross-selling is possible because customers who purchased the "YouTube Men's Vintage Henley" expressed interest in similar items like "Google Sunglasses" or "Google Men's Vintage Badge Tee Black".
+ **User journey**: Only about 35% users showed interest in the products by adding them to cart, and only about 30% users made their way to the payment step after selecting their items, recorded an average of 9.5% purchase rate for the whole journey (product view → add-to-cart → checkout → final purchase) across the first 3 months of 2017.

📌 Recommendations

1. **Focus on Direct & SEO**: Boost Google Ads and Search Engine Optimization spending and raise brand recognition to take advantage of high-converting direct traffic.
2. **Improve the purchasing process**: Optimize the purchasing interface, especially the payment stage, to make it more convenient for customers.
3. **Offers for cross-selling**: Make offers for products like "Google Sunglasses" or "Google Men's Vintage Badge Tee Black"









-- Query 01: calculate total visit, pageview, transaction for Jan, Feb and March 2017 (order by month)
SELECT
  SUBSTR(date, 1, 6) AS month,
  SUM(totals.visits) AS visits,
  SUM(totals.pageviews) AS pageviews,
  SUM(totals.transactions) AS transactions
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
WHERE _table_suffix between '0101' AND '0331'
GROUP BY month
ORDER BY month
;

-- Query 02: Bounce rate per traffic source in July 2017 (Bounce_rate = num_bounce/total_visit) (order by total_visit DESC)
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

-- Query 3: Revenue by traffic source by week, by month in June 2017
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

-- Query 04: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017.
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

-- Query 05: Average number of transactions per user that made a purchase in July 2017
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

-- Query 06: Average amount of money spent per session. Only include purchaser data in July 2017
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

-- Query 07: Other products purchased by customers who purchased the product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.
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
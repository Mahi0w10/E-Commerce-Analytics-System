-- E-Commerce Analytics System
-- Business Analysis Queries
-- Database: olist_ecommerce_analytics

USE olist_ecommerce_analytics;

-- 1. Total Orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- 2. Total Revenue (Product Price + Freight)
SELECT ROUND(SUM(price + freight_value), 2) AS total_revenue
FROM order_items;

-- 3. Monthly Revenue Trend
SELECT
DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_purchase_timestamp IS NOT NULL
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY month;

-- 4. Top 10 Product Categories by Revenue
SELECT
COALESCE(ct.product_category_name_english, p.product_category_name) AS category,
ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
ON p.product_category_name = ct.product_category_name
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;

-- 5. Order Status Distribution
SELECT
order_status,
COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- 6. Payment Method Analysis
SELECT
payment_type,
COUNT(*) AS payment_records,
ROUND(SUM(payment_value), 2) AS total_payment
FROM payments
GROUP BY payment_type
ORDER BY total_payment DESC;

-- 7. Average Customer Review Rating
SELECT ROUND(AVG(review_score), 2) AS average_rating
FROM reviews;

-- 8. Late Delivery Analysis
SELECT
COUNT(*) AS delivered_orders,
SUM(
CASE
WHEN order_delivered_customer_date > order_estimated_delivery_date
THEN 1 ELSE 0
END
) AS late_orders,
ROUND(
100.0 * SUM(
CASE
WHEN order_delivered_customer_date > order_estimated_delivery_date
THEN 1 ELSE 0
END
) / NULLIF(COUNT(*), 0),
2
) AS late_delivery_percentage
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
AND order_estimated_delivery_date IS NOT NULL;

-- 9. Top 10 Product Categories by Orders
SELECT
COALESCE(ct.product_category_name_english, p.product_category_name) AS category,
COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
ON p.product_category_name = ct.product_category_name
GROUP BY category
ORDER BY total_orders DESC
LIMIT 10;

-- 10. Top 10 States by Customer Count
SELECT
customer_state,
COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers
GROUP BY customer_state
ORDER BY unique_customers DESC
LIMIT 10;

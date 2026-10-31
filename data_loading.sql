CREATE DATABASE olist_ecommerce_analytics;
USE olist_ecommerce_analytics;
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY NOT NULL,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    order_status VARCHAR(30) NOT NULL,
    order_purchase_timestamp DATETIME NOT NULL,
    order_approved_at DATETIME NULL,
    order_delivered_carrier_date DATETIME NULL,
    order_delivered_customer_date DATETIME NULL,
    order_estimated_delivery_date DATETIME NOT NULL,
    
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY NOT NULL,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm DECIMAL(10,2),
    product_height_cm DECIMAL(10,2),
    product_width_cm DECIMAL(10,2)
);
CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY NOT NULL,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);
CREATE TABLE order_items (
    order_id VARCHAR(50) NOT NULL,
    order_item_id INT NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    seller_id VARCHAR(50) NOT NULL,
    shipping_limit_date DATETIME,
    price DECIMAL(10,2) NOT NULL,
    freight_value DECIMAL(10,2),

    PRIMARY KEY (order_id, order_item_id),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    FOREIGN KEY (seller_id)
        REFERENCES sellers(seller_id)
);
CREATE TABLE payments (
    order_id VARCHAR(50) NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type VARCHAR(30) NOT NULL,
    payment_installments INT NOT NULL,
    payment_value DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);
CREATE TABLE reviews (
    review_id VARCHAR(50) PRIMARY KEY NOT NULL,
    order_id VARCHAR(50) NOT NULL,
    review_score INT NOT NULL,
    review_comment_title VARCHAR(255),
    review_comment_message VARCHAR(1000),
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);
CREATE TABLE geolocation (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat DECIMAL(10,7),
    geolocation_lng DECIMAL(10,7),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(10)
);
CREATE TABLE category_translation (
    product_category_name VARCHAR(100) PRIMARY KEY NOT NULL,
    product_category_name_english VARCHAR(100)
);




LOAD DATA LOCAL INFILE 'C:/olist/olist_geolocation_dataset.csv'
INTO TABLE olist_ecommerce_analytics.geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
);
USE olist_ecommerce_analytics;
TRUNCATE TABLE orders;
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE order_items;
TRUNCATE TABLE payments;
TRUNCATE TABLE reviews;
TRUNCATE TABLE orders;

SET FOREIGN_KEY_CHECKS = 1;
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE order_items;
TRUNCATE TABLE payments;
TRUNCATE TABLE reviews;
TRUNCATE TABLE orders;

SET FOREIGN_KEY_CHECKS = 1;
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE order_items;
TRUNCATE TABLE payments;
TRUNCATE TABLE reviews;
TRUNCATE TABLE orders;
LOAD DATA LOCAL INFILE 'C:/Users/Lenovo/OneDrive/Desktop/E-Commerce Analytics System/Dataset/olist_orders_dataset.csv'
INTO TABLE olist_ecommerce_analytics.orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
);
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = ON;
SHOW VARIABLES LIKE 'local_infile';
LOAD DATA LOCAL INFILE 'C:/Users/Lenovo/OneDrive/Desktop/E-Commerce Analytics System/Dataset/olist_orders_dataset.csv'
INTO TABLE olist_ecommerce_analytics.orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
);
SELECT COUNT(*) AS total_orders
FROM orders;
TRUNCATE TABLE order_items;
LOAD DATA LOCAL INFILE 'C:/E-Commerce Analytics System/Dataset/olist_order_items_dataset.csv'
INTO TABLE olist_ecommerce_analytics.order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
);
SELECT COUNT(*) AS total_order_items
FROM order_items;
SHOW WARNINGS LIMIT 20;
SHOW CREATE TABLE order_items;
SHOW INDEX FROM order_items;
TRUNCATE TABLE order_items;
LOAD DATA LOCAL INFILE 'C:/E-Commerce Analytics System/Dataset/olist_order_items_dataset.csv'
INTO TABLE olist_ecommerce_analytics.order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
);
SHOW WARNINGS LIMIT 20;
SELECT COUNT(*) AS missing_products
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) AS missing_sellers
FROM order_items oi
LEFT JOIN sellers s ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

SELECT COUNT(*) AS missing_orders
FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;
SELECT COUNT(*) AS missing_products
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;
SELECT COUNT(*) AS missing_sellers
FROM order_items oi
LEFT JOIN sellers s ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;
TRUNCATE TABLE products;
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE products;
LOAD DATA LOCAL INFILE 'C:/E-Commerce Analytics System/Dataset/olist_products_dataset.csv'
INTO TABLE olist_ecommerce_analytics.products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    product_id,
    product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
);
SHOW WARNINGS LIMIT 20;
SELECT COUNT(*) AS total_products
FROM products;
TRUNCATE TABLE order_items;
LOAD DATA LOCAL INFILE 'C:/E-Commerce Analytics System/Dataset/olist_order_items_dataset.csv'
INTO TABLE olist_ecommerce_analytics.order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
);
TRUNCATE TABLE payments;
LOAD DATA LOCAL INFILE 'C:/E-Commerce Analytics System/Dataset/olist_order_payments_dataset.csv'
INTO TABLE olist_ecommerce_analytics.payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
);
SELECT COUNT(*) AS total_payments
FROM payments;
USE olist_ecommerce_analytics;

ALTER TABLE reviews
DROP PRIMARY KEY;
TRUNCATE TABLE reviews;
LOAD DATA LOCAL INFILE 'C:/E-Commerce Analytics System/Dataset/olist_order_reviews_dataset.csv'
INTO TABLE olist_ecommerce_analytics.reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
);
SELECT COUNT(*) AS total_reviews
FROM reviews;
SET FOREIGN_KEY_CHECKS = 1;
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL
SELECT 'category_translation', COUNT(*) FROM category_translation;
SELECT
    (SELECT COUNT(*) FROM orders) AS total_orders,
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM products) AS total_products,
    (SELECT COUNT(*) FROM sellers) AS total_sellers,
    (SELECT COUNT(*) FROM reviews) AS total_reviews;
SELECT
    SUM(price) AS total_product_revenue,
    SUM(freight_value) AS total_freight,
    SUM(price + freight_value) AS total_order_value
FROM order_items;
SELECT
    ROUND(
        SUM(price + freight_value) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM order_items;
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;
SELECT
    COALESCE(p.product_category_name, 'Unknown') AS category,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;
SELECT
    oi.seller_id,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
FROM order_items oi
GROUP BY oi.seller_id
ORDER BY revenue DESC
LIMIT 10;
SELECT
    o.customer_id,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_spending
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY total_spending DESC
LIMIT 10;
SELECT
    oi.product_id,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
FROM order_items oi
GROUP BY oi.product_id
ORDER BY revenue DESC
LIMIT 10;
SELECT
    product_id,
    COUNT(*) AS units_sold
FROM order_items
GROUP BY product_id
ORDER BY units_sold DESC
LIMIT 10;
SELECT
    ROUND(AVG(review_score), 2) AS average_review_score
FROM reviews;
SELECT
    review_score,
    COUNT(*) AS review_count
FROM reviews
GROUP BY review_score
ORDER BY review_score;
SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;
SELECT
    payment_type,
    COUNT(*) AS payment_count,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;
SELECT
    payment_installments,
    COUNT(*) AS payment_count
FROM payments
GROUP BY payment_installments
ORDER BY payment_installments;
SELECT
    order_id,
    payment_type,
    payment_sequential,
    payment_value
FROM payments
WHERE payment_installments = 0;
SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;
SELECT
    ROUND(SUM(price), 2) AS total_product_revenue,
    ROUND(SUM(freight_value), 2) AS total_freight,
    ROUND(SUM(price + freight_value), 2) AS total_order_value
FROM order_items;
SELECT
    ROUND(
        SUM(price + freight_value) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM order_items;
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;
SELECT
    COALESCE(p.product_category_name, 'Unknown') AS category,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;
SELECT
    oi.seller_id,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
FROM order_items oi
GROUP BY oi.seller_id
ORDER BY revenue DESC
LIMIT 10;
SELECT
    o.customer_id,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_spent
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY total_spent DESC
LIMIT 10;
SELECT
    oi.product_id,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
FROM order_items oi
GROUP BY oi.product_id
ORDER BY revenue DESC
LIMIT 10;
SELECT
    product_id,
    COUNT(*) AS units_sold
FROM order_items
GROUP BY product_id
ORDER BY units_sold DESC
LIMIT 10;
SELECT
    ROUND(AVG(review_score), 2) AS average_review_score
FROM reviews;
SELECT
    review_score,
    COUNT(*) AS review_count
FROM reviews
GROUP BY review_score
ORDER BY review_score;
SELECT
    payment_type,
    COUNT(*) AS payment_count,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;
SELECT
    payment_installments,
    COUNT(*) AS payment_count
FROM payments
GROUP BY payment_installments
ORDER BY payment_installments;
SELECT
    order_id,
    payment_type,
    payment_sequential,
    payment_value
FROM payments
WHERE payment_installments = 0;
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(
        SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS repeat_customer_percentage
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) AS customer_orders;
SELECT
    COALESCE(ct.product_category_name_english, oi.product_id) AS category,
    COUNT(DISTINCT oi.order_id) AS orders,
    SUM(oi.order_item_id) AS items_sold,
    ROUND(SUM(oi.price), 2) AS revenue
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;
SELECT
    COALESCE(ct.product_category_name_english, p.product_category_name, 'Unknown') AS category,
    COUNT(DISTINCT oi.order_id) AS orders,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS revenue
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;
SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS orders,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS revenue
FROM order_items oi
JOIN sellers s
    ON oi.seller_id = s.seller_id
GROUP BY s.seller_id, s.seller_city, s.seller_state
ORDER BY revenue DESC
LIMIT 10;
SELECT COUNT(*) AS total_orders
FROM orders;
SELECT COUNT(*) AS total_products
FROM products;
SELECT COUNT(*) AS total_order_items
FROM order_items;
SELECT COUNT(*) AS total_payments
FROM payments;
SELECT COUNT(*) AS total_reviews
FROM reviews;
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT review_id) AS unique_review_ids,
    COUNT(DISTINCT CONCAT(review_id, '-', order_id)) AS unique_review_order_pairs
FROM reviews;
SHOW CREATE TABLE reviews;
SHOW INDEX FROM reviews;
SELECT COUNT(*) AS total_orders FROM orders;
SELECT COUNT(*) AS total_products FROM products;
SELECT COUNT(*) AS total_order_items FROM order_items;
SELECT COUNT(*) AS total_payments FROM payments;
SELECT COUNT(*) AS total_reviews FROM reviews;
SELECT
    ROUND(SUM(price), 2) AS total_product_revenue,
    ROUND(SUM(freight_value), 2) AS total_freight,
    ROUND(SUM(price + freight_value), 2) AS total_order_value
FROM order_items;
SELECT
    ROUND(
        SUM(price + freight_value) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM order_items;
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(*) AS order_count
FROM orders
WHERE order_status = 'delivered'
GROUP BY month
ORDER BY month;
SELECT
    COALESCE(ct.product_category_name_english, 'Unknown') AS category,
    COUNT(DISTINCT oi.order_id) AS orders,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS revenue
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;
SELECT
    oi.seller_id,
    ROUND(SUM(oi.price), 2) AS revenue
FROM order_items oi
GROUP BY oi.seller_id
ORDER BY revenue DESC
LIMIT 10;
SELECT
    o.customer_id,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_spent
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY total_spent DESC
LIMIT 10;
SELECT
    oi.product_id,
    ROUND(SUM(oi.price), 2) AS revenue
FROM order_items oi
GROUP BY oi.product_id
ORDER BY revenue DESC
LIMIT 10;
SELECT
    oi.product_id,
    COUNT(*) AS units_sold
FROM order_items oi
GROUP BY oi.product_id
ORDER BY units_sold DESC
LIMIT 10;
SELECT
    ROUND(AVG(review_score), 2) AS average_review_score
FROM reviews;
SELECT
    review_score,
    COUNT(*) AS review_count
FROM reviews
GROUP BY review_score
ORDER BY review_score;
SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;
SELECT
    payment_type,
    COUNT(*) AS payment_count,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;
SELECT
    payment_installments,
    COUNT(*) AS payment_count
FROM payments
GROUP BY payment_installments
ORDER BY payment_installments;
SELECT
    order_id,
    payment_type,
    payment_sequential,
    payment_value
FROM payments
WHERE payment_installments = 0;
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(
        SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS repeat_customer_percentage
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) AS customer_orders;
SELECT
    CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date
            THEN 'On Time'
        WHEN order_delivered_customer_date > order_estimated_delivery_date
            THEN 'Late'
        ELSE 'Not Delivered'
    END AS delivery_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY delivery_status
ORDER BY order_count DESC;
SELECT
    ROUND(
        SUM(
            CASE
                WHEN order_delivered_customer_date > order_estimated_delivery_date
                THEN 1 ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS late_delivery_percentage
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;
SELECT
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ),
        2
    ) AS average_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;
SELECT
    o.customer_id,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_spent
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY total_spent DESC
LIMIT 10;
SELECT
    o.order_status,
    ROUND(AVG(r.review_score), 2) AS average_review_score,
    COUNT(*) AS review_count
FROM orders o
JOIN reviews r
    ON o.order_id = r.order_id
GROUP BY o.order_status
ORDER BY average_review_score DESC;
SELECT
    payment_type,
    COUNT(*) AS payment_count,
    ROUND(SUM(payment_value), 2) AS total_payment_value,
    ROUND(AVG(payment_value), 2) AS average_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(
        SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS repeat_customer_percentage
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) AS customer_orders;
SELECT
    CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date
            THEN 'On Time'
        WHEN order_delivered_customer_date > order_estimated_delivery_date
            THEN 'Late'
        ELSE 'Not Delivered'
    END AS delivery_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY delivery_status
ORDER BY order_count DESC;
SELECT
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ),
        2
    ) AS average_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;
SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'Unknown'
    ) AS category,
    COUNT(DISTINCT oi.order_id) AS orders,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS revenue
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;
SELECT COUNT(*) AS total_order_items
FROM order_items;
SELECT COUNT(*) AS total_products
FROM products;
SELECT COUNT(*) AS total_payments
FROM payments;
SELECT COUNT(*) AS total_reviews
FROM reviews;
SELECT
    (SELECT COUNT(*) FROM customers) AS customers,
    (SELECT COUNT(*) FROM orders) AS orders,
    (SELECT COUNT(*) FROM order_items) AS order_items,
    (SELECT COUNT(*) FROM products) AS products,
    (SELECT COUNT(*) FROM payments) AS payments,
    (SELECT COUNT(*) FROM reviews) AS reviews;
SELECT
    ROUND(SUM(price), 2) AS total_product_revenue,
    ROUND(SUM(freight_value), 2) AS total_freight,
    ROUND(SUM(price + freight_value), 2) AS total_order_value
FROM order_items;
SELECT
    ROUND(SUM(price), 2) AS total_product_revenue,
    ROUND(SUM(freight_value), 2) AS total_freight,
    ROUND(SUM(price + freight_value), 2) AS total_order_value
FROM order_items;
SELECT
    ROUND(
        SUM(price + freight_value) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM order_items;
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(*) AS order_count
FROM orders
WHERE order_status = 'delivered'
GROUP BY month
ORDER BY month;
SELECT
    oi.seller_id,
    ROUND(SUM(oi.price), 2) AS revenue
FROM order_items oi
GROUP BY oi.seller_id
ORDER BY revenue DESC
LIMIT 10;
SELECT
    o.customer_id,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_spent
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY total_spent DESC
LIMIT 10;
SELECT
    oi.product_id,
    ROUND(SUM(oi.price), 2) AS revenue
FROM order_items oi
GROUP BY oi.product_id
ORDER BY revenue DESC
LIMIT 10;
SELECT
    oi.product_id,
    COUNT(*) AS units_sold
FROM order_items oi
GROUP BY oi.product_id
ORDER BY units_sold DESC
LIMIT 10;
SELECT
    ROUND(AVG(review_score), 2) AS average_review_score
FROM reviews;
SELECT
    review_score,
    COUNT(*) AS review_count
FROM reviews
GROUP BY review_score
ORDER BY review_score;
SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;
SELECT
    payment_type,
    COUNT(*) AS payment_count,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;
SELECT
    payment_installments,
    COUNT(*) AS payment_count
FROM payments
GROUP BY payment_installments
ORDER BY payment_installments;
SELECT
    order_id,
    payment_type,
    payment_sequential,
    payment_value
FROM payments
WHERE payment_installments = 0;
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(
        SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS repeat_customer_percentage
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) AS customer_orders;
SELECT
    (SELECT COUNT(*) FROM customers) AS customers,
    (SELECT COUNT(*) FROM orders) AS orders,
    (SELECT COUNT(*) FROM order_items) AS order_items,
    (SELECT COUNT(*) FROM products) AS products,
    (SELECT COUNT(*) FROM payments) AS payments,
    (SELECT COUNT(*) FROM reviews) AS reviews,
    (SELECT COUNT(*) FROM sellers) AS sellers;
    
USE olist_ecommerce_analytics;
TRUNCATE TABLE orders;
USE olist_ecommerce_analytics;

LOAD DATA LOCAL INFILE 'C:/Users/Lenovo/OneDrive/Desktop/E-Commerce Analytics System/Dataset/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    customer_id,
    order_status,
    @purchase,
    @approved,
    @carrier,
    @customer,
    @estimated
)
SET
    order_purchase_timestamp = NULLIF(@purchase, ''),
    order_approved_at = NULLIF(@approved, ''),
    order_delivered_carrier_date = NULLIF(@carrier, ''),
    order_delivered_customer_date = NULLIF(@customer, ''),
    order_estimated_delivery_date = NULLIF(@estimated, '');
    
USE olist_ecommerce_analytics;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE orders;

SET FOREIGN_KEY_CHECKS = 1;
    
SET GLOBAL local_infile = ON;

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = ON;
SHOW VARIABLES LIKE 'local_infile';
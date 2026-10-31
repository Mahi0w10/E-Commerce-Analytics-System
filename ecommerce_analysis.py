import pandas as pd
import mysql.connector


# =====================================================
# 1. CONNECT PYTHON WITH MYSQL
# =====================================================

connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Mahi@123",
    database="olist_ecommerce_analytics"
)

print("MySQL Connected Successfully!")


# =====================================================
# 2. LOAD DATA FROM MYSQL
# =====================================================

orders = pd.read_sql("SELECT * FROM orders", connection)
order_items = pd.read_sql("SELECT * FROM order_items", connection)
products = pd.read_sql("SELECT * FROM products", connection)
customers = pd.read_sql("SELECT * FROM customers", connection)
payments = pd.read_sql("SELECT * FROM payments", connection)
reviews = pd.read_sql("SELECT * FROM reviews", connection)


# =====================================================
# 3. BASIC DATA INFORMATION
# =====================================================

print("\n===== DATASET SHAPES =====")

print("Orders:", orders.shape)
print("Order Items:", order_items.shape)
print("Products:", products.shape)
print("Customers:", customers.shape)
print("Payments:", payments.shape)
print("Reviews:", reviews.shape)


# =====================================================
# 4. CHECK MISSING VALUES
# =====================================================

print("\n===== MISSING VALUES =====")

print("\nOrders:")
print(orders.isnull().sum())

print("\nProducts:")
print(products.isnull().sum())

print("\nCustomers:")
print(customers.isnull().sum())


# =====================================================
# 5. CONVERT DATE COLUMNS
# =====================================================

date_columns = [
    "order_purchase_timestamp",
    "order_approved_at",
    "order_delivered_carrier_date",
    "order_delivered_customer_date",
    "order_estimated_delivery_date"
]

for column in date_columns:
    orders[column] = pd.to_datetime(
        orders[column],
        errors="coerce"
    )


# =====================================================
# 6. DELIVERY TIME ANALYSIS
# =====================================================

delivered_orders = orders[
    orders["order_delivered_customer_date"].notna()
].copy()

delivered_orders["delivery_days"] = (
    delivered_orders["order_delivered_customer_date"]
    - delivered_orders["order_purchase_timestamp"]
).dt.days

print("\n===== DELIVERY TIME =====")

print(
    delivered_orders["delivery_days"].describe()
)


# =====================================================
# 7. LATE DELIVERY ANALYSIS
# =====================================================

delivered_orders["late_delivery"] = (
    delivered_orders["order_delivered_customer_date"]
    > delivered_orders["order_estimated_delivery_date"]
)

print("\n===== LATE DELIVERY =====")

print(
    delivered_orders["late_delivery"].value_counts()
)


late_percentage = (
    delivered_orders["late_delivery"].mean() * 100
)

print(
    "Late Delivery Percentage:",
    round(late_percentage, 2),
    "%"
)


# =====================================================
# 8. REVENUE ANALYSIS
# =====================================================

order_items["total_value"] = (
    order_items["price"]
    + order_items["freight_value"]
)

total_revenue = order_items["total_value"].sum()

print("\n===== REVENUE =====")

print(
    "Total Revenue:",
    round(total_revenue, 2)
)


# =====================================================
# 9. AVERAGE ORDER VALUE
# =====================================================

aov = (
    order_items.groupby("order_id")["total_value"]
    .sum()
    .mean()
)

print(
    "Average Order Value:",
    round(aov, 2)
)


# =====================================================
# 10. TOP PRODUCTS BY REVENUE
# =====================================================

top_products = (
    order_items.groupby("product_id")["price"]
    .sum()
    .sort_values(ascending=False)
    .head(10)
)

print("\n===== TOP 10 PRODUCTS BY REVENUE =====")

print(top_products)


# =====================================================
# 11. TOP SELLERS BY REVENUE
# =====================================================

top_sellers = (
    order_items.groupby("seller_id")["price"]
    .sum()
    .sort_values(ascending=False)
    .head(10)
)

print("\n===== TOP 10 SELLERS =====")

print(top_sellers)


# =====================================================
# 12. REVIEW ANALYSIS
# =====================================================

average_rating = reviews["review_score"].mean()

print("\n===== REVIEW ANALYSIS =====")

print(
    "Average Rating:",
    round(average_rating, 2)
)

print("\nReview Distribution:")

print(
    reviews["review_score"].value_counts()
    .sort_index()
)


# =====================================================
# 13. PAYMENT ANALYSIS
# =====================================================

payment_summary = (
    payments.groupby("payment_type")["payment_value"]
    .sum()
    .sort_values(ascending=False)
)

print("\n===== PAYMENT ANALYSIS =====")

print(payment_summary)


# =====================================================
# 14. CUSTOMER STATE ANALYSIS
# =====================================================

state_customers = (
    customers.groupby("customer_state")
    .size()
    .sort_values(ascending=False)
)

print("\n===== CUSTOMERS BY STATE =====")

print(state_customers.head(10))


# =====================================================
# 15. MONTHLY REVENUE
# =====================================================

order_items_with_orders = order_items.merge(
    orders[["order_id", "order_purchase_timestamp"]],
    on="order_id",
    how="left"
)

order_items_with_orders["month"] = (
    order_items_with_orders["order_purchase_timestamp"]
    .dt.to_period("M")
)

monthly_revenue = (
    order_items_with_orders
    .groupby("month")["total_value"]
    .sum()
)

print("\n===== MONTHLY REVENUE =====")

print(monthly_revenue)


print("\n================================")
print("PYTHON ANALYSIS COMPLETED!")
print("================================")


connection.close()

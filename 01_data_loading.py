import pandas as pd


# =========================================================
# 1. CUSTOMERS DATASET
# =========================================================

customers = pd.read_csv("Dataset/olist_customers_dataset.csv")

print("\n========== CUSTOMERS ==========")
print(customers.head())
print("Shape:", customers.shape)

print("\nMissing Values:")
print(customers.isnull().sum())

print("\nData Types:")
print(customers.dtypes)

print("\nDuplicate Customer IDs:",
      customers["customer_id"].duplicated().sum())


# =========================================================
# 2. ORDERS DATASET
# =========================================================

orders = pd.read_csv("Dataset/olist_orders_dataset.csv")

print("\n========== ORDERS ==========")
print(orders.head())
print("Shape:", orders.shape)

print("\nMissing Values:")
print(orders.isnull().sum())

print("\nData Types Before Conversion:")
print(orders.dtypes)

print("\nDuplicate Order IDs:",
      orders["order_id"].duplicated().sum())


# Convert order date columns into datetime
date_columns = [
    "order_purchase_timestamp",
    "order_approved_at",
    "order_delivered_carrier_date",
    "order_delivered_customer_date",
    "order_estimated_delivery_date"
]

for col in date_columns:
    orders[col] = pd.to_datetime(orders[col], errors="coerce")

print("\nData Types After Conversion:")
print(orders[date_columns].dtypes)


# Calculate delivery time
orders["delivery_days"] = (
    orders["order_delivered_customer_date"]
    - orders["order_purchase_timestamp"]
).dt.days

print("\nDelivery Time:")
print(orders["delivery_days"].describe())


# Check late deliveries
orders["late_delivery"] = (
    orders["order_delivered_customer_date"]
    > orders["order_estimated_delivery_date"]
)

print("\nLate Deliveries:")
print(orders["late_delivery"].value_counts())


# Calculate late delivery percentage
late_percentage = orders["late_delivery"].mean() * 100

print(
    "\nLate Delivery Percentage:",
    round(late_percentage, 2),
    "%"
)


# =========================================================
# 3. PRODUCTS DATASET
# =========================================================

products = pd.read_csv("Dataset/olist_products_dataset.csv")

print("\n========== PRODUCTS ==========")
print(products.head())
print("Shape:", products.shape)

print("\nMissing Values:")
print(products.isnull().sum())

print("\nData Types:")
print(products.dtypes)

print("\nDuplicate Product IDs:",
      products["product_id"].duplicated().sum())


# =========================================================
# 4. SELLERS DATASET
# =========================================================

sellers = pd.read_csv("Dataset/olist_sellers_dataset.csv")

print("\n========== SELLERS ==========")
print(sellers.head())
print("Shape:", sellers.shape)

print("\nMissing Values:")
print(sellers.isnull().sum())

print("\nData Types:")
print(sellers.dtypes)

print("\nDuplicate Seller IDs:",
      sellers["seller_id"].duplicated().sum())


# =========================================================
# 5. ORDER ITEMS DATASET
# =========================================================

order_items = pd.read_csv("Dataset/olist_order_items_dataset.csv")

print("\n========== ORDER ITEMS ==========")
print(order_items.head())
print("Shape:", order_items.shape)

print("\nMissing Values:")
print(order_items.isnull().sum())

print("\nData Types:")
print(order_items.dtypes)

print(
    "\nDuplicate Order Item Records:",
    order_items.duplicated(
        subset=["order_id", "order_item_id"]
    ).sum()
)


# =========================================================
# 6. PAYMENTS DATASET
# =========================================================

payments = pd.read_csv("Dataset/olist_order_payments_dataset.csv")

print("\n========== PAYMENTS ==========")
print(payments.head())
print("Shape:", payments.shape)

print("\nMissing Values:")
print(payments.isnull().sum())

print("\nData Types:")
print(payments.dtypes)

print(
    "\nDuplicate Payment Records:",
    payments.duplicated(
        subset=["order_id", "payment_sequential"]
    ).sum()
)


# =========================================================
# 7. REVIEWS DATASET
# =========================================================

reviews = pd.read_csv("Dataset/olist_order_reviews_dataset.csv")

print("\n========== REVIEWS ==========")
print(reviews.head())
print("Shape:", reviews.shape)

print("\nMissing Values:")
print(reviews.isnull().sum())

print("\nData Types:")
print(reviews.dtypes)

# review_id alone is NOT used for duplicate checking
# because the source dataset can contain repeated review IDs.
print(
    "\nDuplicate Review Records:",
    reviews.duplicated(
        subset=["review_id", "order_id"]
    ).sum()
)


# Convert review dates
review_date_columns = [
    "review_creation_date",
    "review_answer_timestamp"
]

for col in review_date_columns:
    reviews[col] = pd.to_datetime(
        reviews[col],
        errors="coerce"
    )

print("\nReview Date Types:")
print(reviews[review_date_columns].dtypes)


# =========================================================
# 8. GEOLOCATION DATASET
# =========================================================

geolocation = pd.read_csv(
    "Dataset/olist_geolocation_dataset.csv"
)

print("\n========== GEOLOCATION ==========")
print(geolocation.head())
print("Shape:", geolocation.shape)

print("\nMissing Values:")
print(geolocation.isnull().sum())

print("\nData Types:")
print(geolocation.dtypes)


# =========================================================
# 9. CATEGORY TRANSLATION DATASET
# =========================================================

category_translation = pd.read_csv(
    "Dataset/product_category_name_translation.csv"
)

print("\n========== CATEGORY TRANSLATION ==========")
print(category_translation.head())
print("Shape:", category_translation.shape)

print("\nMissing Values:")
print(category_translation.isnull().sum())

print("\nData Types:")
print(category_translation.dtypes)

print(
    "\nDuplicate Category Names:",
    category_translation[
        "product_category_name"
    ].duplicated().sum()
)


# =========================================================
# FINAL SUMMARY
# =========================================================

print("\n\n========================================")
print("       DATA LOADING COMPLETED")
print("========================================")

print("\nDataset Shapes:")

print("Customers:", customers.shape)
print("Orders:", orders.shape)
print("Products:", products.shape)
print("Sellers:", sellers.shape)
print("Order Items:", order_items.shape)
print("Payments:", payments.shape)
print("Reviews:", reviews.shape)
print("Geolocation:", geolocation.shape)
print("Category Translation:", category_translation.shape)

print("\n========== SCRIPT COMPLETED ==========")
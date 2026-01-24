# DBT_Fundamentals

Exercise 1 
The Situation: The CFO screams that "Revenue is vanity, Profit is sanity." She wants to know which product categories are actually making money, and which are bleeding cash due to high product costs.

1. The Raw Data (Inputs)
Add these to your sources.yml.

Project: bigquery-public-data

Dataset: thelook_ecommerce

Tables:

order_items (Contains sale_price — what the user paid).

products (Contains cost — what it cost us to buy the item).

2. The Requirements (Your Instructions)
Staging: Create stg_order_items.sql and stg_products.sql.

The Join: You must join these tables on product_id.

The Calculation:

Revenue = Sum of sale_price.

Total Cost = Sum of cost.

Profit = Revenue - Total Cost.

Margin % = (Profit / Revenue) * 100.

The Constraint: You MUST use a Macro to calculate the Margin % to handle potential "Divide by Zero" errors (if Revenue is 0).

3. The Deliverable (The Final Model)
Create a model marts/finance/dim_category_profit.sql with these exact columns:

category (String)

total_revenue (Float)

total_profit (Float)

margin_percentage (Float)
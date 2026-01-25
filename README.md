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





### 📂 Project Case Study: Brand Revenue Intelligence

**1. The Business Scenario**

* **Stakeholder:** Marketing Director.
* **The Question:** "Which brands are driving our revenue? I need a leaderboard to negotiate better supplier contracts."
* **The Constraint:** Data must be accurate, validated, and derived from "Completed" orders only.

**2. The Data Stack (Input)**
We utilized the raw `thelook_ecommerce` dataset, specifically:

* **`stg_products`:** Raw inventory data (ID, Cost, Category, Brand).
* **`stg_order_items`:** Raw transactional data (Order ID, Status, Sale Price).

**3. The Architecture (Star Schema)**
We moved from a "Flat Table" approach to a professional **Dimensional Model**:

* **Dimension (`dim_`):** The Noun (Product details).
* **Fact (`fct_`):** The Verb (Sales events).
* **Mart/Report (`rpt_`):** The Answer (Aggregated metrics).

---

### 4. Technical Implementation & Logic

#### Step A: The Dimension (`dim_products`)

* **Goal:** Create a clean reference for "What we sell."
* **Logic:** Selected descriptive columns (`brand`, `category`).
* **Key Engineering:** Implemented a **Surrogate Key** (`product_key`) using a hash of the `product_id`. This ensures we can join safely even if IDs change upstream.

#### Step B: The Fact Table (`fct_order_items`)

* **Goal:** Capture the immutable truth of "What happened."
* **Logic:**
* Filtered `status = 'Complete'` (Business Rule).
* Generated the matching **Surrogate Key** (`product_key`).
* Kept the grain at **1 row per item** (no aggregation yet).



#### Step C: The Mart (`rpt_brand_sales`)

* **Goal:** Answer the business question.
* **Logic:**
* **Join:** `Left Join` Fact to Dim on `product_key`.
* **Metric:** `SUM(sale_price)` grouped by `brand`.
* **Sorting:** Applied `ORDER BY total_revenue DESC` at the very end to create a leaderboard.



---

### 5. Concepts Applied

| Concept | Application in this Project |
| --- | --- |
| **Surrogate Keys** | Used `dbt_utils.generate_surrogate_key(['product_id'])` to create robust, unique join keys instead of relying on raw integers. |
| **Packages** | Imported `dbt-labs/dbt_utils` to avoid writing complex hashing logic from scratch. |
| **Ambiguity Handling** | Fixed the SQL error where `product_key` existed in both tables by explicitly aliasing `products.product_key`. |
| **Order of Operations** | Learned to place `ORDER BY` in the final `SELECT` statement, not inside CTEs, to ensure the database respects the sort. |

### 6. The Result

* **Top Brand:** Diesel (~$53k Revenue).
* **Outcome:** Marketing can now focus ad spend on Diesel and Calvin Klein.
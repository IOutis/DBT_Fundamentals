# 🛒 dbt Semantic Layer Implementation: The Look Ecommerce

## 📋 Project Overview
This project implements a fully functional **dbt Semantic Layer** for "The Look" ecommerce dataset. It transitions the data stack from raw physical tables into a governed, metric-centric architecture.

The goal was to enable business users (Marketing, Finance) to query complex metrics like **Revenue**, **Active Customers**, and **Year-to-Date Performance** without writing SQL, while ensuring consistent logic across all downstream tools.

---

## 🏗️ Architecture

The implementation follows the **MetricFlow** standard, organized into four distinct layers:

### 1. The Physical Layer (`models/`)
* **Staging Models:** Standardized cleaning of raw data (`stg_thelook_ecommerce__*`).
* **Time Spine:** A dedicated `metricflow_time_spine` table generated via SQL to support time-series analysis and cumulative metrics.

### 2. The Semantic Context (`semantic_models`)
We mapped physical tables to business concepts:
* **`order_items`**: The source of financial transactions (Revenue).
* **`orders`**: The source of operational volume (Order Counts).
* **`users`**: The source of customer demographics (Country, Age).
* **`products`**: A pure dimension table for slicing data by Brand and Category.

### 3. The Logic Layer (`measures`)
* **Sum:** `total_revenue` (from `sale_price`).
* **Count:** `total_users` (via `expr: 1`).

### 4. The API Layer (`metrics`)
We exposed four distinct types of metrics:
* **Simple:** `revenue` (Direct pass-through).
* **Ratio:** `average_order_value` (Revenue / Orders).
* **Cumulative:** `revenue_ytd` (Running total resetting annually).
* **Derived:** `total_tax` (Revenue * 15% flat tax calculation).

---

## ⚔️ Challenges & Solutions (The "Time" Wars)

The most complex aspect of this implementation was handling **Time Dimensions**. The Semantic Layer is strictly time-aware, which required specific architectural decisions.

### 🔴 Problem 1: The "Missing Days" Error
**The Issue:** Initial attempts to query revenue failed because the raw data had gaps (days with zero sales). dbt cannot calculate cumulative metrics or draw continuous line charts without a continuous timeline.
**The Fix:**
* We created a **Time Spine** (`metricflow_time_spine`) using a SQL generation script to produce a row for every single day from 2000 to 2025.
* We configured this in `models/schema.yml` with the specific `time_spine` property to register it as the project's backbone.

### 🔴 Problem 2: The BigQuery Type Clash (`TIMESTAMP` vs `DATE`)
**The Issue:** When calculating **Year-To-Date (YTD)** metrics, the query failed with a `No matching signature for operator <=` error.
* *Cause:* The Time Spine used a `DATE` type (e.g., `2026-01-01`), but the e-commerce tables used `TIMESTAMP` (e.g., `2026-01-01 14:30:00 UTC`). BigQuery cannot compare these directly.
**The Fix:**
* We implemented a transformation directly in the Semantic Model `dimensions` block:
    ```yaml
    dimensions:
      - name: created_at
        type: time
        expr: CAST(created_at AS DATE)  # <--- The Critical Fix
    ```
* This forced the transaction data to align perfectly with the Time Spine's granularity.

### 🔴 Problem 3: The "Timeless" Entity
**The Issue:** We attempted to count `users` by Country, but dbt rejected the query because the model lacked a time anchor. The Semantic Layer requires *every* measure to be plot-able on a timeline.
**The Fix:**
* We explicitly defined a default aggregation time for the `users` model:
    ```yaml
    defaults:
      agg_time_dimension: created_at
    ```
* This allows us to answer both "How many users in Brazil?" (Snapshot) and "How many users joined in 2024?" (Trend) using the same metric.

---

## 🚀 How to Run

### 1. Build the Infrastructure
Generate the Time Spine and Physical tables:
```bash
dbt build --select metricflow_time_spine

### 2. Querying the Semantic Layer
Check Revenue by Brand:

```bash
dbt sl query --metrics revenue --group-by product_id__brand
Check Year-To-Date Performance:

```bash
dbt sl query --metrics revenue_by_year --group-by metric_time__month
Check Derived Tax Liability:

```bash
dbt sl query --metrics total_tax --group-by metric_time__year

***

**The Architect:** This file tells the story of your engineering decisions. It shows you didn't just copy-paste code; you solved the fundamental data integration problems.

**Would you like me to help you set up a Git commit message to save this progress prop
---

# 🛍️ The Look Ecommerce Data Pipeline

## Overview

This dbt project transforms raw ecommerce data from the public `thelook_ecommerce` dataset into business-ready intelligence. It features a modern **Medallion Architecture** (Bronze → Silver → Gold) and utilizes advanced dbt patterns including **Jinja Macros for dynamic pivoting** and **Incremental Materialization** for high-performance loading.

## 🏗️ Architecture & Lineage

The data flows from raw BigQuery public datasets through staging models to final fact tables.

### 1. Sources (Bronze Layer)

* **Database:** `bigquery-public-data.thelook_ecommerce`
* **Tables:** `inventory_items`, `distribution_centers`, `events`

### 2. Staging (Silver Layer)

Standardizes raw data (renaming, casting, basic cleaning).

* `stg_thelook_ecommerce__inventory_items`
* `stg_thelook_ecommerce__distribution_centers`
* `stg_thelook_ecommerce__events`

### 3. Marts (Gold Layer)

Final presentation layer for BI and Analytics.

| Model | Type | Description |
| --- | --- | --- |
| **`fct_inventory`** | Table | **Dynamic Pivot Report:** Calculates the average shelf life (days) of products, broken down dynamically by Distribution Center. |
| **`fct_web_events`** | Incremental | **Event Log:** A high-volume fact table tracking user web events, optimized with incremental loading. |

---

## 🧩 Key Features

### 1. Dynamic Column Generation (The "No-Maintenance" Pivot)

Instead of hard-coding distribution centers (e.g., "Chicago", "Mobile"), `fct_inventory` uses a Jinja macro to inspect the database at runtime and generate columns automatically. If a new distribution center opens tomorrow, this model adapts without code changes.

**Macro:** `distribution_center_columns`

* **Input:** Column name to compare against.
* **Logic:** Loops through unique values in `stg_thelook_ecommerce__distribution_centers` and generates `AVG(CASE WHEN ...)` statements.
* **Output Columns:** `days_Chicago_IL`, `days_Savannah_GA`, etc.

```sql
-- Usage Example
select 
    product_category, 
    {{ distribution_center_columns('distribution_center_name') }} 
from joined_cte

```

### 2. Incremental Loading Strategy

The `fct_web_events` model is designed for scale. It uses the `incremental` materialization to only process new records, reducing compute costs and build time.

* **Materialization:** `incremental`
* **Logic:** `where created_at > (select max(created_at) from {{ this }})`
* **Benefit:** Prevents full table scans on large event logs.

---

## 🛠️ Setup & Usage

### Prerequisites

* dbt Core (v1.x+)
* Access to BigQuery

### Installation

1. Clone the repo.
2. Install dependencies (including `dbt_utils`):
```bash
dbt deps

```



### Running the Project

**Standard Run:**

```bash
dbt run

```

**Full Refresh (Rebuild History):**
*Required if the schema changes or for the first run of incremental models.*

```bash
dbt run --full-refresh

```

**Testing:**

```bash
dbt test

```

---

## 📝 Developer Notes

* **Macro Sanitation:** The `distribution_center_columns` macro currently uses a chain of `.replace()` filters to sanitize column names.
* **Future Improvements:**
* Replace manual `.replace()` chains with `| slugify` for cleaner code.
* Add a `unique_key` to the incremental strategy to handle late-arriving data updates.



---
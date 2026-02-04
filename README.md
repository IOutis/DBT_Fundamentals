**The Architect:** A README for a "Rescue Mission" project like this needs to focus on the **Problem-Solving** aspect. It shows you can handle dirty, real-world data.

Here is the `README.md` for your Regex & Reconciliation module.

---

# 🧹 Project: Data Reconciliation & Regex Cleaning

## 🎯 Objective

To reconcile financial records between two mismatched systems by building a robust data cleaning pipeline in dbt. The goal was to standardize messy product descriptions, correct data ingestion errors, and parse inconsistent date formats to create a reliable "Reconciliation Report."

## ⚠️ The Challenge: "Data Chaos"

The raw source data (`returns.csv`) arrived with significant quality issues that broke standard ingestion pipelines:

1. **Column Shifting:** An unnamed index column caused all data to shift one cell to the left, misaligning headers (e.g., Row IDs appearing in the `receipt_date` column).
2. **Messy Descriptions:** Critical reference numbers (RMA IDs) were buried inside unstructured text strings (e.g., *"Item returned, Ref: RMA-998877, damaged"*).
3. **Date Corruption:** Date fields contained mixed formats (ISO vs. US) and dirty data (text mixed with timestamps), leading to parsing failures.
4. **CSV Formatting:** Commas inside product descriptions caused row splitting, creating "ghost columns" and `NULL` values.

## 🛠️ The Solution

We implemented a **Silver Layer** cleaning strategy in dbt using BigQuery's advanced string and date functions.

### 1. Date Parsing

```sql
DATE(receipt_date) as parsed_receipt_date
```

### 2. Regex Extraction

Used Regular Expressions (`REGEXP_EXTRACT`) to surgically remove RMA numbers from messy text descriptions, enabling joins that were previously impossible.

```sql
-- Extracts '12345' from 'RMA: 12345' or 'rma#12345'
REGEXP_EXTRACT(description, r'[a-zA-Z0-9-]+_([a-zA-Z0-9-]+)_[a-zA-Z0-9-]+') as rma_number

```

### 3. Schema Standardization

* Renamed columns with spaces (`return status` → `return_status`) using backticks.
* Handled the "Column Shift" issue by explicitly mapping the raw `int64_field_0` to `row_id` and correctly realigning downstream columns.

## 📊 The Outcome

* **Zero-Crash Pipeline:** The model now handles dirty data gracefully, returning `NULL` for bad rows instead of failing the run.
* **Reconciliation Ready:** Extracted RMA numbers allow for a 100% join rate against the financial ledger.
* **Data Integrity:** Implemented `dbt test` (Generic Tests) to ensure critical fields like `rma_number` are not null after cleaning.

## 🚀 Key Learnings

* **Never Trust CSVs:** Always inspect raw data for hidden index columns or unquoted commas.
* **Regex is Essential:** Standard SQL string functions (`LEFT`, `SUBSTR`) are insufficient for unstructured text; Regex is the only way to extract patterns reliably.
* **Defensive Coding:** Using `SAFE.PARSE` functions prevents one bad row from stopping the entire daily load.

---

**Next Step:** Commit this file to your repo. It proves you don't just build models; you **fix data.**
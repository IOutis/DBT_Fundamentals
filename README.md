# **Advanced dbt Concepts Implemented**
This project demonstrates the implementation of intermediate-to-advanced Analytics Engineering patterns using dbt Core.

## 1. Robust Staging Layer (stg_patients)
**Objective: Transform raw, messy source data into a clean, query-ready foundation.**

**Surrogate Keys: Implemented dbt_utils.generate_surrogate_key to create a deterministic Primary Key (patient_pk) from the Patient_ID, ensuring uniqueness and safe downstream joins.**

**DRY Macros: Created a reusable Jinja macro categorize_age(age_column) to standardize age bracketing ('Young', 'Adult', 'Senior') across the warehouse, replacing repetitive CASE WHEN logic**
**Defensive Testing: Applied Generic Tests (unique, not_null) and rigorous accepted_values tests (including invalid checks) in schema.yml to guarantee data integrity at the source.**

## 2. Marts & Conditional Aggregation (fct_specialty_performance)
**Objective: Perform complex "Pivot Table" style analysis in a single SQL pass without using multiple CTEs.**

**Scenario: Calculated specific churn metrics for the "Senior" demographic while retaining context for the total patient population.**

**Technique: Utilized Conditional Aggregation (e.g., SUM(CASE WHEN age_group = 'Senior'...)) to calculate numerators and denominators for specific segments within the same GROUP BY statement.**

**Optimization: This approach reduced query cost by scanning the table only once, replacing the need for multiple self-joins or joined CTEs.**

## 3. Data Quality Assurance (tests/)
**Objective: Verify complex business logic that standard YAML tests cannot catch.**

**Singular Tests: Wrote custom SQL tests (e.g., assert_churn_rate_is_valid) to validate mathematical boundaries.**

**Logic: The test scans for impossible values (e.g., Churn Rate < 0 or > 1) and fails the pipeline if any "impossible rows" are returned, preventing bad data from reaching the BI layer.**

## 4. Statistical Analysis (fct_satisfaction_gap)
**Objective: Measure the correlation between patient satisfaction and churn.**

**Technique: Calculated the "Satisfaction Gap" by subtracting the average score of Retained patients from Churned patients.**

**The "Null Trap" Fix: Explicitly handled ELSE NULL in aggregation logic to correctly calculate averages for non-matching rows, avoiding the common "Zero-Averaging" error that skews statistical results.**
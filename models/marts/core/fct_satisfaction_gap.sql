select 
    Specialty,
    
    avg(case when churned = 0 then overall_satisfaction else null end) 
    - 
    avg(case when churned = 1 then overall_satisfaction else null end) 
    as satisfaction_gap

from {{ ref('stg_dbt_m__patient_churn') }}
group by 1
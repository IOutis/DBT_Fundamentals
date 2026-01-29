select
    Specialty,
    avg(Wait_Time_Satisfaction) as avg_wait_satisfaction,
    sum(case when age_group = 'Senior' and churned = 1 then 1 else 0 end) 
    /     nullif(sum(case when age_group = 'Senior' then 1 else 0 end), 0) -- nullif prevents divide-by-zero
    as senior_churn_rate

from {{ ref('stg_dbt_m__patient_churn') }}
group by 1
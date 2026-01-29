with 

source as (

    select * from {{ source('dbt_m', 'patient_churn') }}

),

renamed as (

    select
        patientid,
        {{dbt_utils.generate_surrogate_key(['patientid'])}} as patient_key,
        age,
        {{age_group('age')}} as age_group,
        gender,
        state,
        tenure_months,
        specialty,
        insurance_type,
        visits_last_year,
        missed_appointments,
        days_since_last_visit,
        last_interaction_date,
        overall_satisfaction,
        wait_time_satisfaction,
        staff_satisfaction,
        provider_rating,
        avg_out_of_pocket_cost,
        billing_issues,
        portal_usage,
        referrals_made,
        distance_to_facility_miles,
        churned

    from source

)

select * from renamed
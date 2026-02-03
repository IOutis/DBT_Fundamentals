{{config(materialized = 'incremental')}}
select * 
from {{ref("stg_thelook_ecommerce__events")}}
{% if is_incremental()%}
 where created_at > (select max(created_at) from {{this}})
{% endif %}
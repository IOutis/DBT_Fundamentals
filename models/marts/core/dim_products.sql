with products as (
    select * from {{ ref('stg_products') }}
)

select
    {{dbt_utils.generate_surrogate_key(['product_id'])}}as product_key , 
    product_id,
    category,
    brand,
    name as product_name
from products
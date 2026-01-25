with order_items as (
    select * from {{ ref('stg_orders') }}
)

select
    {{dbt_utils.generate_surrogate_key(['product_id'])}}as product_key , 
    order_item_id, 
    product_id,
    order_id,
    sale_price
from order_items
where status = 'Complete'
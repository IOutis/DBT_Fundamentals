{{config(materialized = 'table')}}
with joined_cte as (
    select i.*, d.distribution_center_name from {{ref("stg_thelook_ecommerce__inventory_items")}} i join {{ref('stg_thelook_ecommerce__distribution_centers')}} d on i.product_distribution_center_id = d.product_distribution_center_id
),
grouped_cte as (
    select product_category , {{distribution_center_columns('distribution_center_name')}} from  joined_cte where sold_at is not null group by product_category
)
select * from grouped_cte
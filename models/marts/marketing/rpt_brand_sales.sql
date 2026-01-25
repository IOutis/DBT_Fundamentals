with aggregated as (
    Select products.product_id, products.product_name, fct.sale_price, products.brand from 
    {{ref("fct_order_items")}} fct left join {{ref('dim_products')}} products 
    on fct.product_key = products.product_key
),
metrics as (
    select brand, sum(sale_price) as total_revenue 
    from aggregated 
    group by brand
)
Select * from metrics order by total_revenue desc
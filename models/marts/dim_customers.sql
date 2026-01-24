with products as (
    select product_id, category, name , cost from {{ref("stg_products")}}
),
orders as (
    select order_item_id, product_id, sale_price from {{ref("stg_orders")}} where status = 'Complete'
), 
joined_metrics as (
select products.category, SUM(products.cost) as total_cost , SUM(orders.sale_price)as total_revenue from products join orders on products.product_id = orders.product_id group by products.category
),
final as (
    select category, total_revenue, (total_revenue-total_cost) as profit, {{ calculate_margin('total_revenue', 'total_cost') }} as margin_percentage from joined_metrics
)
select * from final

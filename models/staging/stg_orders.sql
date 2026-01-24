select id as order_item_id, order_id, user_id as customer_id, product_id, coalesce(sale_price,0) as sale_price, status from {{source("thelook_ecommerce", "order_items")}}

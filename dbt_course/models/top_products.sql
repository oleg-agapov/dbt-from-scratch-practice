select
    order_details.product_id,
    products.product_name,
    sum(order_details.line_total) as total_orders
from {{ source('dunder_mifflin', 'order_details') }}
left join {{ source('dunder_mifflin', 'products') }} on order_details.product_id = products.product_id
group by all

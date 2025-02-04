select
    orders.employee_id,
    employees.first_name,
    employees.last_name,
    sum(order_details.line_total) as total_orders
from {{ source('dunder_mifflin', 'order_details') }}
left join {{ source('dunder_mifflin', 'orders') }} on orders.order_id = order_details.order_id
left join {{ source('dunder_mifflin', 'employees') }} on orders.employee_id = employees.employee_id
group by all
order by total_orders desc

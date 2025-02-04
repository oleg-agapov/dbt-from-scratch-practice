with

-- Import CTEs

stg_dunder_mifflin__order_details as (
    select *
    from {{ ref('stg_dunder_mifflin__order_details') }}
),

stg_dunder_mifflin__orders as (
    select *
    from {{ ref('stg_dunder_mifflin__order_details') }}
),

stg_dunder_mifflin__products as (
    select *
    from {{ ref('stg_dunder_mifflin__products') }}
),

stg_dunder_mifflin__employees as (
    select *
    from {{ ref('stg_dunder_mifflin__employees') }}
),

-- Logic CTEs

final as (
    select
        order_details.product_id,
        products.product_name,
        orders.employee_id,
        employees.first_name,
        employees.last_name,
        order_details.line_total as total_orders
    from raw.dunder_mifflin.order_details
    left join raw.dunder_mifflin.orders on orders.order_id = order_details.order_id
    left join raw.dunder_mifflin.products on order_details.product_id = products.product_id
    left join raw.dunder_mifflin.employees on orders.employee_id = employees.employee_id
)

select * from final

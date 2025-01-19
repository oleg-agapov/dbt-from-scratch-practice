with

-- Import CTEs

stg_products as (
    select * from {{ ref('stg_dunder_mifflin__products') }}
),

stg_categories as (
    select
        category_id,
        category_name
    from {{ ref('stg_dunder_mifflin__categories') }}
),

stg_suppliers as (
    select
        supplier_id,
        company_name
    from {{ ref('stg_dunder_mifflin__suppliers') }}
),

-- Logic CTEs

orders_aggregated_by_products as (
    select
        product_id,
        times_ordered,
        gross_sales
    from {{ ref('int_orders_aggregated_by_products') }}
),

final as (
    select
        stg_products.product_id,
        stg_products.product_name,
        stg_categories.category_name,
        stg_suppliers.company_name as supplier_name,
        stg_products.units_in_stock,
        stg_products.units_on_order,
        stg_products.discontinued,
        orders_aggregated_by_products.times_ordered,
        orders_aggregated_by_products.gross_sales
    from stg_products
        left join orders_aggregated_by_products
            on
                stg_products.product_id
                = orders_aggregated_by_products.product_id
        left join stg_categories
            on stg_products.category_id = stg_categories.category_id
        left join stg_suppliers
            on stg_products.supplier_id = stg_suppliers.supplier_id
)

select * from final

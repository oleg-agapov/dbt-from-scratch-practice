with stg_order_details as (
    select * from {{ ref('stg_dunder_mifflin__order_details') }}
),

final as (
    select
        product_id,
        count(order_id) as times_ordered,
        sum(total_price) as gross_sales
    from stg_order_details
    group by all
)

select * from final

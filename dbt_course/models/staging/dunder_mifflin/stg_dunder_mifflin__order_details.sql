with source as (
    select * from {{ source('dunder_mifflin', 'order_details') }}
),

renamed as (
    select
        order_id,
        product_id,
        unit_price,
        quantity,
        discount,
        line_total as total_price
    from source
)

select * from renamed

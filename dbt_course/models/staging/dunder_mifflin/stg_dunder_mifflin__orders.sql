with source as (
    select * from {{ source('dunder_mifflin', 'orders') }}
),

renamed as (
    select
        order_id,
        customer_id,
        employee_id,
        order_date,
        required_date,
        shipped_date,
        ship_via as shipper_id,
        freight,
        ship_name,
        ship_address,
        ship_city,
        ship_region,
        ship_postal_code,
        ship_country
    from source
)

select * from renamed

{% if var("limit_query", -1) != -1 %}
limit {{ var("limit_query") }}
{% endif %}

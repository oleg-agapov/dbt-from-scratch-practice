with source as (
    select * from {{ source('dunder_mifflin', 'customers') }}
),

renamed as (
    select
        customer_id,
        customer_code,
        company_name,
        contact_name,
        contact_title,
        address,
        city,
        region,
        postal_code,
        country,
        phone,
        fax
    from source
)

select * from renamed

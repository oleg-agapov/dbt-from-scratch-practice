with source as (
    select * from {{ source('dunder_mifflin', 'suppliers') }}
),

renamed as (
    select
        supplier_id,
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

with source as (
    select * from {{ source('dunder_mifflin', 'categories') }}
),

renamed as (
    select
        category_id,
        category_name,
        description as category_description,
        picture
    from source
)

select * from renamed

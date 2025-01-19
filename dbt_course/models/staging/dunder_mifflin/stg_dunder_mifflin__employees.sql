with source as (
    select * from {{ source('dunder_mifflin', 'employees') }}
),

renamed as (
    select
        employee_id,
        {{ generate_full_name('first_name', 'last_name') }} as full_name,
        first_name,
        last_name,
        middle_name,
        title,
        title_of_courtesy,
        birth_date,
        hire_date,
        termination_date,
        rehire_date,
        address,
        city,
        region,
        postal_code,
        country,
        home_phone,
        extension,
        notes,
        reports_to,
        photo_path,
        employee_status_id
    from source
)

select * from renamed

with

-- Import CTEs

stg_employees as (
    select * from {{ ref('stg_dunder_mifflin__employees') }}
),

stg_orders as (
    select * from {{ ref('stg_dunder_mifflin__orders') }}
),

stg_customers as (
    select * from {{ ref('stg_dunder_mifflin__customers') }}
),

seed_employee_status as (
    select * from {{ ref('employee_status') }}
),

-- Logic CTEs

last_customers_per_employee as (
    select
        employee_id,
        customer_id
    from stg_orders
    qualify
        dense_rank() over (
            partition by employee_id
            order by order_date desc, order_id asc
        ) <= 5
),

final as (
    select
        last_customers_per_employee.employee_id,
        last_customers_per_employee.customer_id,
        stg_customers.company_name,
        seed_employee_status.status_name,
        stg_employees.first_name
        || ' '
        || stg_employees.last_name as employee_full_name
    from last_customers_per_employee
        left join stg_employees
            on
                last_customers_per_employee.employee_id
                = stg_employees.employee_id
        left join seed_employee_status
            on stg_employees.employee_status_id = seed_employee_status.status_id
        left join stg_customers
            on
                last_customers_per_employee.customer_id
                = stg_customers.customer_id
    where
        seed_employee_status.status_name in (
            'Suspended', 'Terminated', 'Retired'
        )
)

select * from final

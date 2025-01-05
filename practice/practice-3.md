# Practice 3: Improving the project

In this practice, we will improve the project by refactoring the models to modeling layers and implement project-wise configs using `dbt_project.yml`.

🎯 Goal: learn best practices of structuring dbt projects for scalability and modularity.

## Step 1: Implement staging layer

Staging layer id one-to-one reflection of source tables in the data warehouse.

Create a new directory `models/staging`. Inside of staging folder we usually create structure that reflects our datasource. In our case we could create a subfolder called `dunder_mifflin`, because all our data is coming from that source.

Inside of `dunder_mifflin` let's create several files:

<details>
    <summary>dunder_mifflin__sources.yml</summary>

    This is the same file as in the previous practice.

    You can just copy existing file from the previous practice.

</details>

<details>
    <summary>stg_dunder_mifflin__categories.sql</summary>

    ```sql
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
    ```

</details>

<details>
    <summary>stg_dunder_mifflin__customers.sql</summary>
    
    ```sql
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
    ```

</details>

<details>
    <summary>stg_dunder_mifflin__employees.sql</summary>
    
    ```sql
    with source as (

        select * from {{ source('dunder_mifflin', 'employees') }}

    ),

    renamed as (

        select
            employee_id,
            last_name,
            first_name,
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
    ```

</details>

<details>
    <summary>stg_dunder_mifflin__orders.sql</summary>
    
    ```sql
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
            ship_via,
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
    ```

</details>

<details>
    <summary>stg_dunder_mifflin__order_details.sql</summary>
    
    ```sql
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
            line_total

        from source

    )

    select * from renamed
    ```

</details>

<details>
    <summary>stg_dunder_mifflin__products.sql</summary>
    ```sql
    with source as (

        select * from {{ source('dunder_mifflin', 'products') }}

    ),

    renamed as (

        select
            product_id,
            product_name,
            product_description,
            supplier_id,
            category_id,
            quantity_per_unit,
            unit_price,
            units_in_stock,
            units_on_order,
            reorder_level,
            discontinued

        from source

    )

    select * from renamed
    ```
</details>

<details>
    <summary>stg_dunder_mifflin__shippers.sql</summary>
    ```sql
    with source as (

        select * from {{ source('dunder_mifflin', 'shippers') }}

    ),

    renamed as (

        select
            shipper_id,
            company_name,
            phone

        from source

    )

    select * from renamed
    ```
</details>

<details>
    <summary>stg_dunder_mifflin__suppliers.sql</summary>
    ```sql
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
    ```
</details>



## Step 2: Implement marts and intermediates

## Step 3: Change default configs of the project


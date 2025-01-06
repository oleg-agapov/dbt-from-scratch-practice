# Practice 3: Improving the project

In this practice, we will improve the project by refactoring the models to modeling layers and implement project-wise configs using `dbt_project.yml`.

🎯 Goal: learn best practices of structuring dbt projects for scalability and modularity.

## Step 1: Implement staging layer

Staging layer id one-to-one reflection of source tables in the data warehouse.

Create a new directory `models/staging`. Inside of staging folder we usually create structure that reflects our datasource. In our case we could create a subfolder called `/dunder_mifflin`, because all our data is coming from that source.

Inside of `models/staging/dunder_mifflin` let's create several files:


<details>
<summary><b>dunder_mifflin__sources.yml</b></summary>

> This is the same file as in the previous practice. You can just copy existing file from the previous practice.

</details>

<details>
<summary><b>stg_dunder_mifflin__categories.sql</b></summary>

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
<summary><b>stg_dunder_mifflin__customers.sql</b></summary>

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
<summary><b>stg_dunder_mifflin__employees.sql</b></summary>

```sql
with source as (
    select * from {{ source('dunder_mifflin', 'employees') }}
),

renamed as (
    select
        employee_id,
        first_name || ' ' || last_name as full_name,
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
```
</details>


<details>
<summary><b>stg_dunder_mifflin__orders.sql</b></summary>

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
```
</details>


<details>
<summary><b>stg_dunder_mifflin__order_details.sql</b></summary>

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
        line_total as total_price
    from source
)

select * from renamed
```
</details>


<details>
<summary><b>stg_dunder_mifflin__products.sql</b></summary>

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
<summary><b>stg_dunder_mifflin__shippers.sql</b></summary>

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
<summary><b>stg_dunder_mifflin__suppliers.sql</b></summary>

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

These models are building blocks for the whole project. We should only apply light transformations here, like renaming columns, casting data types, adding CASE WHEN columns, etc.

You can now try to run `dbt run` and see if all models are created successfully:

```bash
dbt run -s staging
```

> Note: Existing `sources.yml` can be deleted.

You should see something like this:
```bash
...
1 of 8 START sql view model dbt_oleg.stg_dunder_mifflin__categories ............ [RUN]
2 of 8 START sql view model dbt_oleg.stg_dunder_mifflin__customers ............. [RUN]
3 of 8 START sql view model dbt_oleg.stg_dunder_mifflin__employees ............. [RUN]
4 of 8 START sql view model dbt_oleg.stg_dunder_mifflin__order_details ......... [RUN]
5 of 8 START sql view model dbt_oleg.stg_dunder_mifflin__orders ................ [RUN]
6 of 8 START sql view model dbt_oleg.stg_dunder_mifflin__products .............. [RUN]
7 of 8 START sql view model dbt_oleg.stg_dunder_mifflin__shippers .............. [RUN]
8 of 8 START sql view model dbt_oleg.stg_dunder_mifflin__suppliers ............. [RUN]
1 of 8 OK created sql view model dbt_oleg.stg_dunder_mifflin__categories ....... [SUCCESS 1 in 0.60s]
8 of 8 OK created sql view model dbt_oleg.stg_dunder_mifflin__suppliers ........ [SUCCESS 1 in 0.98s]
3 of 8 OK created sql view model dbt_oleg.stg_dunder_mifflin__employees ........ [SUCCESS 1 in 1.00s]
7 of 8 OK created sql view model dbt_oleg.stg_dunder_mifflin__shippers ......... [SUCCESS 1 in 1.01s]
6 of 8 OK created sql view model dbt_oleg.stg_dunder_mifflin__products ......... [SUCCESS 1 in 1.05s]
4 of 8 OK created sql view model dbt_oleg.stg_dunder_mifflin__order_details .... [SUCCESS 1 in 1.05s]
2 of 8 OK created sql view model dbt_oleg.stg_dunder_mifflin__customers ........ [SUCCESS 1 in 1.08s]
5 of 8 OK created sql view model dbt_oleg.stg_dunder_mifflin__orders ........... [SUCCESS 1 in 1.09s]

Finished running 8 view models in 0 hours 0 minutes and 4.09 seconds (4.09s).

Completed successfully

Done. PASS=8 WARN=0 ERROR=0 SKIP=0 TOTAL=8
```

## Step 2: Implement marts and intermediates

Now it's time to create marts and intermediates. We will create a new directory `models/marts` and `models/intermediates`.

Marts and intermediates are split by business domain, for example `sales`, `product`, `core` etc.

For this task let's refactor `product_info` model from previous practice. This model is clearly belongs to marts layer because it's a model used to answer business questions.

Here is how we can do it:

1. Change references from `source()` to `ref()` macros (referencing staging models)
2. Rearrange CTEs for better readability
3. Extract common logic into intermediate models

Here is the refactored model:

<details>
<summary><b>models/marts/product/product_info.sql</b></summary>

```sql
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
        on orders_aggregated_by_products.product_id = stg_products.product_id
    left join stg_categories 
        on stg_categories.category_id = stg_products.category_id
    left join stg_suppliers 
        on stg_suppliers.supplier_id = stg_products.supplier_id
)

select * from final
```
</details>

<details>
<summary><b>models/intermediates/sales/int_orders_aggregated_by_products.sql</b></summary>

```sql
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
```
</details>

As you can see, we refactored original `orders` CTE to a separate intermediate model as it may be used in other models as well.

> ⚠️ Note: before running this new model, make sure to delete the old `product_info` and `retired_salesmen` models from the project, otherwise you'll get an error. Every model should be unique in the whole project.


To check that everything is working correctly, run `dbt run` with the following command:

```bash
dbt run -s +product_info
```

As you can see, we use `+` sign to run the model and all its upstream dependencies.

Now let's similarly refactor `retired_salesmen` model to marts layer.

<details>
<summary><b>models/marts/core/retired_salesmen.sql</b></summary>

```sql
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
        customer_id,    
    from stg_orders
    qualify dense_rank() over(partition by employee_id order by order_date desc, order_id) <= 5
),

final as (
    select
        last_customers_per_employee.employee_id,
        stg_employees.first_name || ' ' || stg_employees.last_name as employee_full_name,
        last_customers_per_employee.customer_id,
        stg_customers.company_name,
        seed_employee_status.status_name
    from last_customers_per_employee
    left join stg_employees 
        on stg_employees.employee_id = last_customers_per_employee.employee_id
    left join seed_employee_status 
        on seed_employee_status.status_id = stg_employees.employee_status_id
    left join stg_customers
        on stg_customers.customer_id = last_customers_per_employee.customer_id
    where seed_employee_status.status_name in ('Suspended', 'Terminated', 'Retired')
)

select * from final
```
</details>

Now you can try to build the model:

```bash
dbt run -s +retired_salesmen
```

## Step 3: Change default configs of the project

Currently all models in our project are materialized as views. This is not the best practice for all models. We can improve our project by changing the default materialization for some models.

Let's implement materialization rules on the modeling layers level. We can do it in `dbt_project.yml` file.

Change the following configuration in `dbt_project.yml`:

```yaml
models:
  dbt_course:
    staging:
      +materialized: view
    intermediates:
      +materialized: view
    marts:
      +materialized: table
```

This configuration will make all models in `staging` and `intermediates` layers materialized as views, and all models in `marts` layer materialized as tables.

You can check that by running `dbt run`:

```bash
dbt run
```

Commit your changes to the repository:

```bash
git add .
git commit -m "Refactor models to implement staging, marts and intermediates layers"
git push
```

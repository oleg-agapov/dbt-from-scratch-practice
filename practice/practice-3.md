# Practice 3: Improving the project

In this practice, we will improve the project by refactoring the models to modeling layers and implement project-wise configs using `dbt_project.yml`.

🎯 Goal: learn best practices of structuring dbt projects for scalability and modularity.

## Step 1: Implement staging layer

Staging layer is one-to-one reflection of source tables in the data warehouse.

Create a new directory `models/staging`. Inside of staging folder we usually create structure that reflects our datasource. In our case we could create a subfolder called `/dunder_mifflin`, because all our data is coming from that source.

Inside of `models/staging/dunder_mifflin` let's create several files:


<details>
<summary><b>dunder_mifflin__sources.yml</b></summary>

> This is the same file as in the previous practice. You can just move existing file from `/models` folder.

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

Let's refactor both `top_products` and `top_salesmen` models from previous practice.

First of all, both models should belong to `marts` layer. Second, we could merge both models into one because they use `order_details` table as a base, but use different joins and aggregations. To make it happen, we will re-grain the table to order details level, meaning we will remove aggregations from the model. Such types of aggregations can be done in BI tool, rather than in dbt.

Here is how we can do it:

1. Change references from `source()` to `ref()` macros (referencing staging models)
2. Rearrange CTEs for better readability

Here is the refactored model:

<details>
<summary><b>models/marts/finance/fct_order_details.sql</b></summary>

```sql
with

-- Import CTEs

stg_dunder_mifflin__order_details as (
    select *
    from raw.dunder_mifflin.order_details
),

stg_dunder_mifflin__orders as (
    select *
    from raw.dunder_mifflin.order_details
),

stg_dunder_mifflin__products as (
    select *
    from raw.dunder_mifflin.products
),

stg_dunder_mifflin__employees as (
    select *
    from raw.dunder_mifflin.employees
),

-- Logic CTEs

final as (
    select
        order_details.product_id,
        products.product_name,
        orders.employee_id,
        employees.first_name,
        employees.last_name,
        order_details.line_total as total_orders
    from raw.dunder_mifflin.order_details
    left join raw.dunder_mifflin.orders on orders.order_id = order_details.order_id
    left join raw.dunder_mifflin.products on order_details.product_id = products.product_id
    left join raw.dunder_mifflin.employees on orders.employee_id = employees.employee_id
)

select * from final
```
</details>

Now you can freely delete exising `top_products` and `top_salesmen` models.

To check that everything is working correctly, run `dbt run` with the following command:

```bash
dbt run -s +fct_order_details
```

As you can see, we use `+` sign to run the model and all its upstream dependencies.


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

> Note: We don't have intermediate models in this project, but we still can setup default materialization for them.

You can check that by running `dbt run`:

```bash
dbt run
```

You should see that marts are now materialized as tables, not views.

## Commit changes

Commit your changes to the repository:

```bash
git add .
git commit -m "Refactor models to implement staging, marts and intermediates layers"
git push
```

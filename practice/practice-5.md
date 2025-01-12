# Practice 5: Supercharging the project

In this task you will learn a few advanced techniques to make dbt project more dynamic and advanced.

🎯 Goal: learn about macros, dbt packages and variables

## Step 1: Create a macro 

In our staging model for employees we have a line where we concatenate first and last names to get a full name:

```sql
first_name || ' ' || last_name as full_name
```

This code may introduce a bug if any of the columns is NULL, so it's better to wrap both of them with `COALESCE`, like this:

```sql
coalesce(first_name, '') || ' ' || coalesce(last_name, '') as full_name
```

Now imagine that we need to implement the same code in multiple places. It could be clunky and error prone.

To improve this, we may introduce a macro that would accept a list of columns and return a properly formatted string.

In `/macros` folder Les't create a new file called `generate_full_name.sql` with the following content:

```sql
{% macro generate_full_name(first_name, last_name) -%}

coalesce({{ first_name }}, '') || ' ' || coalesce({{ last_name }}, '')

{%- endmacro %}
```

Now in our `stg_dunder_mifflin__employees.sql` we can call this macro like this:

```sql
{{ generate_full_name('first_name', 'last_name') }} as full_name
```

If you try to complile the model and check it's source code, you will see that macro was converted to a normal SQL code:

```bash
dbt compile -s stg_dunder_mifflin__employees
```

> Note: in our macro we used whitespace control technique so that our compiled code looks good without extra spaces and newlinew. Read about it here: https://docs.getdbt.com/faqs/Jinja/jinja-whitespace


## Step 2: Install dbt package

You can install dbt packages from dbt Hub, from Github repositories or local folders. Let's install a few packages from dbt Hub and implement them in our project.

First, create a file packages.yml in the root folder of dbt project (where `dbt_project.yml` is) with the following content:

```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.3.0
  - package: dbt-labs/codegen
    version: 0.13.1
```

This configuration contains two packages: [dbt_utils](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/) and [codegen](https://hub.getdbt.com/dbt-labs/codegen/latest/).

To install packages in your project run:

```bash
dbt deps
```

### Case 1: using dbt_utils for tests

`dbt_utils` package contains a lot of useful macros and tests that can enhance your dbt project. Let's use their tests to improve our models.

In our `stg_dunder_mifflin__orders` table we have three columns with dates: `order_date`, `required_date`, `shipped_date`. Let's find all cases where shipping was made after the required date in Pelsynvania state.

In schema file let's add new data test:

```yaml
models:
  - name: stg_dunder_mifflin__orders
    data_tests:
      - dbt_utils.expression_is_true:
          expression: "shipped_date > required_date"
          config:
            where: "ship_region = 'PA'"
            severity: warn
```

Pay attention, we added test **on the table level**, not on the column level as in previous tests.

Now you can run the test as usual:

```yaml
dbt test -s stg_dunder_mifflin__orders
```

You should see that we have a lot of instances where order was sipped after the required date. This is a good case to escalate with the warehouse team to speed up the process.

### Case 2: generating schemas using codegen

`codegen` package allows you to easily generate YAML and SQL files for your dbt project. It can:
- generate source YAML file for a given database schema
- generate base (staging) models for a given dbt source
- generate YAML schema for a given model from the project

Let's use it to generate missing schema files for our staging models.

On e way to generate schama YAML is to call generate_model_yaml macro directly from the terminal using run-command action. Here is how you can do it for categories model:

```bash
dbt run-operation generate_model_yaml --args '{"model_names": ["stg_dunder_mifflin__categories"]}'
```

The command will print raw YAML file to the terminal output:

```bash
$ dbt run-operation generate_model_yaml --args '{"model_names": ["stg_dunder_mifflin__categories"]}'

22:10:40  Running with dbt=1.9.1
22:10:41  Registered adapter: snowflake=1.9.0
22:10:41  Found 1 seed, 11 models, 6 data tests, 8 sources, 609 macros
version: 2

models:
  - name: stg_dunder_mifflin__categories
    description: ""
    columns:
      - name: category_id
        data_type: number
        description: ""

      - name: category_name
        data_type: varchar
        description: ""

      - name: category_description
        data_type: varchar
        description: ""

      - name: picture
        data_type: varchar
        description: ""
```

Now you can just copy this template into `stg_dunder_mifflin__categories.yml` file and fill in the missing descriptions if you want to.

Using this command you can now finish creating schemas for all staging models.

> Note: at the top you can see `version: 2` as a part of the output. You can ignore this line as it is a legacy parameter that is no longer needed for schema files.

## Step 3: Create a dynamic model using variables

dbt variables can make models more dynamic and flexible.

One example is using variables to limit the sample size. Add the following block at the end of `stg_dunder_mifflin__orders` model:

```sql
-- ...
select * from renamed

limit {{ var("limit_query", 500) }}

```

Using var() macro you can access the value of the variable `limit_query`. If the value wasn't provided, it will assign the default value to be 500.

Now try to run this model and check the compiled SQL:

```bash
dbt --debug run -s stg_dunder_mifflin__orders
```

You should see that now our query has `limit 500` statement attached at the end.

Next, you can provide the value of this variable in several ways. One way is to pass it as a parameter:

```
dbt --debug run -s stg_dunder_mifflin__orders --vars '{"limit_query": 1000}'
```

Another way is to set the value in `dbt_project.yml`:

```yaml
# Define variables anywhere in the file
vars:
  limit_query: 1000
```

You can also use variables together with other Jinja functions, like conditional blocks. For example, let's limit our model only if the variable was defined, otherwise skip it:

```sql
-- ...
select * from renamed

{% if var("limit_query", -1) != -1 %}
limit {{ var("limit_query") }}
{% endif %}
```

## Step 4: Commit changes

Commit your changes to the Github:

```bash
git add .
git commit -m "Add macro, packages and dbt variable"
git push
```

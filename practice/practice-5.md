# Practice 5: Supercharging the project

In this task you will learn a few advanced techniques to make dbt project more dynamic and advanced.

Goal: learn about dbt packages, dbt variables and snapshots

## Step 1: Create a macro 

In our employees model we have a line where we concatenate first and last names to get a full name:

```sql
first_name || ' ' || last_name as full_name
```

This code may introduce a bug if any of the columns is NULL, so it's better to wrap both of them with `COALESCE`, like this:

```sql
coalesce(first_name, '') || ' ' || coalesce(last_name, '') as full_name
```

Now imagine that we need to implement the same code in multiple models. It could be clunky and error prone.

To improve this, we could introduce a macro that would accept a list of columns and return a properly formatted string.

In `/macros` folder Les't create a new file called `generate_full_name.sql` with the following content:

```sql
{% macro generate_full_name(first_name, last_name) %}

coalesce({{ first_name }}, '') || ' ' || coalesce({{ last_name }}, '')

{% endmacro %}
```

Now in our model we can call this macro like this:

```sql
{{ generate_full_name('first_name', 'last_name') }} as full_name
```

If you try to complile the model and check it's source code, you will see that macro was converted to a normal SQL code:

```bash
dbt compile -s stg_dunder_mifflin__employees
```

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

This configuration is for insta


## Step 3: Create a dynamic model using variables


## Step 4: Implement dbt snapshot


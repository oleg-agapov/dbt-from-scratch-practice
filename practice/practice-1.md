# Practice 1: Setting up the environment

In this task we will prepare our development environment, install dbt with the appropriate adapter and connect to a database.

🎯 Goal: have properly setup environment to successfully complete the course.

## Step 1: Prepare the environment

First you need to create a repository for your on GitHub. You can name it `dbt-from-scratch` or any other name you like. Make it Public, add a README and `.gitignore` file for Python.

![Create repo](./img/1-1-create-repo.png)

You can clone the repository to your local machine using `git clone` command.

Alternatively, you can use GitHub Codespaces to create a new environment directly in the browser. Just click on the `Code` button and select `Create codespace on main`.

![Open Codespaces](./img/1-2-open-codespaces.png)

Next step is to prepare Python environment. If you work locally on your machine, you can create a virtual environment with:

```bash
python3 -m venv venv
```

And then activate the environment with:

```bash
source venv/bin/activate
```

> ⚠️ Note: don't forget to activate the virtual environment every time you start a new terminal session.

If you use GitHub Codespaces you can skip creating the virtual environment.

## Step 2: Install dbt

To install dbt you need to install two packages:
- dbt-core package
- adapter for your database

Create a new file called `requirements.txt` and add the following lines:

```txt
dbt-core==1.9.*
dbt-snowflake==1.9.*
dbt-duckdb==1.9.*
```

Now install the packages with:

```bash
pip install -r requirements.txt
```

To check that dbt is installed correctly, run the following command:

```bash
dbt --version
```

This should return the version of dbt you have installed.

## Step 3: Bootstrap the project

Before we can start working with dbt, we need to connect to a database. In this course we will use Snowflake as a database.

To connect to Snowflake you need to login with your temporary account:

1. Go to https://sd96455.us-central1.gcp.snowflakecomputing.com/
2. Login with the following credentials:
   - Username: (ask the instructor for the username)
   - Password: `p@ssw0rd`
   and change the password upon first login (please remember this password)
3. If you successfully logged in, you can proceed to the next step.

Now we can bootstrap the project with dbt. Run the following command:

```bash
dbt init
```

You gonna need to add the following information:
1. name of the project, e.g. `dbt_course` (only letters, digits, underscore are allowed)
2. the adapter you want to use, e.g. `snowflake`
3. specify the credentials to the database (see example for Snowflake below)

For Snowflake you need to provide the following information:

| Parameter             | Value                                                     |
| --------              | -------                                                   |
| account               | sd96455.us-central1.gcp                                   |
| user                  | <your_username>                                           |
| authentication type   | [1] password                                              |
| password              | <your_password> (it won't be visible in the terminal)     |
| role (dev role)       | student__b_role                                           |
| warehouse             | student_wh                                                |
| database              | dev                                                       |
| schema                | dbt_<your_username>                                       |
| threads               | 4                                                         |

Now you should have a new directory called `dbt_course` which contains started dbt project.

> ⚠️ Also there will be created `logs` directory, which you can safely delete.

Now you need to navigate to the project directory:

```bash
cd dbt_course
```

And finally, check that everything is working by running the following command:

```bash
dbt debug
```

## Troubleshooting database connection


#### Error `Profile should not be None if loading profile completed`

You probably forgot to change the working directory to the project directory. Make sure you are in the `dbt_course` directory when running `dbt debug`.

```bash
cd dbt_course
```

#### I made a mistake during the initialization

You can check correctness of your database credentials by inpecting `profiles.yml` file:

```bash
open ~/.dbt/profiles.yml
```

There should be `dbt_course` profile with all credentials.

## Step 4: Commit the changes

Commit the changes to the repository with the following commands:

```bash
git add .
git commit -m "Add dbt project files"
git push
```

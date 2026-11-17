# Early Warning System — Work in Progress

This repository is an in-progress analytics project for exploring bank customer payment behavior and developing an early-warning view of delinquency. It is not a production credit-risk or decisioning system.

## Current status

The repository currently contains:

- **Dataset retrieval:** `notebooks/01_IMPORT_DATA.ipynb` downloads the public Kaggle dataset `deepak915/bank-customer-payment-behavior` with `kagglehub`.
- **CSV loading:** `notebooks/02_CSV_TO_DB.ipynb` reads the monthly performance and origination CSV files from `data/raw/`, connects to PostgreSQL, creates the `raw` schema, and replaces the `raw.orig_data` and `raw.monthl_perf` tables.
- **Database connection setup:** `src/database.py` loads local environment settings and creates a SQLAlchemy PostgreSQL engine.
- **SQL execution helper:** `src/sql_runner.py` loads SQL files from the repository's `sql/` directory and returns query results as pandas DataFrames or executes statements in a transaction.
- **Data checks:** `sql/01_data_validation.sql` summarizes the raw monthly performance table, including record/customer/month counts, date range, duplicate customer-month pairs, missing fields, and DPD values.
- **Planned customer profile:** `sql/02_customer_profile.sql` is currently a placeholder; customer-level profiling has not yet been implemented.
- **Analytics notebook:** `notebooks/03_SQL_ANALYTICS.ipynb` demonstrates connecting to PostgreSQL and running the validation query.
- **Planned analysis:** `sql/03_delinquency_profile.sql` is currently a placeholder; delinquency profiling has not yet been implemented.

The project is **work in progress**. The SQL modules, data definitions, validation coverage, documentation, and any eventual modeling work may change. There is no implemented or validated predictive model at this time.

## Setup

1. Create and activate a Python virtual environment.
2. Install the packages used by the notebooks and source files. The repository does not yet include a pinned dependency file. Current imports include `pandas`, `numpy`, `SQLAlchemy`, `psycopg2`, `python-dotenv`, `kagglehub`, and a PostgreSQL driver.
3. Create a local `.env` file in the repository root with these settings:

   ```dotenv
   DB_USER=your_database_user
   DB_PASSWORD=your_database_password
   DB_HOST=localhost
   DB_PORT=5432
   DB_NAME=your_database_name
   ```

4. Ensure PostgreSQL is running and the configured account can create/use the `raw` schema and write the two imported tables.
5. Run the notebooks in order. The import notebook downloads the dataset; the CSV-to-database notebook expects the source CSVs under `data/raw/`; the analytics notebook runs SQL checks against the loaded database.

Do not commit `.env`, credentials, database exports, or private customer information. `.env` and `data/raw/` are excluded by `.gitignore`. Use synthetic or appropriately de-identified data when sharing examples.

## Security notes

The repository uses environment variables for database credentials rather than embedding passwords in source code. `src/sql_runner.py` also constrains SQL file paths to the project's `sql/` directory. SQL files passed to the runner are still executable database instructions: only run SQL you have reviewed and trust, and use a database account with only the permissions the task needs.

The CSV import notebook uses `if_exists="replace"`, which drops and recreates the target tables. Treat it as a destructive data-loading step and confirm the target database before running it. The app has not undergone a formal security audit; the notes here describe only the checks performed during this review.

## Repository layout

```text
.
├── data/raw/                 # Local source CSV files (ignored by Git)
├── notebooks/                # Dataset download, import, and SQL analysis notebooks
├── sql/                      # Validation and profiling queries
├── src/                      # Database configuration and SQL runner helpers
├── reports/                  # Reserved for generated reports
└── .env                      # Local database settings (ignored by Git)
```

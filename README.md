# Early Warning System - Work in Progress

This repository contains an in-progress analytics workflow for exploring bank customer payment behavior and delinquency. It is not a production credit-risk or decisioning system. No predictive model has been implemented or validated.

## Current implementation

- `notebooks/01_IMPORT_DATA.ipynb` downloads the public Kaggle dataset `deepak915/bank-customer-payment-behavior` using `kagglehub`.
- `notebooks/02_CSV_TO_DB.ipynb` reads monthly performance and origination CSVs from `data/raw/`, connects to PostgreSQL, creates the `raw` schema, and loads `raw.monthl_perf` and `raw.orig_data`.
- `src/database.py` loads database settings from the root `.env` file and creates a SQLAlchemy PostgreSQL engine.
- `src/sql_runner.py` reads SQL files from `sql/` and either returns a pandas DataFrame or executes statements in a transaction.
- `sql/01_data_validation.sql` reports table size, distinct customer and month counts, time bounds, and missing values for key fields.
- `sql/02_customer_profile.sql` creates one summary row per customer, including observation coverage, DPD, payment counts, credit score, and revolving utilization metrics.
- `sql/03_delinquency_profile.sql` groups monthly observations into DPD buckets and reports observation/customer counts and average DPD.
- `notebooks/03_SQL_ANALYTICS.ipynb` demonstrates connecting to PostgreSQL and running the validation query.

The project remains **work in progress**. Definitions, analysis coverage, data handling, and documentation may change. The SQL scripts have not been tested against every possible schema or dataset variation.

## Setup

1. Create and activate a Python virtual environment.
2. Install the dependencies used by the project. There is currently no pinned dependency file. The code imports `pandas`, `numpy`, `SQLAlchemy`, `psycopg2`, `python-dotenv`, and `kagglehub`.
3. Create a local `.env` file in the repository root:

   ```dotenv
   DB_USER=your_database_user
   DB_PASSWORD=your_database_password
   DB_HOST=localhost
   DB_PORT=5432
   DB_NAME=your_database_name
   ```

4. Ensure PostgreSQL is available and the configured database account has the permissions needed to create the `raw` schema and write the two tables.
5. Run the notebooks in order. The import notebook downloads the dataset; the CSV-to-database notebook expects the CSV files under `data/raw/`; the analytics notebook connects and runs the validation query.

Do not commit `.env`, credentials, database exports, or private customer information. `.env` and `data/raw/` are excluded by `.gitignore`. Use synthetic or properly de-identified data for shared examples.

## Security and operational notes

Database credentials are read from environment variables rather than embedded in source code. The SQL runner resolves requested paths and rejects paths outside the repository's `sql/` directory. SQL files remain executable database instructions; run only reviewed SQL and use a database account with the minimum permissions required.

The CSV import notebook calls `DataFrame.to_sql(..., if_exists="replace")` for both target tables. Running it replaces those tables, so verify the target database before importing. This repository has had a limited source review, not a formal security audit.

## Repository layout

```text
.
+-- data/raw/                 # Local source CSVs (ignored by Git)
+-- notebooks/                # Dataset download, import, and analysis notebooks
+-- sql/                      # Validation and profiling queries
+-- src/                      # Database configuration and SQL runner
+-- reports/                  # Generated reports (if any)
+-- .env                      # Local database settings (ignored by Git)
```

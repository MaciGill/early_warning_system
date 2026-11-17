from pathlib import Path

import pandas as pd
from sqlalchemy import text

PROJECT_ROOT = Path(__file__).resolve().parents[1]

SQL_PATH = PROJECT_ROOT / "sql"


def execute_sql_file(
    file_path: str,
    engine,
    return_dataframe: bool = True
):
    """
    Execute SQL stored in an external .sql file.

    Parameters
    ----------
    file_path : str
        Relative path to SQL file from sql directory.
    engine : SQLAlchemy engine
        PostgreSQL connection engine.
    return_dataframe : bool
        Return query result as pandas DataFrame.

    Returns
    -------
    pandas.DataFrame or None
    """

    full_path = (SQL_PATH / file_path).resolve()

    # Prevent path traversal from reading or executing files outside the SQL directory.
    if not full_path.is_relative_to(SQL_PATH.resolve()):
        raise ValueError("SQL file path must stay inside the project SQL directory.")

    if not full_path.is_file():
        raise FileNotFoundError(
            f"SQL file not found: {full_path}"
        )

    query = full_path.read_text(encoding="utf-8").strip()

    if not query:
        raise ValueError("SQL file is empty.")

    if return_dataframe:
        with engine.connect() as connection:
            return pd.read_sql_query(
                text(query),
                connection
            )

    with engine.begin() as connection:
        connection.execute(text(query))

    return None

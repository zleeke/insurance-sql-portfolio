from __future__ import annotations

import argparse
import random
import sqlite3
from datetime import date, timedelta
from pathlib import Path
from typing import Iterable

from faker import Faker

BASE_DIR = Path(__file__).resolve().parent
ROOT_DIR = BASE_DIR.parent
DB_PATH = ROOT_DIR / "insurance.db"
SCHEMA_PATH = ROOT_DIR / "schema" / "create_tables.sql"

Faker.seed(42)
random.seed(42)
fake = Faker()

REGIONS = [
    ("CA", "West"),
    ("NY", "Northeast"),
    ("TX", "South"),
    ("FL", "South"),
    ("IL", "Midwest"),
    ("PA", "Northeast"),
    ("OH", "Midwest"),
    ("GA", "South"),
    ("NC", "South"),
    ("MI", "Midwest"),
]

COVERAGE_TYPES = [
    ("Liability", "Covers damage to others."),
    ("Collision", "Covers damage to your vehicle from collisions."),
    ("Comprehensive", "Covers non-collision damage such as weather and theft."),
    ("Personal Injury Protection", "Covers medical expenses and related costs."),
    ("Uninsured Motorist", "Covers you when the other driver has no insurance."),
]

HOUSEHOLD_TYPES = ["Single", "Married", "Family", "Couple", "Roommates"]
POLICY_TYPES = ["Auto", "Home", "Life", "Renters", "Flood", "Umbrella"]
POLICY_STATUSES = ["Active", "Lapsed", "Cancelled", "Expired"]
CLAIM_TYPES = ["Accident", "Theft", "Fire", "Water Damage", "Liability", "Weather"]
SEVERITIES = ["Low", "Medium", "High", "Critical"]
PAYMENT_METHODS = ["Credit Card", "Bank Transfer", "Check", "ACH", "Cash"]

CUSTOMER_COUNT = 8000
POLICY_COUNT = 10000
CLAIM_COUNT = 9000


def connect_db(path: Path) -> sqlite3.Connection:
    conn = sqlite3.connect(path)
    conn.execute("PRAGMA foreign_keys = ON;")
    return conn


def create_tables(conn: sqlite3.Connection) -> None:
    if not SCHEMA_PATH.exists():
        raise FileNotFoundError(f"Schema SQL not found at {SCHEMA_PATH}")

    schema_sql = SCHEMA_PATH.read_text()
    conn.executescript(schema_sql)
    conn.commit()


def insert_reference_data(conn: sqlite3.Connection) -> None:
    conn.executemany(
        "INSERT OR IGNORE INTO regions (state, region) VALUES (?, ?);",
        REGIONS,
    )
    conn.executemany(
        "INSERT OR IGNORE INTO coverage_types (coverage_type, description) VALUES (?, ?);",
        COVERAGE_TYPES,
    )
    conn.commit()


def random_date(start: date, end: date) -> str:
    delta = (end - start).days
    return (start + timedelta(days=random.randint(0, delta))).isoformat()


def generate_customers() -> Iterable[tuple[int, int, str, str, int]]:
    states = [state for state, _ in REGIONS]
    for customer_id in range(1, CUSTOMER_COUNT + 1):
        yield (
            customer_id,
            fake.random_int(min=18, max=85),
            fake.random_element(states),
            fake.random_element(HOUSEHOLD_TYPES),
            fake.random_int(min=0, max=40),
        )


def generate_policies() -> Iterable[tuple[int, int, str, str, str, str, float, float, str]]:
    for policy_id in range(1, POLICY_COUNT + 1):
        customer_id = fake.random_int(min=1, max=CUSTOMER_COUNT)
        start_date = fake.date_between_dates(date_start=date(2020, 1, 1), date_end=date(2025, 12, 31)).isoformat()
        start_date_obj = date.fromisoformat(start_date)
        end_date_obj = start_date_obj + timedelta(days=fake.random_int(min=180, max=1460))
        yield (
            policy_id,
            customer_id,
            fake.random_element(POLICY_TYPES),
            fake.random_element([coverage for coverage, _ in COVERAGE_TYPES]),
            start_date,
            end_date_obj.isoformat(),
            round(random.uniform(100.0, 3500.0), 2),
            round(random.uniform(5000.0, 1000000.0), 2),
            fake.random_element(POLICY_STATUSES),
        )


def generate_claims() -> Iterable[tuple[int, int, str, float, str, str]]:
    for claim_id in range(1, CLAIM_COUNT + 1):
        policy_id = fake.random_int(min=1, max=POLICY_COUNT)
        claim_date = fake.date_between_dates(date_start=date(2020, 1, 1), date_end=date(2026, 6, 30)).isoformat()
        yield (
            claim_id,
            policy_id,
            claim_date,
            round(random.uniform(250.0, 50000.0), 2),
            fake.random_element(CLAIM_TYPES),
            fake.random_element(SEVERITIES),
        )


def generate_payments() -> Iterable[tuple[int, int, str, float, str]]:
    payment_id = 1
    for claim_id in range(1, CLAIM_COUNT + 1):
        payment_date = fake.date_between_dates(date_start=date(2020, 1, 1), date_end=date(2026, 12, 31)).isoformat()
        yield (
            payment_id,
            claim_id,
            payment_date,
            round(random.uniform(250.0, 50000.0), 2),
            fake.random_element(PAYMENT_METHODS),
        )
        payment_id += 1


def table_row_count(conn: sqlite3.Connection, table_name: str) -> int:
    cursor = conn.execute(f"SELECT COUNT(*) FROM {table_name};")
    return cursor.fetchone()[0]


def main() -> None:
    parser = argparse.ArgumentParser(description="Populate the insurance SQLite database with sample data.")
    parser.add_argument(
        "--force",
        action="store_true",
        help="Delete existing data and reload sample data.",
    )
    args = parser.parse_args()

    DB_PATH.parent.mkdir(parents=True, exist_ok=True)
    with connect_db(DB_PATH) as conn:
        create_tables(conn)

        if args.force:
            for table in ["payments", "claims", "policies", "customers", "coverage_types", "regions"]:
                conn.execute(f"DELETE FROM {table};")
            conn.commit()

        if table_row_count(conn, "customers") > 0:
            print("Database already contains data. Use --force to reload sample data.")
            return

        insert_reference_data(conn)

        conn.executemany(
            "INSERT INTO customers (customer_id, age, state, household_type, tenure_years) VALUES (?, ?, ?, ?, ?);",
            list(generate_customers()),
        )
        conn.executemany(
            "INSERT INTO policies (policy_id, customer_id, policy_type, coverage_type, start_date, end_date, premium, coverage_limit, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);",
            list(generate_policies()),
        )
        conn.executemany(
            "INSERT INTO claims (claim_id, policy_id, claim_date, claim_amount, claim_type, severity) VALUES (?, ?, ?, ?, ?, ?);",
            list(generate_claims()),
        )
        conn.executemany(
            "INSERT INTO payments (payment_id, claim_id, payment_date, payment_amount, payment_method) VALUES (?, ?, ?, ?, ?);",
            list(generate_payments()),
        )
        conn.commit()

        print(f"Loaded sample data into {DB_PATH.name}")
        print("Row counts:")
        for table in ["regions", "coverage_types", "customers", "policies", "claims", "payments"]:
            print(f"  {table}: {table_row_count(conn, table)}")


if __name__ == "__main__":
    main()

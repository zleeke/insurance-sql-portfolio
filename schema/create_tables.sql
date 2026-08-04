PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS regions (
    state TEXT PRIMARY KEY,
    region TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS coverage_types (
    coverage_type TEXT PRIMARY KEY,
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS customers (
    customer_id INTEGER PRIMARY KEY,
    age INTEGER NOT NULL,
    state TEXT NOT NULL,
    household_type TEXT NOT NULL,
    tenure_years INTEGER NOT NULL,
    FOREIGN KEY (state) REFERENCES regions(state)
);

CREATE TABLE IF NOT EXISTS policies (
    policy_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    policy_type TEXT NOT NULL,
    coverage_type TEXT NOT NULL,
    start_date TEXT NOT NULL,
    end_date TEXT NOT NULL,
    premium REAL NOT NULL,
    coverage_limit REAL NOT NULL,
    status TEXT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (coverage_type) REFERENCES coverage_types(coverage_type)
);

CREATE TABLE IF NOT EXISTS claims (
    claim_id INTEGER PRIMARY KEY,
    policy_id INTEGER NOT NULL,
    claim_date TEXT NOT NULL,
    claim_amount REAL NOT NULL,
    claim_type TEXT NOT NULL,
    severity TEXT NOT NULL,
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);

CREATE TABLE IF NOT EXISTS payments (
    payment_id INTEGER PRIMARY KEY,
    claim_id INTEGER NOT NULL,
    payment_date TEXT NOT NULL,
    payment_amount REAL NOT NULL,
    payment_method TEXT NOT NULL,
    FOREIGN KEY (claim_id) REFERENCES claims(claim_id)
);

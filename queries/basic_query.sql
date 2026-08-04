-- Basic query to return sample policy rows
SELECT
    policy_id,
    customer_id,
    policy_type,
    coverage_type,
    premium,
    status,
    start_date,
    end_date
FROM policies
LIMIT 20;

-- Which customer cohorts (age group, household_type, region) show highest frequency and severity
WITH customer_buckets AS (
  SELECT
    customer_id,
    CASE
      WHEN age < 25 THEN '<25'
      WHEN age BETWEEN 25 AND 34 THEN '25-34'
      WHEN age BETWEEN 35 AND 49 THEN '35-49'
      WHEN age BETWEEN 50 AND 64 THEN '50-64'
      ELSE '65+' END AS age_group,
    household_type,
    state
  FROM customers
),
cust_claims AS (
  SELECT cb.age_group,
         cb.household_type,
         r.region,
         COUNT(cl.claim_id) AS claim_count,
         ROUND(AVG(cl.claim_amount),2) AS avg_claim_amount,
         COUNT(DISTINCT cb.customer_id) AS customer_count
  FROM customer_buckets cb
  LEFT JOIN policies p ON p.customer_id = cb.customer_id
  LEFT JOIN claims cl ON cl.policy_id = p.policy_id
  LEFT JOIN regions r ON cb.state = r.state
  GROUP BY cb.age_group, cb.household_type, r.region
)
SELECT age_group, household_type, region, claim_count, avg_claim_amount,
       customer_count,
       ROUND(CASE WHEN customer_count=0 THEN NULL ELSE 1.0*claim_count/customer_count*100 END,2) AS claims_per_100_customers
FROM cust_claims
ORDER BY claims_per_100_customers DESC, avg_claim_amount DESC;

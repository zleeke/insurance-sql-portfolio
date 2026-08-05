-- Which states or regions have highest claim frequency and highest average severity
WITH state_stats AS (
  SELECT
    c.state,
    r.region,
    COUNT(DISTINCT p.policy_id) AS policy_count,
    COUNT(cl.claim_id) AS claim_count,
    ROUND(AVG(cl.claim_amount),2) AS avg_severity
  FROM policies p
  JOIN customers c ON p.customer_id = c.customer_id
  LEFT JOIN claims cl ON cl.policy_id = p.policy_id
  LEFT JOIN regions r ON c.state = r.state
  GROUP BY c.state
)
SELECT
  state,
  region,
  claim_count,
  policy_count,
  ROUND(CASE WHEN policy_count=0 THEN NULL ELSE 1.0*claim_count/policy_count*100 END,2) AS claims_per_100_policies,
  avg_severity
FROM state_stats
ORDER BY claims_per_100_policies DESC, avg_severity DESC;

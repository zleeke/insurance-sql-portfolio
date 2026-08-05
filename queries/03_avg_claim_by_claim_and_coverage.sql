-- Average claim_amount by claim_type and coverage_type
SELECT
  c.claim_type,
  p.coverage_type,
  ROUND(AVG(c.claim_amount),2) AS avg_claim_amount,
  COUNT(*) AS claim_count
FROM claims c
JOIN policies p ON c.policy_id = p.policy_id
GROUP BY c.claim_type, p.coverage_type
ORDER BY avg_claim_amount DESC;

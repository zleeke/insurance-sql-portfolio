-- What share of active policies have at least one claim in a year
-- Set the target year by editing the YEAR value below (e.g. '2024')
WITH target AS (
  SELECT '2024-01-01' AS year_start, '2024-12-31' AS year_end
),
active_policies AS (
  SELECT policy_id
  FROM policies, target
  WHERE date(start_date) <= date(target.year_end)
    AND date(end_date)   >= date(target.year_start)
    AND status = 'active'
),
active_policies_with_claim AS (
  SELECT DISTINCT p.policy_id
  FROM policies p
  JOIN claims c ON c.policy_id = p.policy_id
  JOIN target ON date(c.claim_date) BETWEEN target.year_start AND target.year_end
  WHERE date(p.start_date) <= date(target.year_end)
    AND date(p.end_date)   >= date(target.year_start)
    AND p.status = 'active'
)
SELECT
  (SELECT COUNT(*) FROM active_policies_with_claim) AS policies_with_at_least_one_claim,
  (SELECT COUNT(*) FROM active_policies) AS total_active_policies,
  ROUND(CASE WHEN (SELECT COUNT(*) FROM active_policies)=0 THEN NULL
       ELSE 1.0*(SELECT COUNT(*) FROM active_policies_with_claim)/(SELECT COUNT(*) FROM active_policies)
  END,4) AS share_of_active_policies_with_claims
;

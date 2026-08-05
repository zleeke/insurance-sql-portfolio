-- Average claim_amount by claim_type and coverage_type
SELECT
    p.coverage_type
    , c.claim_type
    , ROUND(AVG(c.claim_amount),2) AS avg_claim_amount
    , COUNT(*) AS claim_count
FROM 
    claims c
    INNER JOIN 
        policies p 
            ON c.policy_id = p.policy_id
GROUP BY 
    p.coverage_type
    , c.claim_type
ORDER BY 
    p.coverage_type
    , c.claim_type
    , avg_claim_amount DESC
;

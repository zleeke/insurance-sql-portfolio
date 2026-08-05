-- Loss ratio = sum(payments)/sum(premium) by policy_type and state
-- Uses payments as the paid amount; aggregates premiums at the policy level
SELECT
    p.policy_type
    , c.state AS state
    , ROUND(SUM(pm.payment_amount),2) AS total_paid
    , ROUND(SUM(p.premium),2) AS total_premium
    , ROUND(CASE 
        WHEN SUM(p.premium)=0 THEN NULL 
        ELSE SUM(pm.payment_amount)/SUM(p.premium) 
    END, 4) AS loss_ratio
FROM 
    policies p
    INNER JOIN 
        customers c 
            ON p.customer_id = c.customer_id
    LEFT OUTER JOIN 
        claims cl 
            ON cl.policy_id = p.policy_id
    LEFT OUTER JOIN 
        payments pm 
            ON pm.claim_id = cl.claim_id
GROUP BY 
    p.policy_type
    , c.state
ORDER BY 
    loss_ratio DESC
;

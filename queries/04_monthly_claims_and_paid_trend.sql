-- Monthly claim counts and paid amounts trend
-- Produces one row per YYYY-MM month with claim counts, total claim amounts, and total paid amounts
WITH 
claim_months AS (
    SELECT 
        strftime('%Y-%m', date(claim_date)) AS month
        , COUNT(*) AS claim_count
        , ROUND(SUM(claim_amount),2) AS claim_amount_total
    FROM 
        claims
    GROUP BY 
        month
)
, payment_months AS (
    SELECT 
        strftime('%Y-%m', date(payment_date)) AS month
        , ROUND(SUM(payment_amount),2) AS paid_amount
    FROM 
        payments
    GROUP BY 
        month
)
, months AS (
  SELECT month FROM claim_months
  UNION
  SELECT month FROM payment_months
)
SELECT 
    m.month
    , COALESCE(cm.claim_count, 0) AS claim_count
    , COALESCE(cm.claim_amount_total, 0) AS claim_amount_total
    , COALESCE(pm.paid_amount, 0) AS paid_amount
FROM 
    months m
    LEFT JOIN 
        claim_months cm 
            ON m.month = cm.month
    LEFT JOIN 
        payment_months pm 
            ON m.month = pm.month
ORDER BY 
    m.month
;

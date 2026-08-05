-- Distribution of time (days) from claim_date to payment_date
-- Summary statistics + median. Uses payments joined to claims.
WITH 
diffs AS (
    SELECT 
        p.payment_id
        , c.claim_id
        , (julianday(date(p.payment_date)) - julianday(date(c.claim_date))) AS days_diff
    FROM 
        payments p
    JOIN 
        claims c 
            ON p.claim_id = c.claim_id
    WHERE 
        p.payment_date IS NOT NULL
)
, summary AS (
    SELECT 
        COUNT(*) AS n
        , ROUND(AVG(days_diff),2) AS avg_days
        , MIN(days_diff) AS min_days
        , MAX(days_diff) AS max_days
    FROM diffs
)
SELECT 
    s.n
    , s.avg_days
    , (SELECT ROUND(AVG(days_diff), 2)
       FROM (
         SELECT days_diff
         FROM diffs
         ORDER BY days_diff
       LIMIT 2 - (SELECT COUNT(*) FROM diffs) % 2
       OFFSET (SELECT (COUNT(*) - 1) / 2 FROM diffs)
       )
    ) AS median_days
    , s.min_days
    , s.max_days
FROM 
    summary s
;

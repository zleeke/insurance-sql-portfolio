-- What share of active policies have at least one claim in a year
-- Set the target year by editing the year_start and year_end values below
WITH target AS (
    SELECT 
        '2024-01-01' AS year_start
        , '2024-12-31' AS year_end
)
-- CTE to return active policies and Y/N indicator for whether they have at least one claim in the target year
, active_policies AS (
    SELECT DISTINCT
        p.policy_id
        , CASE WHEN c.policy_id IS NOT NULL THEN 'Y' ELSE 'N' END AS claim_ind
    FROM 
        policies as p
        CROSS JOIN 
            target as t
        LEFT OUTER JOIN 
            claims c 
                ON c.policy_id = p.policy_id
    WHERE 
        date(p.start_date) <= date(t.year_end)
        AND date(p.end_date)   >= date(t.year_start)
        AND status = 'Active'
)
-- CTE to return the total number of active policies and the number of those with at least one claim in the target year, along with the share of active policies with claims
SELECT
    SUM(CASE WHEN claim_ind = 'Y' THEN 1 ELSE 0 END) AS policies_with_at_least_one_claim
    , COUNT(*) AS total_active_policies
    , CASE
        WHEN COUNT(*) = 0 THEN NULL
        ELSE printf(
        '%.2f%%',
        100.0 * SUM(CASE WHEN claim_ind = 'Y' THEN 1 ELSE 0 END) / COUNT(*)
        )
    END AS share_of_active_policies_with_claim
FROM 
    active_policies
;


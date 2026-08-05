-- Total written premium and average premium per policy_type
SELECT
    policy_type
    , ROUND(SUM(premium),2) AS total_written_premium
    , ROUND(AVG(premium),2) AS avg_premium
    , COUNT(*) AS policy_count
FROM 
    policies
GROUP BY 
    policy_type
ORDER BY 
    total_written_premium DESC
;

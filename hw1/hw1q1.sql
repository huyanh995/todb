-- Method: CTE
WITH summary_collision AS (
    SELECT
        HOUR(time) AS hour,
        MONTH(date) AS month,
        COUNT(*) as collision_count
    FROM cse532.COLLISION
    GROUP BY CUBE (HOUR(TIME), MONTH(DATE)) -- Should group by hour, month, and hour and month
    -- GROUP BY GROUPING SETS (HOUR(TIME), MONTH(DATE)) -- This one should be more suitable
)
SELECT
    hour,
    collision_count
FROM summary_collision
WHERE month IS NULL AND hour IS NOT NULL
ORDER BY collision_count DESC
LIMIT 1;




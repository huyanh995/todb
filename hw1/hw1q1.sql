-- Method 1: Using CTE
WITH summary_collision AS (
    SELECT
        HOUR(time) AS hour,
        MONTH(date) AS month,
        COUNT(*) as collision_count
    FROM cse532.collision
    GROUP BY CUBE (HOUR(TIME), MONTH(DATE))
)
SELECT
    *
FROM cse532.summary_collision
-- Additional condition to filter if needed
/*
WHERE
    (hour IS NULL AND month IS NOT NULL)
    OR (month IS NULL AND hour IS NOT NULL)
*/
;

-- Method 2: Using view for multiple queries on CUBE -> Including identify hour query
--              it is the same as writing the identical CTE twice, but easier to edit.
/*
CREATE VIEW summary_collision AS (
    SELECT
        HOUR(time) AS hour,
        MONTH(date) AS month,
        COUNT(*) as collision_count
    FROM cse532.collision
    GROUP BY CUBE (HOUR(TIME), MONTH(DATE))
);
-- Find hourly (24 hours) and monthly (12 months) counts of collision
SELECT
    *
FROM cse532.summary_collision
;

Extra query to find hour with peak of collision
SELECT
    hour,
    collision_count
FROM summary_collision
WHERE
    month IS NULL
    AND hour IS NOT NULL
ORDER BY collision_count DESC
LIMIT 1;

DROP VIEW summary_collision; -- Drop view to run multiple times
*/
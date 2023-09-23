-- Method 1: CTE
WITH summary_collision AS (
    SELECT
        HOUR(time) AS hour,
        MONTH(date) AS month,
        COUNT(*) as collision_count
    FROM cse532.collision
    GROUP BY CUBE (HOUR(TIME), MONTH(DATE))
)
SELECT
    hour,
    collision_count
FROM summary_collision
WHERE
    month IS NULL
    AND hour IS NOT NULL
ORDER BY collision_count DESC
LIMIT 1;

-- Method 2: "Temporary" table -> multiple queries
CREATE TABLE cse532.olap_cube AS (
    -- Temporary table should be better but I encountered an error regarding page size 4K authorization
    -- Materized view is another option but complicated to me now
    SELECT
        HOUR(time) AS hour,
        MONTH(date) AS month,
        COUNT(*) as collision_count
    FROM cse532.collision
    GROUP BY CUBE (HOUR(time), MONTH(date))
) WITH DATA;

-- Hourly collisions
SELECT
    hour,
    collision_count
FROM cse532.olap_cube
WHERE
    hour IS NOT NULL
    AND month IS NULL
;

-- Monthly collisions
SELECT
    month,
    collision_count
FROM cse532.olap_cube
WHERE
    hour IS NULL
    AND month IS NOT NULL
;

-- Find peak collisions over the years
SELECT
    hour,
    collision_count
FROM cse532.olap_cube
WHERE
    hour IS NOT NULL
    AND month IS NULL
ORDER BY collision_count DESC
LIMIT 1
;

DROP TABLE cse532.olap_cube;



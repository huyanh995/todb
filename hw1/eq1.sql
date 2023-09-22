CREATE TABLE cse532.olap_cube_all AS (
    -- Temporary table should be better but I encountered an error regarding page size 4K authorization
    -- Materized view is another option but complicated to me now
    SELECT
        HOUR(time) AS hour,
        MONTH(date) AS month,
        YEAR(date) as year,
        COUNT(*) as collision_count
    FROM cse532.collision_all
    GROUP BY CUBE (HOUR(time), MONTH(date), YEAR(date)) -- Should group by hour, month, and hour and month
    -- GROUP BY GROUPING SETS (HOUR(TIME), MONTH(DATE)) -- This one should be more suitable
) WITH DATA;

-- Hourly collisions
SELECT
    hour,
    collision_count
FROM cse532.olap_cube_all
WHERE
    hour IS NOT NULL
    AND month IS NULL
    AND year IS NULL
;

-- Monthly collisions
SELECT
    month,
    collision_count
FROM cse532.olap_cube_all
WHERE
    hour IS NULL
    AND month IS NOT NULL
    AND year IS NULL
;

-- Yearly collisions
SELECT
    year,
    collision_count
FROM cse532.olap_cube_all
WHERE
    hour IS NULL
    AND month IS NULL
    AND year IS NOT NULL
;

-- Find peak collisions over all years
SELECT
    hour,
    collision_count
FROM cse532.olap_cube_all
WHERE
    hour IS NOT NULL
    AND month IS NULL
    AND year IS NULL
ORDER BY collision_count DESC
LIMIT 1
;
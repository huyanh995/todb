-- Rerun q2
WITH sum_collision AS(
    SELECT
        zip_code,
        COUNT(*) as collision_count,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS collision_rank
    FROM cse532.collision_all
    WHERE
        zip_code IS NOT NULL
    GROUP BY zip_code
),
sum_zip AS(
    SELECT
        zip,
        SUM(population) as sum_pop,
        RANK() OVER (ORDER BY SUM(population) DESC) as population_rank
    FROM cse532.zipcensustable
    GROUP BY zip
)
SELECT
    sum_collision.zip_code
--     ,sum_collision.collision_count
--     ,sum_collision.collision_rank
--     ,sum_zip.sum_pop as population
--     ,sum_zip.population_rank
FROM
    sum_collision JOIN sum_zip
    ON sum_collision.zip_code = sum_zip.zip
WHERE
    sum_collision.collision_rank <= 10
    AND sum_zip.population_rank <= 10
;

-- Rerun q3
WITH coll_location AS (
    -- First get 10 longitude, latitude with first most collisions
    SELECT
        latitude,
        longitude,
        COUNT(*) AS coll_count
    FROM cse532.collision_all
    WHERE
        -- Exclude all records with NULL for latitude, longitude, zipcode
        zip_code IS NOT NULL AND
        latitude IS NOT NULL AND
        longitude IS NOT NULL
    GROUP BY latitude, longitude
    ORDER BY coll_count DESC
    LIMIT 10
),
result AS (
    -- Then, get all zipcodes correspond with 10 (latitude, longitude)
    -- Note: it should be the desired result but I put it in the CTE
    -- for aggregating zipcodes later
    SELECT DISTINCT
        coll_location.latitude,
        coll_location.longitude,
        coll_location.coll_count,
        coll.zip_code
    FROM cse532.collision_all AS coll
    JOIN coll_location
    ON coll.longitude = coll_location.longitude AND
       coll.latitude = coll_location.latitude
    WHERE coll.zip_code IS NOT NULL

)
SELECT
    *
FROM result
ORDER BY result.coll_count DESC -- Just for nicely display
;
/*
(Optional) comment above block and uncomment below block
to aggregate multiple zipcodes for one location
*/
-- SELECT
--     result.latitude,
--     result.longitude,
--     AVG(result.coll_count) as collision_count, -- Should be the same since duplicated entries
--     LISTAGG(result.zip_code, ',') WITHIN GROUP (ORDER BY result.zip_code) AS zipcodes
-- FROM
--     result
-- GROUP BY
--     result.latitude,
--     result.longitude
-- ORDER BY coll_count DESC
-- ;
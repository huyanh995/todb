WITH coll_location AS (
    -- First get 10 longitude, latitude with first most collisions
    SELECT
        latitude,
        longitude,
        COUNT(*) AS collision_count,
        RANK() OVER (ORDER BY COUNT(*) DESC) as coll_rank
    FROM cse532.collision
    WHERE
        -- Exclude all records with NULL for latitude, longitude, zipcode
        zip_code IS NOT NULL AND
        latitude IS NOT NULL AND
        longitude IS NOT NULL
    GROUP BY latitude, longitude
),
result AS (
    -- Then, get all zipcodes correspond with 10 (latitude, longitude)
    -- Note: it should be the desired result but I put it in the CTE
    -- for aggregating zipcodes later
    SELECT DISTINCT
        coll_location.latitude,
        coll_location.longitude,
        coll_location.collision_count,
        coll.zip_code
    FROM cse532.collision AS coll
    JOIN coll_location
    ON coll.longitude = coll_location.longitude AND
       coll.latitude = coll_location.latitude
    WHERE
        coll.zip_code IS NOT NULL
        AND coll_location.coll_rank <= 10
)
-- Zipcode of top 10 dangerous locations
SELECT
    *
FROM result
ORDER BY result.collision_count DESC -- Just for nicely display
;
/*
(Optional) comment above block and uncomment below block
to aggregate multiple zipcodes for one location
*/
-- SELECT
--     result.latitude,
--     result.longitude,
--     AVG(result.coll_count) as coll_count, -- Should be the same since duplicated entries
--     LISTAGG(result.zip_code, ',') WITHIN GROUP (ORDER BY result.zip_code) AS zipcodes
-- FROM
--     result
-- GROUP BY
--     result.latitude,
--     result.longitude
-- ORDER BY coll_count DESC
-- ;


WITH coll_location AS (
    -- First get 10 longitude, latitude with first most collisions
    SELECT
        latitude,
        longitude,
        COUNT(*) AS collision_count,
        RANK() OVER (ORDER BY COUNT(*) DESC) as coll_rank
    FROM cse532.collision_all
    WHERE
        -- Exclude all records with NULL for latitude, longitude, zipcode
        zip_code IS NOT NULL AND
        latitude IS NOT NULL AND
        longitude IS NOT NULL
    GROUP BY latitude, longitude
),
result AS (
    -- Then, get all zipcodes correspond with 10 (latitude, longitude)
    -- Note: it should be the desired result but I put it in the CTE
    -- for aggregating zipcodes later
    SELECT DISTINCT
        coll_location.latitude,
        coll_location.longitude,
        coll_location.collision_count,
        coll.zip_code
    FROM cse532.collision_all AS coll
    JOIN coll_location
    ON coll.longitude = coll_location.longitude AND
       coll.latitude = coll_location.latitude
    WHERE
        coll.zip_code IS NOT NULL
        AND coll_location.coll_rank <= 10
)
-- Zipcode of top 10 dangerous locations
-- SELECT
--     *
-- FROM result
-- ORDER BY result.collision_count DESC -- Just for nicely display
-- ;
/*
(Optional) comment above block and uncomment below block
to aggregate multiple zipcodes for one location
*/
SELECT
    result.latitude,
    result.longitude,
    AVG(result.collision_count) as coll_count, -- Should be the same since duplicated entries
    LISTAGG(result.zip_code, ',') WITHIN GROUP (ORDER BY result.zip_code) AS zipcodes
FROM
    result
GROUP BY
    result.latitude,
    result.longitude
ORDER BY coll_count DESC
-- ;
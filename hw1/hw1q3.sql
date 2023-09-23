WITH coll_location AS (
    -- First get 10 longitude, latitude with first most collisions
    SELECT
        latitude,
        longitude,
        COUNT(*) AS coll_count
    FROM cse532.collision
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
        coll.zip_code
    FROM cse532.collision AS coll
    JOIN coll_location
    ON coll.longitude = coll_location.longitude AND
       coll.latitude = coll_location.latitude
    WHERE coll.zip_code IS NOT NULL
)
SELECT
    *
FROM result
;
/*
(Optional) comment above block and uncomment below block
to aggregate multiple zipcodes for one location
*/

-- SELECT
--     LISTAGG(result.zip_code, ',') WITHIN GROUP (ORDER BY result.zip_code) AS zipcodes,
--     result.latitude,
--     result.longitude
-- FROM
--     result
-- GROUP BY
--     result.latitude,
--     result.longitude
-- ;


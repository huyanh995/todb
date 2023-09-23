-- Rerun q2
WITH sum_collision AS(
    SELECT
        zip_code,
        COUNT(*) as collision_count
    FROM cse532.collision_all
    WHERE zip_code IS NOT NULL
    GROUP BY zip_code
    ORDER BY collision_count DESC
    LIMIT 10
),
sum_zip AS(
    SELECT
        zip,
        SUM(population) as sum_pop
    FROM cse532.zipcensustable
    GROUP BY zip
    ORDER BY sum_pop DESC
    LIMIT 10
)
SELECT
    sum_collision.zip_code
FROM
    sum_collision JOIN sum_zip
    ON sum_collision.zip_code = sum_zip.zip
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
    SELECT DISTINCT
        coll.zip_code,
        coll_location.latitude,
        coll_location.longitude
    FROM cse532.collision_all AS coll
    JOIN coll_location
    ON coll.longitude = coll_location.longitude AND
       coll.latitude = coll_location.latitude
    WHERE coll.zip_code IS NOT NULL
)
-- (Just for displaying/ Optional)
-- Last, group them together in case one location has multiple zipcodes.
SELECT
    LISTAGG(result.zip_code, ',') WITHIN GROUP (ORDER BY result.zip_code) AS zipcodes,
    result.latitude,
    result.longitude
FROM
    result
GROUP BY
    result.latitude,
    result.longitude
;
WITH collision_over_location AS (
    -- First get 10 longitude, latitude with first most collisions
    SELECT
        latitude,
        longitude,
        COUNT(*) AS collision_count
    FROM cse532.collision
    WHERE
        -- Exclude all records with NULL for latitude, longitude, zipcode
        zip_code IS NOT NULL AND
        latitude IS NOT NULL AND
        longitude IS NOT NULL
    GROUP BY latitude, longitude
    ORDER BY collision_count DESC
    LIMIT 10
),
result AS (
    -- Then, get all zipcodes correspond with 10 (latitude, longitude)
    SELECT DISTINCT
        collision.zip_code,
        collision_over_location.latitude,
        collision_over_location.longitude
    FROM cse532.collision
    JOIN collision_over_location
    ON collision.longitude = collision_over_location.longitude AND
       collision.latitude = collision_over_location.latitude
    WHERE collision.zip_code IS NOT NULL
)
-- (Just for displaying/ Optional)
-- Last, group them together in case one location has multiple zipcodes.
SELECT
    LISTAGG(result.zip_code, ',') WITHIN GROUP (ORDER BY result.zip_code) AS zipcode_list,
    result.latitude,
    result.longitude
FROM
    result
GROUP BY
    result.latitude,
    result.longitude;

git filter-branch --index-filter "git rm --cached --ignore-unmatch /Users/huyanh/Documents/todb/hw1/data/Motor_Vehicle_Collisions_-_Crashes.csv" --prune-empty -f -- --all


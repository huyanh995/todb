-- WITH collision_over_location AS(
--     SELECT
--         latitude,
--         longitude,
--         COUNT(*) AS collision_count
--     FROM cse532.collision
--     WHERE
--         latitude IS NOT NULL AND
--         longitude IS NOT NULL
--     GROUP BY latitude, longitude
--     ORDER BY collision_count DESC
--     LIMIT 10
-- )
--
-- SELECT
--     DISTINCT collision.zip_code,
--     collision_over_location.latitude,
--     collision_over_location.longitude,
--     collision_over_location.collision_count
-- FROM cse532.collision
--
-- JOIN collision_over_location
-- ON collision.longitude = collision_over_location.longitude AND
--    collision.latitude = collision_over_location.latitude
--
-- WHERE collision.zip_code IS NOT NULL
-- ORDER BY collision_over_location.collision_count DESC;

SELECT
        latitude,
        longitude,
        COUNT(*) AS collision_count
    FROM cse532.collision
    WHERE
        latitude IS NOT NULL AND
        longitude IS NOT NULL
    GROUP BY latitude, longitude
    ORDER BY collision_count DESC
    LIMIT 10
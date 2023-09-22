WITH sum_collision AS(
    SELECT
        zip_code,
        COUNT(*) as collision_count
    FROM cse532.collision
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
    ON sum_collision.zip_code = sum_zip.zip;

-- Zip codes within top 10 populations and top 10 collision count
WITH sum_collision AS(
    SELECT
        zip_code,
        COUNT(*) as collision_count,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS collision_rank
    FROM cse532.collision
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

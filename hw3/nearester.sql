-- Simpler version: hard-coded radius to be 10 kilometers
WITH ONLYID AS (
    SELECT
        DISTINCT FACILITYID
    FROM cse532.FACILITYCERTIFICATION AS CERT
    WHERE
        CERT.ATTRIBUTEVALUE = 'Intensive Care'
),
LOCATIONS AS (
    SELECT
        GEOLOC.FACILITYID
        ,GEOLOC.FACILITYNAME
        ,GEOLOC.GEOLOCATION
    FROM ONLYID
    JOIN cse532.FACILITY AS GEOLOC ON ONLYID.FACILITYID = GEOLOC.FACILITYID
    WHERE
        db2gse.ST_IsEmpty(GEOLOC.GEOLOCATION) = 0
)
SELECT
    FACILITYID
    ,FACILITYNAME
    ,GEOLOCATION
    ,db2gse.ST_DISTANCE(GEOLOCATION, db2gse.ST_POINT(-73.016479, 40.891720, 1), 'KILOMETER') AS DISTANCE_KILOMETER
FROM LOCATIONS
WHERE
    db2gse.ST_WITHIN(GEOLOCATION, db2gse.ST_BUFFER(db2gse.ST_POINT(-73.016479, 40.891720, 1), 10, 'KILOMETER')) = 1
ORDER BY DISTANCE_KILOMETER
LIMIT 1;

-- =====================================================================================================================
-- -- Dynamic radius version: double the radius until found some points within.
-- WITH ONLYID AS (
--     SELECT
--         DISTINCT FACILITYID
--     FROM cse532.FACILITYCERTIFICATION AS CERT
--     WHERE
--         CERT.ATTRIBUTEVALUE = 'Intensive Care'
-- ),
-- LOCATIONS AS (
--     SELECT
--         GEOLOC.GEOLOCATION
--     FROM ONLYID
--     JOIN cse532.FACILITY AS GEOLOC ON ONLYID.FACILITYID = GEOLOC.FACILITYID
--     WHERE
--         db2gse.ST_IsEmpty(GEOLOC.GEOLOCATION) = 0
-- ),
-- RADIUS_SEARCH(RADIUS) AS (
--     -- Start from 5 km
--     SELECT 5.0 AS RADIUS FROM sysibm.sysdummy1
-- 
--     UNION ALL
--     -- Double the radius in each iteration
--     SELECT
--         RADIUS * 2
--     FROM RADIUS_SEARCH
--     WHERE NOT EXISTS (
--         SELECT 1
--         FROM LOCATIONS
--         WHERE
--             db2gse.ST_WITHIN(GEOLOCATION, db2gse.ST_BUFFER(db2gse.ST_POINT(-73.016479, 40.891720, 1), RADIUS, 'KILOMETER')) = 1
--     )
-- )
-- -- Select the minimum radius that contains at least one point and also select the point and its distance from the anchor
-- SELECT
--     LOCATIONS.GEOLOCATION,
--     db2gse.ST_DISTANCE(GEOLOCATION, db2gse.ST_POINT(-73.016479, 40.891720, 1), 'KILOMETER') AS DISTANCE_KILOMETER
-- FROM RADIUS_SEARCH
-- JOIN LOCATIONS ON db2gse.ST_WITHIN(GEOLOCATION, db2gse.ST_BUFFER(db2gse.ST_POINT(-73.016479, 40.891720, 1), RADIUS, 'KILOMETER')) = 1
-- ORDER BY DISTANCE_KILOMETER
-- LIMIT 1;
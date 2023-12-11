/*
Write a SQL script  facilityinsert.sql to insert data into cse532.facility by selecting data from cse532.facilityoriginal table and converting  (Latitude, Longitude) attributes into DB2GSE.ST_POINT type with srs_id  1 for geolocation attribute in cse532.facility.
*/

INSERT INTO cse532.FACILITY(
    facilityid
    ,facilityname
    ,description
    ,address1
    ,address2
    ,city
    ,state
    ,zipcode
    ,countycode
    ,county
    ,geolocation)
SELECT
    facilityid
    ,facilityname
    ,description
    ,address1
    ,address2
    ,city
    ,state
    ,zipcode
    ,countycode
    ,county
    ,db2gse.ST_POINT(longitude, latitude, 1) -- the GIS standard is (long, lat)
FROM cse532.FACILITYORIGINAL;

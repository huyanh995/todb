-- Create table
CREATE TABLE cse532.collision_all (
    date                            DATE,
    time                            TIME,
    zip_code                        SMALLINT, -- NY Zipcode in range [6390, 14975]
    latitude                        DECIMAL(15, 3), -- [-90, +90], instead of FLOAT for accuracy (float approx)
    longitude                       DECIMAL(15, 3), -- [-180, +180]
    contributing_factor_vehicle1    VARCHAR(200),
    contributing_factor_vehicle2    VARCHAR(200),
    unique_key                      INTEGER NOT NULL PRIMARY KEY, -- assign as primary key and not null
    vehicle_type_code_1             VARCHAR(200),
    vehicle_type_code_2             VARCHAR(200)
);

-- Load data into it
LOAD FROM "/home/huyanh/todb/hw1/data/Motor_Vehicle_Collisions_-_Crashes.csv"
OF DEL
METHOD P (
    1, 2, 4, 5, 6, 19, 20, 24, 25, 26
)
INSERT INTO cse532.collision_all (
    date,
    time,
    zip_code,
    latitude,
    longitude,
    contributing_factor_vehicle1,
    contributing_factor_vehicle2,
    unique_key,
    vehicle_type_code_1,
    vehicle_type_code_2
)

-- Add Indexing
CREATE INDEX
    idx_year_month
ON cse532.collision_all(MONTH(date), YEAR(date))
;

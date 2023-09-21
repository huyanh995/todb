CREATE TABLE cse532.collision (
    date                            DATE,
    time                            TIME,
    zip_code                        SMALLINT, -- NY Zipcode in range [6390, 14975]
    latitude                        DECIMAL(15, 10), -- [-90, +90], instead of FLOAT for accuracy (float approx)
    longitude                       DECIMAL(15, 10), -- [-180, +180]
    contributing_factor_vehicle1    VARCHAR(200),
    contributing_factor_vehicle2    VARCHAR(200),
    unique_key                      INTEGER NOT NULL PRIMARY KEY, -- assign as primary key and not null
    vehicle_type_code_1             VARCHAR(200),
    vehicle_type_code_2             VARCHAR(200)
);
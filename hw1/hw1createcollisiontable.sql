CREATE TABLE cse532.collision (
    date                            DATE,
    time                            TIME,
    zip_code                        SMALLINT, -- NY Zipcode in range [6390, 14975]
    latitude                        DECIMAL, -- [-90, +90], instead of FLOAT for accuracy (float approx)
    longitude                       DECIMAL, -- [-180, +180]
    contributing_factor_vehicle1    VARCHAR(100),
    contributing_factor_vehicle2    VARCHAR(100),
    unique_key                      INTEGER,
    vehicle_type_code_1             VARCHAR(100),
    vehicle_type_code_2             VARCHAR(100)
)
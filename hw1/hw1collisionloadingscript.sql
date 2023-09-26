LOAD FROM "./data/NYPD_Motor_Vehicle_Collisions2017.csv"
OF DEL
METHOD P (
    1, 2, 4, 5, 6, 19, 20, 24, 25, 26
)
-- MESSAGES "/home/dbhuyanh/msg/loadmsg.txt" -- DataGrip can display the error in console already
INSERT INTO cse532.collision (
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
);
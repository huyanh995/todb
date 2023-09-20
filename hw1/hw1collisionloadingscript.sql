LOAD FROM "/home/huyanh/todb/hw1/NYPD_Motor_Vehicle_Collisions2017.csv"
OF DEL
METHOD P (
    1, 2, 4, 5, 6, 19, 20, 24, 25, 26
)
MESSAGES "/home/huyanh/todb/hw1/msg/loadmsg.txt"
INSERT INTO cse532.collision (
--     TO_DATE(date, 'MM/DD/YYYY'),
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
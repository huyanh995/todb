CREATE TABLE cse532.zipcensustable (
    rank                    SMALLINT, -- only 1770 zipcodes, smallint is enough
    population_density      DECIMAL(15, 5), -- in range (0.2, 146955.3)
    zip                     INTEGER NOT NULL PRIMARY KEY,
    population              INTEGER
);

LOAD FROM "./data/zipcodepopulation.csv"
OF DEL
INSERT INTO cse532.zipcensustable (
    rank,
    population_density,
    zip,
    population
);
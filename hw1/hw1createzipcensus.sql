CREATE TABLE cse532.zipcensustable (
    rank                    SMALLINT, -- only 1770 zipcodes, smallint is enough
    population_density      DECIMAL(15, 10), -- in range (0.2, 146955.3)
    zip                     INTEGER NOT NULL PRIMARY KEY,
    population              INTEGER
);
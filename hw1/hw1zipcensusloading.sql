LOAD FROM "./data/zipcodepopulation.csv"
OF DEL
INSERT INTO cse532.zipcensustable (
    rank,
    population_density,
    zip,
    population
);
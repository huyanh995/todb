LOAD FROM "/home/huyanh/todb/hw1/data/zipcodepopulation.csv"
OF DEL
INSERT INTO cse532.zipcensustable (
    rank,
    population_density,
    zip,
    population
);
-- First approach: iterating through all records
CREATE OR REPLACE TYPE INTARR AS INTEGER ARRAY[100];

CREATE OR REPLACE PROCEDURE gen_salary_histogram(
    IN lower_b      FLOAT
    ,IN upper_b     FLOAT
    ,IN nbin        INT
)
    LANGUAGE SQL
BEGIN
    -- Declarations
    DECLARE SQLSTATE    CHAR(5) DEFAULT '00000'; -- This needs to be before cursors, handlers, conditions
    DECLARE bin_range   FLOAT;
    DECLARE salary_hist INTARR;
    DECLARE idx         INT DEFAULT 1;
    DECLARE r_salary    FLOAT;
    DECLARE bin_start   FLOAT;
    DECLARE bin_end     FLOAT;

    -- Cursor definition to fetch salaries within the specified range
    DECLARE cur CURSOR FOR
        SELECT salary
        FROM dbhuyanh.employee
        WHERE
            salary >= lower_b       -- initial value inclusive
            AND salary < upper_b;   -- end value exclusive

    -- Ensure a fresh result table by dropping and recreating it
    DROP TABLE salary_histogram IF EXISTS;
    COMMIT;
    CREATE TABLE salary_histogram(
          binnum        INT
          ,frequency    INT
          ,binstart     FLOAT
          ,binend       FLOAT
    );
    COMMIT;

    -- Initialize each histogram bin with a count of 0
    WHILE idx <= nbin DO
        SET salary_hist[idx] = 0;
        SET idx = idx + 1;
    END WHILE;

    -- Loop through all employee salaries and populate histogram data
    SET bin_range = (upper_b - lower_b) / nbin;
    OPEN cur;
    FETCH cur INTO r_salary;
    WHILE (SQLSTATE = '00000') DO
        -- Compute the bin for the fetched salary and update the histogram count
        SET idx = FLOOR((r_salary - lower_b) / bin_range) + 1; -- Db2 array is 1-indexed
        SET salary_hist[idx] = salary_hist[idx] + 1;
        FETCH cur INTO r_salary;
    END WHILE;
    CLOSE cur;

    -- Insert the computed histogram data into the result table
    SET idx = 1;
    WHILE idx <= nbin DO
        SET bin_start = lower_b + (idx - 1) * bin_range;
        SET bin_end = bin_start + bin_range;
        INSERT INTO
            dbhuyanh.salary_histogram(binnum, frequency, binstart, binend)
        VALUES
            (idx, salary_hist[idx], bin_start, bin_end);
        SET idx = idx + 1;
    END WHILE;
END;

-- ################################################
-- Second way: set-based approach, should be faster
CREATE OR REPLACE PROCEDURE gen_salary_histogram2(
    IN lower_b      FLOAT
    ,IN upper_b     FLOAT
    ,IN nbin        INT
)
    LANGUAGE SQL
BEGIN
    -- Declarations
    DECLARE SQLSTATE    CHAR(5) DEFAULT '00000'; -- This needs to be before cursors, handlers, conditions
    DECLARE bin_range   FLOAT;
    DECLARE bin_start   FLOAT;
    DECLARE bin_end     FLOAT;
    DECLARE cur_bin     INT;
    DECLARE cur_freq    INT;

    -- Cursor definition for generating histogram data using CTEs
    DECLARE cur CURSOR FOR
        WITH
        -- Generate a sequential list of bin numbers (1 to nbin)
        bin_numbers (bin) AS (
            SELECT 1 FROM SYSIBM.SYSDUMMY1
            UNION ALL
            SELECT bin + 1 FROM bin_numbers WHERE bin < nbin
        )
        -- Assign a bin number to each salary based on its range
        ,salary_bins AS (
            SELECT FLOOR((salary - lower_b)/ ((upper_b - lower_b) / nbin)) + 1 AS bin
            FROM dbhuyanh.employee
            WHERE
                salary >= lower_b       -- initial value inclusive
                AND salary < upper_b    -- end value exclusive
        )
        -- Aggregate salaries by their bin number to compute frequency for each bin
        ,salary_hist AS (
            SELECT
                bin
                ,count(*) AS freq
            FROM salary_bins
            GROUP BY bin
        )
        -- Final query to produce the histogram
        SELECT
            bin_numbers.bin as bin
            ,COALESCE(salary_hist.freq, 0) -- Use 0 for bins with no matching salaries
        FROM
            bin_numbers
            LEFT JOIN salary_hist ON bin_numbers.bin = salary_hist.bin
        ORDER BY bin;

    -- Refresh the result table by dropping and recreating
    DROP TABLE salary_histogram IF EXISTS;
    COMMIT;
    CREATE TABLE salary_histogram(
          binnum        INT
          ,frequency    INT
          ,binstart     FLOAT
          ,binend       FLOAT
    );
    COMMIT;

    -- Compute the range of each histogram bin
    SET bin_range = (upper_b - lower_b) / nbin;

    -- Populate the salary_histogram table with bin number, frequency, and bin range
    OPEN cur;
    FETCH cur INTO cur_bin, cur_freq;
    WHILE (SQLSTATE = '00000') DO
        -- Calculate the start and end values of the current bin
        SET bin_start = lower_b + (cur_bin - 1) * bin_range;
        SET bin_end = bin_start + bin_range;
        -- Insert the data for the current bin into the result table
        INSERT INTO
                dbhuyanh.salary_histogram(binnum, frequency, binstart, binend)
        VALUES
            (cur_bin, cur_freq, bin_start, bin_end);
        FETCH cur INTO cur_bin, cur_freq;
    END WHILE;
    CLOSE cur;
END;

-- CALL gen_salary_histogram(30000, 170000, 7);
-- CALL gen_salary_histogram2(30000, 170000, 7);
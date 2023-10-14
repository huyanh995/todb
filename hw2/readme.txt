Q1: I developed two procedures
* gen_salary_histogram iterates over individual salary records to update the histogram.
* gen_salary_histogram2 a set-based approach, leveraging GROUP BY for initial histogram calculations.
  Subsequent operations adjust bin ranges.
--------------------------------------------------------------
How to run:
CALL gen_salary_histogram(30000, 170000, 7);
CALL gen_salary_histogram2(30000, 170000, 7);

Then query the result table:
SELECT * FROM SALARY_HISTOGRAM
--------------------------------------------------------------
In my benchmarks, the second procedure showed a subtle edge in performance.
This modest advantage is unsurprising given the limited 42 entries in our EMPLOYEE table.
Nonetheless, as datasets grow, I anticipate the performance gap to become more pronounced.

Q2:
In my Java code, I've implemented a salary filter based on a specified range and fortified it against SQL injection.
While the performance boost was negligible, I've left it in the code, albeit commented, to maintain simplicity.
--------------------------------------------------------------
How to run:
Step 1: Copy db2jccv4.jar from <db2_repo>/sqllib/java to the directory of SalaryHistogram.java.
Alternatively, adjust the path to db2jccv4.jar.

Step 2: Compile the java file by running
javac -cp .:db2jcc4.jar SalaryHistogram.java

Step 3: Run the script
java -cp .:db2jcc4.jar SalaryHistogram <binnum> <binstart> <binend> <dbname> <username> <password>

Example
java -cp .:db2jcc4.jar SalaryHistogram 30000 170000 //192.168.1.3:25000/sample dbhuyanh 1
--------------------------------------------------------------
Result will look like this

Connected to the database!
**** Pulled the salary data
**** Transaction committed
**** Disconnected from data source

Histogram for salary in range [30000.0, 170000.0), 7 bins
+--------+-----------+------------+------------+
| binnum | frequency |  binstart  |   binend   |
+--------+-----------+------------+------------+
| 1      | 22        |   30000.00 |   50000.00 |
| 2      | 11        |   50000.00 |   70000.00 |
| 3      | 5         |   70000.00 |   90000.00 |
| 4      | 3         |   90000.00 |  110000.00 |
| 5      | 0         |  110000.00 |  130000.00 |
| 6      | 0         |  130000.00 |  150000.00 |
| 7      | 1         |  150000.00 |  170000.00 |
+--------+-----------+------------+------------+

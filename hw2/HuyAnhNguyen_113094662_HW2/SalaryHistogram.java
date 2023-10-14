import java.sql.*;

public class SalaryHistogram {

    public static void main(String[] args) {
        // JDBC URL format for Db2:
        // jdbc:db2://[hostname]:[port]/[databaseName]
        // Followed guideline from https://www.ibm.com/docs/en/db2-for-zos/12?topic=samples-example-simple-jdbc-application
        String urlPrefix = "jdbc:db2:";

        int numBin = Integer.parseInt(args[0]);
        float lowerBound = Float.parseFloat(args[1]);
        float upperBound = Float.parseFloat(args[2]);

        String jdbcUrl = urlPrefix + args[3];
        String user = args[4];
        String password = args[5];

        double empSalary;
        float binRange = (float) (upperBound - lowerBound) / numBin;
        int[] hist = new int[numBin];

        try {
            // Load the Db2 JDBC driver class
            Class.forName("com.ibm.db2.jcc.DB2Driver");

            // Connect to the database
            Connection conn = DriverManager.getConnection(jdbcUrl, user, password);
            System.out.println("Connected to the database!");

            // First way, pull all salary (ignoring the lowerBound and upperBound)

            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT salary FROM employee");
            while (rs.next()) {
                empSalary = rs.getDouble(1);
                if (lowerBound <= empSalary && empSalary < upperBound) {
                    int idx = (int) Math.floor((empSalary - lowerBound) / binRange);
                    hist[idx] ++;
                }
            }

            // Second way, using PreparedStatement with WHERE clause
            // Might have slightly better performance

            // String query = "SELECT salary FROM employee WHERE salary >= ? AND salary < ?";
            // PreparedStatement stmt = conn.prepareStatement(query);
            // stmt.setDouble(1, lowerBound);
            // stmt.setDouble(2, upperBound);

            // ResultSet rs = stmt.executeQuery();

            // while (rs.next()) {
            //     empSalary = rs.getDouble(1);
            //     int idx = (int) Math.floor((empSalary - lowerBound) / binRange);
            //     hist[idx]++;
            // }

            System.out.println ( "**** Pulled the salary data" );
            // Close the ResultSet
            rs.close();

            // Close the Statement
            stmt.close();

            // Connection must be on a unit-of-work boundary to allow close
            conn.commit();
            System.out.println ( "**** Transaction committed" );

            // Close the connection
            conn.close();
            System.out.println("**** Disconnected from data source");

            System.out.println("\nHistogram for salary in range [" + lowerBound + ", " + upperBound + "), " + numBin + " bins");

            System.out.println("+--------+-----------+------------+------------+");
            System.out.println("| binnum | frequency |  binstart  |   binend   |");
            System.out.println("+--------+-----------+------------+------------+");
            for (int i = 0; i < numBin; i++) {
                float binStart = lowerBound + i * binRange;
                float binEnd = binStart + binRange;
                System.out.printf("| %-6d | %-9d | %10.2f | %10.2f |%n", i+1, hist[i], binStart, binEnd);
            }
            System.out.println("+--------+-----------+------------+------------+");

        }
        catch (ClassNotFoundException e)
        {
        System.err.println("Could not load JDBC driver");
        System.out.println("Exception: " + e);
        e.printStackTrace();
        }

        catch(SQLException ex)
        {
            System.err.println("SQLException information");
            while(ex!=null) {
                System.err.println ("Error msg: " + ex.getMessage());
                System.err.println ("SQLSTATE: " + ex.getSQLState());
                System.err.println ("Error code: " + ex.getErrorCode());
                ex.printStackTrace();
                ex = ex.getNextException(); // For drivers that support chained exceptions
            }
        }
    }
}

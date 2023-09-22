# Create tables and load data from csv files
db2 -tf hw1createcollisiontable.sql
db2 -tf hw1collisionloadingscript.sql
db2 -tf hw1createzipcensus.sql
db2 -tf hw1zipcensusloading.sql
db2 -tf hw1q1.sql >> ./readme.txt
db2 -tf /home/huyanh/todb/hw1/ecreatecollisiontable.sql
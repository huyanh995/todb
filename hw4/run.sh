hdfs dfs -rm -r /cse532-f23/output/AgeYearCount
hadoop jar hw4.jar AgeYearCount /cse532-f23/data/tedsa_puf_2000_2019.csv /cse532-f23/output/AgeYearCount
hdfs dfs -cat '/cse532-f23/output/AgeYearCount/part-*' > ../results/AgeYearCount.txt

hdfs dfs -rm -r /cse532-f23/output/UniqueCBSA/
hadoop jar hw4.jar UniqueCBSA /cse532-f23/data/tedsa_puf_2000_2019.csv /cse532-f23/output/UniqueCBSA
hdfs dfs -cat '/cse532-f23/output/UniqueCBSA/part-*' > ../results/UniqueCBSA.txt

hdfs dfs -rm -r /user/huyanh/cse532-f23/output/AgeYearCount_Spark
spark-submit SparkAgeYearCount.py /user/huyanh/cse532-f23/sample.csv AgeYearCount_Spark.txt
hdfs dfs -ls /user/huyanh/cse532-f23/output/AgeYearCount_Spark.txt
hdfs dfs -cat /user/huyanh/cse532-f23/output/AgeYearCount_Spark.txt/part-*


hdfs dfs -rm -r /user/huyanh/cse532-f23/output/AgeYearCount_Spark.txt
hdfs dfs -rm -r /user/huyanh/cse532-f23/output/AgeYearCount/
hadoop jar hw4.jar AgeYearCount /user/huyanh/cse532-f23/tedsa_puf_2000_2019.csv /user/huyanh/cse532-f23/output/AgeYearCount_Full

spark-submit SparkAgeYearCount.py file:///home/huyanh/todb/hw4/data/tedsa_puf_2000_2019.csv AgeYearCount_Spark.txt

spark-submit SparkTopCountCBSA.py file:///home/huyanh/todb/hw4/data/tedsa_puf_2000_2019.csv SparkTopCountCBSA.txt

spark-submit SparkTopCountCBSA_v2.py file:///home/huyanh/todb/hw4/data/tedsa_puf_2000_2019.csv SparkTopCountCBSA.txt

spark-submit SparkTopCountCBSA.py /user/huyanh/cse532-f23/sample.csv SparkTopCountCBSA.txt



hdfs dfs -rm -r /cse532-f23/output/SparkAgeYearCount
spark-submit SparkAgeYearCount.py /cse532-f23/data/tedsa_puf_2000_2019.csv /cse532-f23/output/SparkAgeYearCount

hdfs dfs -rm -r /cse532-f23/output/SparkTopCountCBSA
spark-submit SparkTopCountCBSA.py /cse532-f23/data/tedsa_puf_2000_2019.csv /cse532-f23/output/SparkTopCountCBSA

hdfs dfs -get /cse532-f23/output/ /home/huyanh/todb/hw4/results

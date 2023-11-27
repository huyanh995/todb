import sys
from pyspark import SparkConf, SparkContext

sc = SparkContext(conf=SparkConf().setAppName("SparkAgeYearCount"))

in_file = sys.argv[1]
out_file = sys.argv[2]

data = sc.textFile(in_file)
header = data.first()
data = data.filter(lambda line: line != header)

def process_line(line):
    splits = line.split(',')
    if len(splits) > 20 and (splits[20] != '-9' or splits[0] != '-9'):
        return [((splits[20], splits[0]), 1)]
    return []

age_year_RDD = data.flatMap(process_line)
count_RDD = age_year_RDD.reduceByKey(lambda a, b: a + b)

# Will collect all result to driver node, so be careful about the size of result
output_RDD = count_RDD.flatMap(lambda x: [x[0][0] + '\t' + x[0][1] + '\t' + str(x[1])])
output_RDD.saveAsTextFile(out_file)

with open('/home/huyanh/todb/hw4/results/SparkAgeYearCount.txt', 'w') as f:
    f.write('Age\tYear\tCount\n')
    for line in output_RDD.collect():
        f.write(line + '\n')


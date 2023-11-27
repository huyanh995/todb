import os
import sys
from pyspark import SparkConf, SparkContext
from pyspark.accumulators import AccumulatorParam

sc = SparkContext(conf=SparkConf().setAppName("SparkTopCountCBSA"))

in_file = sys.argv[1]
out_file = sys.argv[2]

data = sc.textFile(in_file)
header = data.first()
data = data.filter(lambda line: line != header)

# Extract CBSA and year from each line
def extract_CBSA(line):
    splits = line.split(',')
    if len(splits) > 3 and splits[3] != '-9':
        return [((splits[0], splits[3]), 1)]
    return []

CBSA_RDD = data.flatMap(extract_CBSA) # <(year, CBSA), 1>

# Use accumulator to get the top5 CBSA without reduceByKey
class CounterAccumulatorParam(AccumulatorParam):
    """
    Implementation of python itertools.Counter as an accumulator for PySpark
    """
    def zero(self, v):
        # Initialize an empty dictionary
        return {}

    def addInPlace(self, v1, v2):
        # Define how to add two dictionaries
        for key in v2:
            if key in v1:
                v1[key] += v2[key]
            else:
                v1[key] = v2[key]
        return v1

counter_accum = sc.accumulator({}, CounterAccumulatorParam())
CBSA_RDD.foreach(lambda x: counter_accum.add({x[0][1]: x[1]}))
top5_CBSA = sorted(counter_accum.value.items(), key=lambda x: -x[1])[:5]
top5_CBSA = sc.broadcast([x[0] for x in top5_CBSA])

# Filter out the top5 CBSA for each year
def filter_top5_CBSA(line):
    if line[0][1] in top5_CBSA.value:
        return [line]
    return []

top5_CBSA_RDD = CBSA_RDD.flatMap(filter_top5_CBSA) # <(year, top5_CBSA), 1>
# top5_CBSA_RDD.coalesce(5) # Reduce the number of partitions to 5
top5_CBSA_RDD.persist() # Cache here for answering two questions without re-computing

# Get the all years count for each top5 CBSA
top5_CBSA_all_years = (top5_CBSA_RDD.map(lambda x: (x[0][1], x[1]))     # <top5_CBSA, 1>
                                    .reduceByKey(lambda a, b: a + b)    # <top5_CBSA, all_years_count>
                                    # .collect()
                        )

# Get the year with minimum count for each CBSA
# First step is to get the count of each CBSA for each year

top5_CBSA_min_year = (top5_CBSA_RDD.reduceByKey(lambda a, b: a + b)             # <(year, top5_CBSA), yearly_count>
                                    .map(lambda x: (x[0][1], (x[1], x[0][0])))  # <top5_CBSA, (yearly_count, year)>
                                    .reduceByKey(lambda a, b: min(a, b))        # <top5_CBSA, (min_yearly_count, year)>
                                    # .map(lambda x: (x[0], x[1][1]))             # <top5_CBSA, min_yearly_count>
                                    # .collect()
                        )

top5_CBSA_RDD.unpersist()

top5_CBSA_all_years.saveAsTextFile(os.path.join(out_file, 'top5_CBSA_all_years'))
top5_CBSA_min_year.saveAsTextFile(os.path.join(out_file, 'top5_CBSA_min_year'))

with open('/home/huyanh/todb/hw4/results/SparkTopCountCBSA.txt', 'w') as f:
    f.write('===== Top 5 CBSA w/ all years count =====\n')
    f.write('CBSA\tCount\n')
    for line in top5_CBSA_all_years.collect():
        f.write('\t'.join(list(map(str, line))) + '\n')

    # f.write('=' * 20 + '\n')
    f.write('===== Top 5 CBSA w/ min year count ======\n')
    f.write('CBSA\tMin_Year\n')
    for line in top5_CBSA_min_year.collect():
        # f.write('\t'.join(list(map(str, line))) + '\n')
        f.write('{}\t{}\t{}\n'.format(line[0], line[1][1], line[1][0]))

# >>> DEBUG >>> Time elapsed: 62.246618032455444
# >>> DEBUG >>> Time elapsed: 61.98408627510071 with coalesce(5)

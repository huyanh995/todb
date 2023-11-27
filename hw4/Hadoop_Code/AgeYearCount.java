import java.io.IOException;
import java.util.StringTokenizer;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

/*
 * AgeYearCount: Mapper <age_year, 1> -> Reducer
 */
public class AgeYearCount {
    public static class AgeYearMapper
        extends Mapper<LongWritable, Text, Text, IntWritable> {
        private final static IntWritable one = new IntWritable(1);
        private Text outKey = new Text();

        public void map(LongWritable key, Text line, Context context)
            throws IOException, InterruptedException{
            // Read csv line by line and use comma as delimeter
            // Not the most conventional approach (should use csv parser) but let's see
            String lineStr = line.toString();
            String[] lineValues = lineStr.split(",");

            // Handle the header case
            if (lineValues[0].equals("ADMYR")) {
                return;
            }
            else if (lineValues.length < 21) {
                System.out.println("Error: lines " + lineStr);
                return;
            }
            else if (lineValues[20].equals("-9") || lineValues[20].equals("-9")) {
                return;
            }

            // Year is column 0, and age is 20. Form a key as age_year
            String age_year = lineValues[20] + "\t" + lineValues[0];
            outKey.set(age_year);

            context.write(outKey, one);
        }
    }

    public static class IntSumReducer
        extends Reducer<Text, IntWritable, Text, IntWritable> {
        private IntWritable result = new IntWritable();

        public void reduce(Text key, Iterable<IntWritable> values, Context context)
            throws IOException, InterruptedException {
            int sum = 0;
            for (IntWritable val: values) {
                sum += val.get();
            }
            result.set(sum);
            context.write(key, result);
            }
        }

    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "AgeYearCount");
        job.setJarByClass(AgeYearCount.class);
        job.setMapperClass(AgeYearMapper.class);
        job.setCombinerClass(IntSumReducer.class);
        job.setReducerClass(IntSumReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}

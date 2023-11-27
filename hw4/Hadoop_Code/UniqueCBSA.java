import java.io.IOException;
import java.util.StringTokenizer;

import javax.naming.Context;

import org.apache.commons.lang3.ObjectUtils.Null;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class UniqueCBSA {
    public static class IdentityMapper
        extends Mapper<LongWritable, Text, Text, NullWritable> {
        private Text outKey = new Text();

        public void map(LongWritable key, Text line, Context context)
            throws IOException, InterruptedException{
            // Read csv line by line and use comma as delimeter
            // Not the most conventional approach (should use csv parser) but let's see
            String lineStr = line.toString();
            String[] lineValues = lineStr.split(",");

            // Handle the header case
            if (lineValues.length < 3 || lineValues[0].equals("ADMYR") || lineValues[3].equals("-9")) {
                return;
            }

            outKey.set(lineValues[3]);
            context.write(outKey, NullWritable.get());
        }
    }

    public static class UniqueCBSAReducer
        extends Reducer<Text, NullWritable, Text, NullWritable> {

        public void reduce(Text key, Iterable<NullWritable> values, Context context)
            throws IOException, InterruptedException {
            context.write(key, NullWritable.get());
            }
        }

    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "UniqueCBSA");
        job.setJarByClass(UniqueCBSA.class);
        job.setMapperClass(IdentityMapper.class);
        // job.setCombinerClass(UniqueCBSAReducer.class);
        job.setReducerClass(UniqueCBSAReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(NullWritable.class);
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}

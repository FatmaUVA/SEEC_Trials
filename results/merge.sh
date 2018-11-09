
file1=A1-video-QoE-results.txt
file2=A2-video-QoE-results.txt

file1=$1
file2=$2

filename="${file1:3}" #remove the first 3 characters (A1-) form file1 to use it as a general name
output_file=merged-$filename
cat $file1 > $output_file
cat $file2 >> $output_file

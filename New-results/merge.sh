
apps=["Web360-QoE-results.txt","Skype-QoE-results-w2.txt","ImageView-pics2"]
for app in "Web360-QoE-results.txt" "Skype-QoE-results-w2.txt"  "ImageView-pics2-QoE-result-w2" #"Skype" #"Insta360" "ImageView-pics1" "ImageView-pics2"
do
    echo $app
#    file1=A1-$app-QoE-results.txt
#    file2=A2-$app-QoE-results.txt
    file1=merged-$app-QoE-results.txt
    file2=merged-$app-QoE-results-uva-1.txt   
    #file1=$1
    #file2=$2

    filename="${file1:3}" #remove the first 3 characters (A1-) form file1 to use it as a general name
    #output_file=merged-$filename
    output_file=merged-$app-QoE-results-pilot-and-trial.txt 
    cat $file1 >> $output_file
    cat $file2 >> $output_file
done


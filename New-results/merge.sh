
apps=["Web360-QoE-results.txt","Skype-QoE-results-w2.txt","ImageView-pics2"]
for app in "Skype" "Web360" "video" "ImageView-pics2"
do
    echo $app
    file1=A1-$app-QoE-results-uva-1.txt
    file2=A2-$app-QoE-results-uva-1.txt
    file3=A1-$app-QoE-results-w1.txt
    file4=A2-$app-QoE-results-w1.txt
    file5=A1-$app-QoE-results-w2.txt
    file6=A2-$app-QoE-results-w2.txt

    output_file=merged-$app-QoE-results-all-weeks.txt
    cat $file1 > $output_file
    cat $file2 >> $output_file
    cat $file3 >> $output_file
    cat $file4 >> $output_file
    cat $file5 >> $output_file
    cat $file6 >> $output_file
done


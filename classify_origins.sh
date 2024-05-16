#!/bin/sh

# Edit version - type of classification here
model_version=chrome5 #latest as of May 14, 2024
classification_type=topics-api #replicates Chrome Classification

ha_dir=ha_urls #folder with all the csv files with HA origins

for csv_file in ${ha_dir}/*.csv
do
    domains_file="${csv_file%.*}"_domains.txt
    classified_file="${csv_file%.*}"_classification_${model_version}_${classification_type}.tsv

    if [ ! -f $classified_file ]
    then
        #some preprocessing to make sure there is no http(s):// or duplicates 
        #if already enforced, feel free to remove and pass directly input_path to
        #parallel command, remove url header line too
        sed -r "s/^https?:\/\/(.*)\/?$/\1/p" $csv_file > $domains_file
        sed -i -r "s/(.*)\/$/\1/p" $domains_file
        sed -i '1d' $domains_file
        sort -u $domains_file -o $domains_file
        #Classification
        #Header
        echo "domain\ttopic_id" > $classified_file
        #Parallel inference
        parallel -X --bar -N 1000 -a $domains_file -I @@ "python3 topics_classifier/classify.py -mv $model_version -ct $classification_type -i @@ >> $classified_file"
        echo "Classification Done: $csv_file"
    fi
done


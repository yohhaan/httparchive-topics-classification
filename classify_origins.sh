#!/bin/sh

# Edit version - type of classification here
model_version=chrome5 #latest as of May 14, 2024
classification_type=topics-api #replicates Chrome Classification

# Variables
input_path=origins.txt
domains_path=domains.txt
classified_path=classification_${model_version}_${classification_type}.tsv

#check if domains exist and 
if [ ! -f $classified_path ]
then

    #some preprocessing to make sure there is no http(s):// or duplicates 
    #if already enforced, feel free to remove and pass directly input_path to
    #parallel command
    sed -r "s/^https?:\/\///" $input_path > $domains_path
    sort -u $domains_path -o $domains_path

    #Classification
    #Header
    echo "domain\ttopic_id" > $classified_path
    #Parallel inference
    parallel -X --bar -N 1000 -a $domains_path -I @@ "python3 topics_classifier/classify.py -mv $model_version -ct $classification_type -i @@ >> $classified_path"
    
    #rm domains input
    rm $domains_path

fi

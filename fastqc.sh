#!/bin/bash
#Executing the fastqc with iteration, then  putting the results into a new directory for storage
mkdir ./results
for fastqfile in /localdisk/data/BPSM/Assignment1/fastq/*.fq.gz
do
  fastqc -o ./results $fastqfile
done

#unzip each result file with .zip

for zipfile in ./results/*.zip
do
unzip -o $zipfile -d ./results
done

#assess the numbers and quality of sequence data based on fastqc output, putting the information into a file for summary

cat ./results/*fastqc/fastqc_data.txt | grep -E "Filename|Total Sequences" > ./results/fastqc_summaries.txt 

cat ./results/*fastqc/summary.txt >> ./results/fastqc_summaries.txt


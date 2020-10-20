#!/bin/bash
#Executing the fastqc with iteration, then  putting the results into a new directory for storage

for fastqfile in /localdisk/data/BPSM/Assignment1/fastq/*.fq.gz
do
  fastqc -o ~/Assignment1/fqc_results $fastqfile
done

#unzip each result file with .zip

for zipfile in ~/Assignment1/fqc_results/*.zip
do
unzip -o $zipfile -d ~/Assignment1/fqc_results
done

#assess the numbers and quality of sequence data based on fastqc output, putting the information into a file for summary

cat ~/Assignment1/fqc_results/*fastqc/fastqc_data.txt | grep -E "Filename|Total Sequences" > ~/Assignment1/fqc_results/fastqc_summaries.txt 

cat ~/Assignment1/fqc_results/*fastqc/summary.txt >> ~/Assignment1/fqc_results/fastqc_summaries.txt


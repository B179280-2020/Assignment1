#!/bin/bash
for fastqfile in /localdisk/data/BPSM/Assignment1/fastq/*.fq.gz
do
  fastqc -o ~/Assignment1/fqc_results $fastqfile
done
for zipfile in ~/Assignment1/fqc_results/*.zip
do
unzip -o $zipfile -d ~/Assignment1/fqc_results
done
cat ~/Assignment1/fqc_results/*fastqc/fastqc_data.txt | grep -E "Filename|Total Sequences" > ~/Assignment1/fqc_results/fastqc_summaries.txt 

cat ~/Assignment1/fqc_results/*fastqc/summary.txt >> ~/Assignment1/fqc_results/fastqc_summaries.txt


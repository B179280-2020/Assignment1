#!/bin/bash
for fastqfile in /localdisk/data/BPSM/Assignment1/fastq/*.fq.gz
do
  fastqc -o ~/Assignment1/fqc_results $fastqfile
done
for zipfile in ~/Assignment1/fqc_results/*.zip
do
unzip -o $zipfile -d ~/Assignment1/fqc_results
done


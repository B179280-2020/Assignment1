#!/bin/bash
for fastqfile in /localdisk/data/BPSM/Assignment1/fastq/*.fq.gz
do
  fastqc -o ~/Assignment1/fqc_results $fastqfile
done

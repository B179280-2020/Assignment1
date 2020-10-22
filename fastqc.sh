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

#copy the reference genome, preparing to establish index
cp -r /localdisk/data/BPSM/Assignment1/Tbb_genome ./ref
#copy the original fastq directory to current path
cp -r /localdisk/data/BPSM/Assignment1/fastq ./data
#change directory
cd ./ref/
#unzip
gunzip Tb927_genome.fasta.gz
#establish index
bowtie2-build Tb927_genome.fasta Tbb
#reture to last directory
cd ../
#alignment, change the .sam file to .bam file
while read number type fq1 fq2
do
bowtie2 -x ./ref1/Tbb -1 ./data/$fq1 -2 ./data/$fq2 -S ./data/$number.$type.sam
samtools view -S -b ./data/$number.$type.sam > ./data/$number.$type.bam
samtools sort ./data/$number.$type.bam -o ./data/$number.$type.sorted.bam
samtools index ./data/$number.$type.sorted.bam
done < ./data/fqfiles


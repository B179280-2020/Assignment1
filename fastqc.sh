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
#cope reference genome sequence data
cp -r /localdisk/data/BPSM/Assignment1/Tbb_genome ./ref
#copy the original fastq directory to current path
cp -r /localdisk/data/BPSM/Assignment1/fastq ./data
#unzip
gunzip ./data/*.gz
#change directory
cd ./ref/
#unzip
gunzip Tb927_genome.fasta.gz
#establish index
bowtie2-build Tb927_genome.fasta Tbb
#reture to last directory
cd ../
#alignment, producing .sam file
for i in 216 218 219 220 221 222
do
bowtie2 -x ./ref/Tbb -1 ./data/$i"_L8_1.fq" -2 ./data/$i"_L8_2.fq" -S ./data/"$i".sam

#change .sam to .bam, sort the bam file and index them
samtools view -S -b ./data/$i".sam" > ./data/$i".bam"
samtools sort ./data/$i".bam" -o ./data/$i".sorted.bam"
samtools index ./data/$i".sorted.bam"
done




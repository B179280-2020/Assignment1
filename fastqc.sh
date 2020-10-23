#!/bin/bash
#Executing the fastqc with iteration, then  putting the results into a new directory for storage
mkdir ./fastqc_results
for fastqfile in /localdisk/data/BPSM/Assignment1/fastq/*.fq.gz
do
  fastqc -o ./fastqc_results $fastqfile
done

#unzip each result file with .zip

for zipfile in ./fastqc_results/*.zip
do
unzip -o $zipfile -d ./fastqc_results
done

#assess the numbers and quality of sequence data based on fastqc output, putting the information into a file for summary

cat ./fastqc_results/*fastqc/fastqc_data.txt | grep -E "Filename|Total Sequences" > fastqc_summaries.txt 

cat ./fastqc_results/*fastqc/summary.txt >> fastqc_summaries.txt

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
mkdir ./bowtie2
while read number type fq1 fq2
do
bowtie2 -x ./ref/Tbb -1 ./data/$fq1 -2 ./data/$fq2 -S ./bowtie2/$number.$type.sam
samtools view -S -b ./bowtie2/$number.$type.sam > ./bowtie2/$number.$type.bam
samtools sort ./bowtie2/$number.$type.bam -o ./bowtie2/$number.$type.sorted.bam
samtools index ./bowtie2/$number.$type.sorted.bam
done < ./data/fqfiles
#generate counts data using bedtools, making all the slender data in one file, all the stumpy data in another file
mkdir ./counts_data

for i in ./bowtie2/*Slender.sorted.bam
do
bedtools multicov -bams $i -bed /localdisk/data/BPSM/Assignment1/Tbbgenes.bed >> ./counts_data/Slender_counts.bed
done

for m in ./bowtie2/*Stumpy.sorted.bam
do
bedtools multicov -bams $m -bed /localdisk/data/BPSM/Assignment1/Tbbgenes.bed >> ./counts_data/Stumpy_counts.bed
done

#sort the Slender and Stumpy counts file
sort -k1,1 -k2,2n ./counts_data/Slender_counts.bed > ./counts_data/Slender_counts_sorted.bed
sort -k1,1 -k2,2n ./counts_data/Stumpy_counts.bed > ./counts_data/Stumpy_counts_sorted.bed

#calculate the mean of the counts per gene for slender and stumpy samples

bedtools groupby -i ./counts_data/Slender_counts_sorted.bed -g 1-4 -c 7 -o mean > ./counts_data/average_Slender_counts.bed
bedtools groupby -i ./counts_data/Stumpy_counts_sorted.bed -g 1-4 -c 7 -o mean > ./counts_data/average_Stumpy_counts.bed

#extract gene name, mean for slender and stumpy, combine them into one file 
awk '{print $4;}' ./counts_data/average_Slender_counts.bed > ./counts_data/genename.txt
awk '{print $5;}' ./counts_data/average_Slender_counts.bed > ./counts_data/onlySlender.txt
awk '{print $5;}' ./counts_data/average_Stumpy_counts.bed > ./counts_data/onlyStumpy.txt
echo -e "Gene name \tSlender mean \tStumpy mean" > Average_counts_whole.txt
paste ./counts_data/genename.txt ./counts_data/onlySlender.txt ./counts_data/onlyStumpy.txt >> Average_counts_whole.txt
#completed


#!/bin/bash
INPUT="$1"
#trimming
IN_DIR="${INPUT}fastq_files/"
OUTPUT_DIR_FASTQC="${INPUT}fastqc_trimmed/"
OUTPUT_DIR_TRIM="${INPUT}trimmed_files/"
mkdir -p $OUTPUT_DIR_FASTQC
mkdir -p $OUTPUT_DIR_TRIM
cd $IN_DIR
for sample in $(ls -R *.fastq.gz); do
	echo $sample;
	java -jar /private/software/packages/Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads 3 -phred33 $sample "$OUTPUT_DIR_TRIM${sample%%.*}_trimmed.fastq.gz" ILLUMINACLIP:/home/stu/nissan/Tamar/imported_data/TruSeq-All_Bili_adaptors.fa:2:30:10:2 LEADING:3 TRAILING:3 MINLEN:20
done &> trim.txt&
#re-run fastqc
cd $OUTPUT_DIR_TRIM
for sample in $(ls -R *.fastq.* ); do 
	echo $sample;
	fastqc $sample -o $OUTPUT_DIR_FASTQC;
	echo -e "Finished\n"
done &>${OUTPUT_DIR_FASTQC}fastqc.txt &
#run multiqc on all the files
multiqc $OUTPUT_DIR
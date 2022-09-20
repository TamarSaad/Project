#!/bin/bash
INPUT="$1"
#fastqc
WANTED_DIR="${INPUT}fastq_files/";
OUTPUT_DIR="${INPUT}fastqc_files/";
mkdir -p $WANTED_DIR;
mkdir -p $OUTPUT_DIR;
#get into the directory with the fastq files
cd $WANTED_DIR;
for sample in $(ls -R *.fastq.*); do 
	echo $sample;
	fastqc $sample -o $OUTPUT_DIR;
	echo -e "Finished\n"
done &>${OUTPUT_DIR}fastqc.txt
#run multiqc on all the files
multiqc $OUTPUT_DIR &>multiqc.txt&

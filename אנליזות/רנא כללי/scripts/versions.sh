#!/bin/bash
#print the version of each program
declare -a StringArray=("fastqc" "multiqc" "STAR" "samtools") #"htseq-count" "trimmomatic")
echo "check manually htseq-count version by printing "htseq-count --help"">versions.txt
echo "########################################################">>versions.txt
for program in ${StringArray[@]}; do
	echo ${program}:
  $program --version;
done &>>versions.txt&
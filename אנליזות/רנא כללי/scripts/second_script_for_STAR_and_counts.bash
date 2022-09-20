#!/bin/bash
INPUT="$1"
#star
WANTED_DIR="${INPUT}STAR/";
IN_DIR="${INPUT}fastq_files";
mkdir -p $WANTED_DIR
cd $IN_DIR;
genomeDir="/home/stu/nissan/software/STAR/STARgenomes/ENSEMBL/mus_musculus/ENSEMBL.mus_musculus.GRCm38.noAnnot";
for sample in $(ls -R *.fastq.gz); do 
	echo $sample; 
	echo ${sample%%.*};
	/private/software/bin/STAR --genomeDir $genomeDir --runThreadN 6 --readFilesIn <(gunzip -c $sample) --outFileNamePrefix "$WANTED_DIR/${sample%%.*}_" --outSAMtype BAM SortedByCoordinate --outSAMunmapped Within --outSAMattributes Standard;
done &>star.log
#read count
IN_DIR="${INPUT}STAR/"
PROCESS_FILE="RNA_Seq_count.txt"
cd $IN_DIR
for count in $(ls *Aligned.sortedByCoord.out.bam); do
	echo "count:"$count;
	/private/software/bin/samtools view -c -F 4 $count ;
done &> $PROCESS_FILE
#bam sort
IN_DIR="${INPUT}STAR/"
PROCESS_FILE="RNA_Seq_sort.txt"
OUTPUT_DIR="${INPUT}bam_sorted/"
mkdir -p $OUTPUT_DIR;
cd $IN_DIR;
for bamFile in $(ls *Aligned.sortedByCoord.out.bam); do
	echo "sort: "$bamFile;
	/private/software/bin/samtools sort $bamFile -o ${bamFile%%.*}.sorted -@ 4;
done &>$PROCESS_FILE
mv *.sorted $OUTPUT_DIR
#HTSeq
IN_DIR="${INPUT}bam_sorted/"
OUTPUT_DIR="${INPUT}counts"
mkdir -p $OUTPUT_DIR
GENOME_DIR="/home/stu/nissan/software/htseq_genome/Mus_musculus.GRCm38.99.gtf"
cd $IN_DIR
for sample in $(ls *.sorted); do
	echo "sample: "$sample;
	htseq-count -f bam -s no --idattr=gene_name $sample $GENOME_DIR > ${sample%%.*}_htseq_ens.txt;
done &>htseq_ens.log
mv *_ens.txt $OUTPUT_DIR
cd $OUTPUT_DIR
#change files names
for sample in $(ls *.txt); do
	echo $sample;
	mv -- "$sample" "${sample%_R1*}.txt";
done
#merge the counts to one file
INPUT_FILE="countdata"
COUNTS_DIR="${INPUT}counts"
SCRIPT_DIR="/home/stu/nissan/Tamar/imported_scripts/htseq-merge_all.R"
Rscript $SCRIPT_DIR $COUNTS_DIR $INPUT_FILE
#turn to csv
INPUT_FILE="countdata.txt"
OUTPUT_FILE="countdata.csv"
sed -e 's/[[:space:]]\{1,\}/,/g' $INPUT_FILE > $OUTPUT_FILE
#!/bin/bash
#set the pathway to the project
PROJECT_DIR="$1"
RAW_DIR=$PROJECT_DIR/raw_data
# get into enviroment
cd $RAW_DIR
#open all the files from zipped format
gunzip *.fastq.gz
#create directory for qza files
cd ..
mkdir -p qza
#turn the files to qza by manifest
qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' --input-path manifest.tsv --input-format PairedEndFastqManifestPhred33V2 --output-path qza/demux-paired-end.qza
#turn to qzv for visulization
mkdir -p vis
qiime demux summarize --i-data qza/demux-paired-end.qza --o-visualization vis/demux-paired-end.qzv
#!/bin/bash
INPUT_DIR="$1"
OUTPUT_DIR="$2"
#sklearn classifying by gtdb
#path to animal distal gut gtdb: ~/Documents/gtdb_r89_animal-distal-gut_classifier.qza
#path to human stool: ~/Documents/gtdb_r89_human-stool_classifier.qza
qiime feature-classifier classify-sklearn --i-reads ${INPUT_DIR}dada2_rep-seqs.qza --i-classifier ~/Documents/gtdb_r89_animal-distal-gut_classifier.qza --o-classification ${OUTPUT_DIR}gtdb/qza/classified.qza --verbose
#visualization
qiime metadata tabulate --m-input-file ${OUTPUT_DIR}gtdb/qza/classified.qza --o-visualization ${OUTPUT_DIR}gtdb/vis/taxonomy.qzv
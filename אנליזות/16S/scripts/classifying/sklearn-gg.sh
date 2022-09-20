#!/bin/bash
INPUT_DIR="$1"
OUTPUT_DIR="$2"
#sklearn classifying by greengenes
qiime feature-classifier classify-sklearn --i-reads ${INPUT_DIR}dada2_rep-seqs.qza --i-classifier ~/Documents/gg-13-8-99-nb-classifier.qza --o-classification ${OUTPUT_DIR}greengenes/qza/classified.qza --verbose
#visualization
qiime metadata tabulate --m-input-file ${OUTPUT_DIR}greengenes/qza/classified.qza --o-visualization ${OUTPUT_DIR}greengenes/vis/taxonomy.qzv
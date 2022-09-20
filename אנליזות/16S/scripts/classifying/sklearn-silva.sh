#!/bin/bash
INPUT_DIR="$1"
OUTPUT_DIR="$2"
#sklearn classifying by silva
qiime feature-classifier classify-sklearn --i-reads ${INPUT_DIR}dada2_rep-seqs.qza --i-classifier ~/Documents/silva-138-99-nb-classifier.qza --o-classification ${OUTPUT_DIR}silva/qza/classified.qza --verbose
#visualization
qiime metadata tabulate --m-input-file ${OUTPUT_DIR}silva/qza/classified.qza --o-visualization ${OUTPUT_DIR}silva/vis/taxonomy.qzv
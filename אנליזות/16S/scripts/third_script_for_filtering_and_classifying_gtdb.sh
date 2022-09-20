#!/bin/bash
min_frequency_seq="$1"
#sklearn classifying by gtdb
#path to animal distal gut gtdb: ~/Documents/gtdb_r89_animal-distal-gut_classifier.qza
#path to human stool: ~/Documents/gtdb_r89_human-stool_classifier.qza

#filter samples with less than $min_frequency_seq number of sequences
#qiime feature-table filter-features --i-table qza/dada2_table.qza --p-min-frequency $min_frequency_seq --o-filtered-table qza/filtered-table.qza
#classify with gtdb
qiime feature-classifier classify-sklearn --i-reads qza/dada2_rep-seqs.qza --i-classifier ~/Documents/gtdb_r89_animal-distal-gut_classifier.qza --o-classification qza/sk-classified.qza --verbose
#visualization
qiime metadata tabulate --m-input-file qza/sk-classified.qza --o-visualization vis/taxonomy.qzv
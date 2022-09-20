#!/bin/bash
min_frequency_reads="$1"
min_frequency_seq="$2"

mkdir -p filtered-sequences
#filter samples with less than $min_frequency_reads number of reads 
qiime feature-table filter-samples --i-table qza/dada2_table.qza --p-min-frequency $min_frequency_reads --o-filtered-table filtered-sequences/filtered-table.qza
#filter samples with less than $min_frequency_seq number of sequences
qiime feature-table filter-features --i-table filtered-sequences/filtered-table.qza --p-min-frequency $min_frequency_seq --o-filtered-table filtered-sequences/feature-frequency-filtered-table.qza
#clusify with green genes database
qiime feature-classifier classify-sklearn --i-reads filtered-sequences/feature-frequency-filtered-table.qza --i-classifier ~/Documents/gg-13-8-99-nb-classifier.qza  --o-classification qza/sk-classified.qza --verbose
#visualization
qiime metadata tabulate --m-input-file qza/sk-classified.qza --o-visualization vis/taxonomy.qzv
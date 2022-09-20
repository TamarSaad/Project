#!/bin/bash

#filter from mitochondria and chloroplast
qiime taxa filter-table --i-table qza/dada2_table.qza --i-taxonomy qza/sk-classified.qza --p-exclude mitochondria,chloroplast --o-filtered-table qza/table-clean.qza
#filter from archaea
qiime taxa filter-table --i-table qza/table-clean.qza --i-taxonomy qza/sk-classified.qza --p-exclude "k__Archaea; k__Eukaryota" --o-filtered-table qza/table-archaea-clean.qza
#filter from eukaryota
qiime taxa filter-table --i-table qza/table-archaea-clean.qza --i-taxonomy qza/sk-classified.qza --p-exclude "k__Eukaryota" --o-filtered-table qza/table-archaea-eukaryota-clean.qza
#same for sequences
qiime taxa filter-seqs --i-sequences qza/dada2_rep-seqs.qza --i-taxonomy qza/sk-classified.qza --p-exclude mitochondria,chloroplast --o-filtered-sequences qza/rep-seq-clean.qza
qiime taxa filter-seqs --i-sequences qza/rep-seq-clean.qza --i-taxonomy qza/sk-classified.qza --p-exclude "k__Archaea; k__Eukaryota" --o-filtered-sequences qza/rep-seq-archaea-clean.qza
qiime taxa filter-seqs --i-sequences qza/rep-seq-archaea-clean.qza --i-taxonomy qza/sk-classified.qza --p-exclude "k__Eukaryota" --o-filtered-sequences qza/rep-seq-archaea-eukaryota-clean.qza
mv qza/table-archaea-eukaryota-clean.qza qza/filtered-table.qza
mv qza/rep-seq-archaea-eukaryota-clean.qza qza/filtered-rep-seq.qza
qiime taxa barplot --i-table qza/filtered-table.qza --i-taxonomy qza/sk-classified.qza --m-metadata-file meta-data.tsv --o-visualization vis/taxa-bar-plots.qzv


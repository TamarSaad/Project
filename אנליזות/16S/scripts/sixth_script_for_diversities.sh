#!/bin/bash
min_frequency="$1"
metadata_column="$2"
#create different types of diversities
qiime diversity core-metrics-phylogenetic --i-phylogeny qza/fastree-rooted.qza --i-table qza/filtered-table.qza --p-sampling-depth $min_frequency --m-metadata-file meta-data.tsv --output-dir diversity-metrics-results
#faith alpha diversity
qiime diversity alpha-group-significance --i-alpha-diversity diversity-metrics-results/faith_pd_vector.qza --m-metadata-file meta-data.tsv --o-visualization diversity-metrics-results/faith-pd-group-significance.qzv
#Shannon alpha diversity
qiime diversity alpha-group-significance --i-alpha-diversity diversity-metrics-results/shannon_vector.qza --m-metadata-file meta-data.tsv --o-visualization diversity-metrics-results/shannon-group-significance.qzv
#weighted-unifrac beta diversity
qiime diversity beta-group-significance --i-distance-matrix diversity-metrics-results/weighted_unifrac_distance_matrix.qza --m-metadata-file meta-data.tsv --m-metadata-column $metadata_column --o-visualization diversity-metrics-results/weighted-unifrac-significance.qzv --p-pairwise
#unweighted-unifrac beta diversity
qiime diversity beta-group-significance --i-distance-matrix diversity-metrics-results/unweighted_unifrac_distance_matrix.qza --m-metadata-file meta-data.tsv --m-metadata-column $metadata_column --o-visualization diversity-metrics-results/unweighted-unifrac-significance.qzv --p-pairwise
#PCoA
qiime emperor plot --i-pcoa diversity-metrics-results/unweighted_unifrac_pcoa_results.qza --m-metadata-file meta-data.tsv --o-visualization diversity-metrics-results/unweighted-unifrac-emperor.qzv
#start exporting
qiime tools export --input-path qza/filtered-table.qza --output-path exports
biom convert -i exports/feature-table.biom -o exports/otu_table.txt --to-tsv
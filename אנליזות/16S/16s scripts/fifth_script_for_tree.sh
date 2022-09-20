#!/bin/bash
#alignment
qiime alignment mafft --i-sequences qza/filtered-rep-seq.qza --o-alignment qza/aligned-rep-seqs.qza
#mask
qiime alignment mask --i-alignment qza/aligned-rep-seqs.qza --o-masked-alignment qza/masked-aligned-rep-seqs.qza
#create tree
qiime phylogeny fasttree --i-alignment qza/masked-aligned-rep-seqs.qza --o-tree qza/fasttree-tree.qza --verbose
#finding root
qiime phylogeny midpoint-root --i-tree qza/fasttree-tree.qza --o-rooted-tree qza/fastree-rooted.qza
#export
qiime tools export --input-path qza/fastree-rooted.qza --output-path exports
#export the files
qiime tools export --input-path qza/filtered-table.qza --output-path exports
biom convert -i exports/feature-table.biom -o exports/otu_table.txt --to-tsv
biom convert -i exports/feature-table.biom -o exports/json-table.biom --table-type="OTU table" --to-json
qiime tools export --input-path qza/sk-classified.qza --output-path exports
#visualization
qiime feature-table summarize --i-table qza/filtered-table.qza --o-visualization vis/filtered-table.qzv --m-sample-metadata-file meta-data.tsv
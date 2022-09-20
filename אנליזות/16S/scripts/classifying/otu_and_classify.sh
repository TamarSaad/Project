#!/bin/bash
MAIN_DIR="$1"
QZA_DIR=${MAIN_DIR}qza/
cd $MAIN_DIR
#create otu directory
mkdir -p otu
OTU=${MAIN_DIR}/otu/
cd $OTU
mkdir -p qza
mkdir -p vis
cd ..
#create otu table
qiime vsearch cluster-features-de-novo --i-table ${QZA_DIR}dada2_table.qza --i-sequences ${QZA_DIR}dada2_rep-seqs.qza --p-perc-identity 0.99 --o-clustered-table ${OTU}qza/dada2_table.qza --o-clustered-sequences ${OTU}qza/dada2_rep-seqs.qza --verbose
#visualization
qiime feature-table tabulate-seqs --i-data ${OTU}qza/dada2_rep-seqs.qza --o-visualization ${OTU}vis/rep-seqs-dn-99.qzv
#sklearn
SKLEARN="/home/stu/nissan/Tamar/16s_scripts/cluster_and_classify/classifying_sklearn.sh"
/usr/bin/chmod +x $SKLEARN
"$SKLEARN" $OTU
#vsearch classification
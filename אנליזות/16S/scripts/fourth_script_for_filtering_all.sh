#!/bin/bash
MAIN_DIR="$1"
#go through all the files without otu and filter them
for file in $(find $MAIN_DIR -maxdepth 4 -name *classified.qza -type f); do 
	#get the directory path
	DIR=$(dirname $file)
	#filter from mitochondria & chloroplast
	qiime taxa filter-table --i-table ${MAIN_DIR}qza/dada2_table.qza --i-taxonomy $file --p-exclude mitochondria,chloroplast --o-filtered-table ${DIR}/table-clean.qza
	#same filtering for rep-seqs
	qiime taxa filter-seqs --i-sequences ${MAIN_DIR}qza/dada2_rep-seqs.qza --i-taxonomy $file --p-exclude mitochondria,chloroplast --o-filtered-sequences ${DIR}/rep-seq-clean.qza
done

#go through all the files with otu and filter them
for file in $(find $MAIN_DIR -mindepth 5 -name *classified.qza -type f); do 
	DIR=$(dirname $file)
	qiime taxa filter-table --i-table ${MAIN_DIR}otu/qza/dada2_table.qza --i-taxonomy $file --p-exclude mitochondria,chloroplast --o-filtered-table ${DIR}/table-clean.qza
	#same filtering for rep-seqs
	qiime taxa filter-seqs --i-sequences ${MAIN_DIR}otu/qza/dada2_rep-seqs.qza --i-taxonomy $file --p-exclude mitochondria,chloroplast --o-filtered-sequences ${DIR}/rep-seq-clean.qza
done

#now all thae files hace equal names and location, so we loop through them together
for file in $(find $MAIN_DIR -mindepth 3 -name *classified.qza -type f); do 
	#get the directory path
	DIR=$(dirname $file)
	#filter from eukaryote and archea, table:
	qiime taxa filter-table --i-table ${DIR}/table-clean.qza --i-taxonomy $file --p-exclude "k__Archaea; k__Eukaryota" --o-filtered-table ${DIR}/table-a-e-clean.qza
	#rep-seqs:
	qiime taxa filter-seqs --i-sequences ${DIR}/rep-seq-clean.qza --i-taxonomy $file --p-exclude "k__Archaea; k__Eukaryota" --o-filtered-sequences ${DIR}/rep-seq-a-e-clean.qza
	#visualization
	MOM_DIR=$(dirname $DIR);
	qiime taxa barplot --i-table ${DIR}/table-a-e-clean.qza --i-taxonomy $file --m-metadata-file ${MAIN_DIR}meta-data.tsv --o-visualization ${MOM_DIR}/vis/taxa-bar-plots.qzv
done

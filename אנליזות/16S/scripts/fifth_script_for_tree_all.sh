#!/bin/bash
MAIN_DIR="$1"
for file in $(find $MAIN_DIR -mindepth 3 -name *rep-seq-a-e-clean.qza -type f); do 
	echo $file
	DIR=$(dirname $file)
	MOM_DIR=$(dirname $DIR)
	#alignment
	qiime alignment mafft --i-sequences $file --o-alignment ${DIR}/aligned-rep-seqs.qza
	#mask
	qiime alignment mask --i-alignment ${DIR}/aligned-rep-seqs.qza --o-masked-alignment ${DIR}/masked-aligned-rep-seqs.qza
	#create tree
	qiime phylogeny fasttree --i-alignment ${DIR}/masked-aligned-rep-seqs.qza --o-tree ${DIR}/fasttree-tree.qza --verbose
	#finding root
	qiime phylogeny midpoint-root --i-tree ${DIR}/fasttree-tree.qza --o-rooted-tree ${DIR}/fastree-rooted.qza
	#export
	qiime tools export --input-path ${DIR}/fastree-rooted.qza --output-path ${MOM_DIR}/exports
	#export the files
	qiime tools export --input-path ${DIR}/table-a-e-clean.qza --output-path ${MOM_DIR}/exports
	biom convert -i ${MOM_DIR}/exports/feature-table.biom -o ${MOM_DIR}/exports/otu_table.txt --to-tsv
	biom convert -i ${MOM_DIR}/exports/feature-table.biom -o ${MOM_DIR}/exports/json-table.biom --table-type="OTU table" --to-json
	qiime tools export --input-path ${DIR}/classified.qza --output-path ${MOM_DIR}/exports
	#visualization
	qiime feature-table summarize --i-table ${DIR}/table-a-e-clean.qza --o-visualization ${MOM_DIR}/vis/filtered-table.qzv --m-sample-metadata-file ${MAIN_DIR}meta-data.tsv
done

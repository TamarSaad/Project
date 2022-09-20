#!/bin/bash
MAIN_DIR="$1"
QZA_DIR=${MAIN_DIR}qza/
#create the folders of sklearn
cd $MAIN_DIR
mkdir -p sklearn
cd sklearn
mkdir -p greengenes
cd greengenes
mkdir -p qza
mkdir -p vis
cd ..
mkdir -p silva
cd silva
mkdir -p qza
mkdir -p vis
cd ..
mkdir -p gtdb
cd gtdb
mkdir -p qza
mkdir -p vis
cd $MAIN_DIR
#call greengenes
SK_GG="/home/stu/nissan/Tamar/16s_scripts/cluster_and_classify/sklearn-gg.sh"
/usr/bin/chmod 777 $SK_GG
SK_DIR=${MAIN_DIR}sklearn/
"$SK_GG" $QZA_DIR $SK_DIR
#call silva
SK_SILVA="/home/stu/nissan/Tamar/16s_scripts/cluster_and_classify/sklearn-silva.sh"
/usr/bin/chmod 777 $SK_SILVA
"$SK_SILVA" $QZA_DIR $SK_DIR
#call gtdb
SK_GTDB="/home/stu/nissan/Tamar/16s_scripts/cluster_and_classify/sklearn-gtdb.sh"
/usr/bin/chmod +x $SK_GTDB
"$SK_GTDB" $QZA_DIR $SK_DIR
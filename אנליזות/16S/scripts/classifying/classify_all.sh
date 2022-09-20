#!/bin/bash
MAIN_DIR="$1"
SK="/home/stu/nissan/Tamar/16s_scripts/cluster_and_classify/classifying_sklearn.sh"
/usr/bin/chmod +x $SK
"$SK" $MAIN_DIR
OTU="/home/stu/nissan/Tamar/16s_scripts/cluster_and_classify/otu_and_classify.sh"
/usr/bin/chmod +x $OTU
"$OTU" $MAIN_DIR
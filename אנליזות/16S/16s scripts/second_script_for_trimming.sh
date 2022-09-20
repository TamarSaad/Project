LEFT_F="$1"
LEFT_R="$2"
RIGHT_F="$3"
RIGHT_R="$4"
#trimming
qiime dada2 denoise-paired --i-demultiplexed-seqs qza/demux-paired-end.qza --p-trim-left-f $LEFT_F --p-trim-left-r $LEFT_R --p-trunc-len-f $RIGHT_F --p-trunc-len-r $RIGHT_R --o-table qza/dada2_table.qza --p-chimera-method consensus --verbose --o-representative-sequences qza/dada2_rep-seqs.qza --o-denoising-stats qza/dada2_denoising-stats.qza > qza/denoise.log
#check results
qiime metadata tabulate --m-input-file qza/dada2_denoising-stats.qza --o-visualization vis/dada2_denoising-stats.qzv
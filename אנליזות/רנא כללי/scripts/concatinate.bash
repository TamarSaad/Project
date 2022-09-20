for i in $(ls -R *.fastq.*) do
	echo $(ls -R ${i%_L00*});
	echo $(ls -R ${i%_L00*}*.fastq.gz);
	cat $(ls -R ${i%_L00*}*.fastq.gz)> ../fastq_concatinated/${i%_L00*}.fastq.gz;
done
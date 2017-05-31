list='cat IDfile.txt'
for i in $list
do
	echo $i
    fastq-dump --split-files $i
	bwa mem reference.fasta "${i}_1.fastq" "${i}_2.fastq" > "${i}_paired.sam"
	samtools view -bS "${i}_paired.sam" -o "${i}_paired.bam"
	samtools sort "${i}_paired.bam" "${i}_paired_sorted"
	samtools index "${i}_paired_sorted.bam"
done


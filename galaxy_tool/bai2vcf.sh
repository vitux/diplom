list='cat IDfile.txt'
for i in $list
do 
	echo ${list[@]}
    java -Xmx3g pilon-1.21.jar --genome reference.fasta 
	    --frags "${i}_paired_sorted.bam" --output ${i} --vcf
	bgzip "${i}.vcf"
	tabix -p vcf "${i}.vcf.gz"
	vcftools --gzvcf "${i}.vcf.gz" --remove-filtered-all
        	--remove-INFO IMPRECISE --recode --out "${i}_filter"
	bgzip "${i}_filter.recode.vcf"
	tabix -p vcf "${i}_filter.recode.vcf.gz"
	echo "${i}_filter.recode.vcf.gz" >> vcf_files.txt
done


vcf_list='cat vcf_files.txt'
vcf-merge -d $vcf_list > SampleGenome_merge.vcf.gz
bgzip -d SampleGenome_merge.vcf.gz
grep \# SampleGenome_merge.vcf > SampleGenome_merge.variant.vcf
grep 1\/1 SampleGenome_merge.vcf >> SampleGenome_merge.variant.vcf 
sed -E -i 's/ID=AD,Number=./ID=AD,Number=R/' SampleGenome_merge.variant.vcf
vt/vt decompose -s -o SampleGenome_mergeD.var.vcf SampleGenome_merge.variant.vcf
vt/vt normalize -r H37Rv_reference.fasta -o SampleGenome_mergeDN.var.vcf SampleGenome_mergeD.var.vcf
sed 's/NC_000962.3/NC_000962/' SampleGenome_mergeDN.var.vcf > SampleGenome_mergeDNF.var.vcf
java -Xmx3G -jar snpEff/snpEff.jar -c snpEff/snpEff.config -s OutputStats.html
    -v -no-downstream -no-upstream m_tuberculosis_H37Rv SampleGenome_mergeDNF.var.vcf
	> SampleGenome_merge.var.ann.vcf
sed -E -i 's/AC=[0-9]+;AN=[0-9]+;SF=([0-9]+,)+[0-9]+;//g' SampleGenome_merge.var.ann.vcf
perl -pi -ane 's/AC\=\d+\;|AC\=(\d+,)+\d+\;//g; s/AN\=\d+\;|AN\=(\d+,)+\d+\;//g; s/SF\=(\d+,)+\d+\;//g;'
    SampleGenome_merge.var.ann.vcf
perl -pi -ane 's/OLD_.+\;//g;' SampleGenome_merge.var.ann.vcf
sed -i 's/|/\t/g' SampleGenome_merge.var.ann.vcf
sed -E -i 's/_FJnc962filter.recode_SAMPLE//g'  SampleGenome_merge.var.ann.vcf
perl -pi -ane 's/\t0\/0/\t$F[3]/g; s/\t1\/1/\t$F[4]/g; s/\t\.\/\./\tX/g; s/\t\./\tNA/g; $"=" ";'
    SampleGenome_merge.var.ann.vcf


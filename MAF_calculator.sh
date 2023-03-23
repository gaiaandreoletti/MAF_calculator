#!/bin/bash
#Gaia Andreoletti
echo $(date) # Will print the output of date command

# to calculate the frequency of each allele compute the sum of ref+alt allele. store sum in $4
awk '{ sumrows=0; for (i=2; i<=NF; i++) { sumcols[i]+= $i; sumrows+= $i}; print $0,"\t",sumrows+0}' sampleFile.txt > temp1
# remove header because annoying in calulation for frequency
tail -n +2 temp1 > temp2
# freq of REF allele
awk '$4 != 0 { print $2/$4 }' temp2 > temp3
# freq of ALT allele
awk '$4 != 0 { print $3/$4 }' temp2 > temp4

#put the computed frequency as columns to the original file
paste temp2 temp3 temp4 > temp5

# calculate MAF
awk 'NR > 5 { maf = ($5 > 0.5 ? 1 - $5 : $5); print$0,"\t", maf }' temp5 > temp6

# Add header for final output file
echo -e "SNPname	ReferenceAlleleCount	AlternateAlleleCount 	 SUM_AllelesCount 	 FreqREF 	 FreqALTR 	 MAF" > header
cat header temp6 > MAF_sampleFile_per_SNPs.txt

#remove temporary files - clean up
rm temp* header

## i have added a loop in case there will be multiple files per person ( a loop can be easily added even in the first section of the script to loop thoughmultiple files.
## store file names in a variable called name
## loop trought the file and print how many SNPS satisfy the condition in each file
ls MAF*txt > name
for i in `cat name`
do
echo -ne "$i"; awk '(0.02 <= $7 && $7 <= 0.3){print $1,$7}' $i |  wc -l
done

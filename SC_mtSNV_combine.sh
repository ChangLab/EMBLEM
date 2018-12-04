# STEP 1: filter mtSNV
# $17>2 && $18>2 ( make sure both positive and negative strand were called 
# Minor  Allele frequency more than 0.01 
# remove G->T and C->A, "N"
# sequence depth >= 100*5=500, the sequence depth criteria should be adjust according to the data. 
# input file *.snv from pool_output/*.merge.mt.mpileup.q20Q30.snv
path="/home/jinxu/scATAC/Normal_HSC/BM0106-160219-LS/output/"
Project_infor="BM0106-160219-LS"
for file in `ls $path/pool_output/*.mt.mpileup.q20Q30.snv` 
do
awk '$17>2 && $18>2' $file | sed '1,1d' |awk '$6/($6+$5)<=0.90 && $6/($6+$5)>=0.01' |awk '!($3=="G" && $6=="T")' |awk '!($3=="C" && $6=="A")' |awk '$3!="N"'  | awk ' $6+$5>=500 ' >$file.filter
awk '{print $1"\t"$2"\t"$3"\t"$19"\t"$5"\t"$6"\t"$6/($5+$6)}' $file.filter|awk '{if($7>0.5){$7=(1-$7)}print $0}'  |sort -k7nr > $file.filter.addfreq.sort
done
#STEP 2: 
perl  get_SNV_table.pl  $path $Project_infor 1>scSNV_matrix.txt 2>Site.list
# STEP 3 :
# using the R scripts to visualize the barcode group 
# STEP 4 : prepare input file for MEGA(phylogenetic analysis) 

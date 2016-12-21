#1/bin/bash

#Purpose: Concatenate raw read files and trim using trimmomatic
#         Results in four files, paired1, paired2, and unpaired

#Usage: auto_cat_and_trim.sh path/to/dir1 path/to/dir2 ....

#skewer -l 25 -m pe -o skewer --mean-quality 2 --end-quality 2 -t 30 -x /opt/Trimmomatic-0.32/adapters/NexteraPE-PE.fa combined-1.fastq.gz combined-2.fastq.gz


for dir in $@
do
        cat $dir/*R1*.fastq.gz > $dir/combined_1.fastq.gz
        cat $dir/*R2*.fastq.gz > $dir/combined_2.fastq.gz
        FORWARD=$dir/combined_1.fastq.gz;
        REVERSE=$dir/combined_2.fastq.gz;

        nohup trimmomatic PE -threads 16 $FORWARD $REVERSE $dir/paired-1.fastq.gz $dir/unpaired-1.fastq.gz $dir/
paired-2.fastq.gz $dir/unpaired-2.fastq.gz ILLUMINACLIP:/opt/Trimmomatic-0.32/adapters/NexteraPE-PE.fa:2:30:10 LEADI
NG:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 &
done

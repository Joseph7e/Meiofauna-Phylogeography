#!/bin/bash
#Author: JOseph Sevigny
#Date: Novemeber 2016
#Affiliation: HCGS


contig_ref=$1
reads_for=$2
reads_rev=$3
#unpaired=$4
name=$(basename $1)
outdir=$(echo $name | cut -f 1 -d '.')
mkdir $outdir

#index genome assembly
bwa index -a bwtsw $1

# run bwa
bwa mem -M -t 10  $1 $2 $3 > $outdir/raw_mapped.sam

#sort pe sam file and retain only mapped reads
samtools view -@ 30 -Sb -F 4  $outdir/raw_mapped.sam  | samtools sort -n -@ 8 - $outdir/sorted_mapped
samtools index $outdir/sorted_mapped.bam

#extract_mapped_reads

nohup bam2fastq -o $outdir/mapped#.fastq --aligned $outdir/sorted_mapped.bam &
#nohup bam2fastx -q -M -P -o $outdir/mapped_reads.fastq $outdir/sorted_mapped.bam &

#determine coverage_info

bioawk -c fastx '{ print $name, length($seq) }' < $1 > $outdir/genome.txt
genomeCoverageBed -ibam $outdir/sorted_mapped.bam -g genome.txt > $outdir/coverage.txt

#find mapping matrics
samtools flagstat $outdir/raw_mapped.sam > $outdir/mapping_metrics.txt

#find insert sizes
picard-tools CollectInsertSizeMetrics \
     I=$outdir/sorted_mapped.bam \
     O=$outdir/name_insert_size_metrics.txt \
     H=name_insert_size_histogram.pdf \
     M=0.5
rm $outdir/raw_mapped.sam
gzip $outdir/*.fastq


echo nohup bowtie2 $outdir/ --un-conc-gz $outdir/ --al-conc-gz $outdir/ --al-gz $outdir/ --un-gz \
-x $contig_ref -1 $reads_for -2 $reads_rev -r $unpaired\
-p 20 -S sample_a8.sam &

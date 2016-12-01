#!/bin/bash

#Author: Joseph Sevigny
#assumes spades assembler
#requires parse_json.py in path

contig_file=$1
blast_file=$2
out_file=$(echo $2 | cut -d'_' -f 1)

blobtools_installation_path=/home/genome/kdiaz/programs/blobtools/blobtool
names_dmp=/home/genome/kdiaz/databases/names.dm
nodes_dmp=/home/genome/kdiaz/databases/nodes.dmp

$blobtools_installation_path create -i $contig_file -y spades --nodes $nodes_dmp --names $names_dmp -t $blast_file -o $out_file

echo -----------------------------
echo parsing json for taxonomy information
parse_json.py $out_file.blobDB.json | sed 's/NODE_//'| sort -n | sed 's/^/NODE_/' > $out_file.parsed_json.txt
echo process complete, output saved to $out_file.parsed_json.txt

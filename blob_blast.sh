#1/bin/bash
#Author: Joseph Sevigny
#Purpose: Generic blast for blobtools create json command.


blast_flavor=megablast
database_path=/home/genome/kdiaz/databases/nt
outname=$(basename $1)

blastn \
-task $blast_flavor \
-query $1 \
-db $database_path \
-outfmt '6 qseqid staxids bitscore std sscinames sskingdoms stitle' \
-culling_limit 5 \
-num_threads 48 \
-evalue 1e-25 \
-out $outname.vs.nt.cul5.1e25.megablast.out

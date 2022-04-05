#!/bin/bash
#SBATCH -c 4                              # Request one core
#SBATCH -t 0-05:00                         # Runtime in D-HH:MM format
#SBATCH -p short                           # Partition to run in
#SBATCH --mem=8000M                         # Memory total in MB (for all cores)
#SBATCH -o log/ascat_cgpwgs_%j.out                 # File to which STDOUT will be written, including job ID (%j)
#SBATCH -e log/ascat_cgpwgs_%j.err                 # File to which STDERR will be written, including job ID (%j)
                                           # You can change the filenames given with -o and -e to any filenames you'd like



# make a sample folder
TUMOR_ID=SRR7890905
TUMOR_BAM=SRR7890905_GAPFI2USVS21.bam
NORMAL_BAM=SRR7890943_GAPFI14IJOX2.bam



RESULT_SCRATCH_FOLDER=/n/scratch3/users/d/dg204/ascat_results
OUT_PATH=${RESULT_SCRATCH_FOLDER}/${TUMOR_ID}/
mkdir -p $OUT_PATH

BAM_FOLDER=/n/data1/hms/dbmi/park/dglodzik/cellline
REF_FOLDER=/n/data1/hms/dbmi/park/dglodzik/ref
RESULT_END_FOLDER=/n/data1/hms/dbmi/park/dglodzik/cgpwgs/ascat/


singularity exec\
 --cleanenv \
 --workdir /home/dg204/cgpwgs_workspace \
 --home /home/dg204/cgpwgs_workspace:/home \
 --bind ${REF_FOLDER}:/var/spool/ref:ro \
 --bind ${BAM_FOLDER}:/var/spool/data \
 --bind ${RESULT_SCRATCH_FOLDER}:/var/spool/results \
/n/app/singularity/containers/dg204/cgpwgs.sif \
ascat.pl \
-outdir /var/spool/results/${TUMOR_ID}/ \
-tumour /var/spool/data/${TUMOR_BAM} \
-normal /var/spool/data/${NORMAL_BAM} \
-reference /var/spool/ref//core/core_ref_GRCh38_hla_decoy_ebv/genome.fa \
-snp_gc "/var/spool/ref/ascat/CNV_SV_ref_GRCh38_hla_decoy_ebv_brass6+/ascat/SnpGcCorrections.tsv" \
-protocol "WGS" \
-gender "XY" \
-genderChr "Y"

cp -r $OUT_PATH $RESULT_END_FOLDER


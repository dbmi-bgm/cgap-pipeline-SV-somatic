#!/bin/bash

WORKDIR="/usr/local/bin"

while [ "$1" != "" ]; do
    case $1 in
    --input_tumor_bam)
        shift
        input_tumor_bam=$1
        ;;
    --input_normal_bam)
        shift
        input_normal_bam=$1
        ;;
    --sex)
        shift
        sex=$1
        ;;
    --nthreads)
        shift
        nthreads=$1
        ;;
    --reference_data)
        shift
        reference_data=$1
        ;;
    esac
    shift
done

tar -xzf $reference_data

Rscript $WORKDIR/ascat.R --input_tumor_bam $input_tumor_bam --input_normal_bam $input_normal_bam --sex $sex --nthreads $nthreads || exit 1
gzip cnv_ascat.tsv || exit 1
gzip BAF_LogR_tumor_germline.tsv || exit 1

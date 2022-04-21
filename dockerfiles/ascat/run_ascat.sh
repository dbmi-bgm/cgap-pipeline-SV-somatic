#!/bin/bash

WORKDIR="/usr/local/bin"

while [ "$1" != "" ]; do
    case $1 in
    --tumour_file)
        shift
        tumour_file=$1
        ;;
    --normal_file)
        shift
        normal_file=$1
        ;;
    --gender)
        shift
        gender=$1
        ;;
    --tumour_name)
        shift
        tumour_name=$1
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

tar -xvf $reference_data $WORKDIR

Rscript ascat.R --tumour_file $tumour_file --normal_file $normal_file --gender $gender --tumour_name $tumour_name --nthreads $nthreads 


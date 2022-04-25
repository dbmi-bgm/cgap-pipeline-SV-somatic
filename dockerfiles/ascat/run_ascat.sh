#!/bin/bash

WORKDIR="/usr/local/bin"

while [ "$1" != "" ]; do
    case $1 in
    --tumor_file)
        shift
        tumor_file=$1
        ;;
    --normal_file)
        shift
        normal_file=$1
        ;;
    --gender)
        shift
        gender=$1
        ;;
    --tumor_name)
        shift
        tumor_name=$1
        ;;
    --normal_name)
        shift
        normal_name=$1
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

tar -xzvf $reference_data -C $WORKDIR --strip-components=1

Rscript ascat.R --tumor_file $tumor_file --normal_file $normal_file --gender $gender --tumor_name $tumor_name --normal_name $normal_name --nthreads $nthreads || exit 1
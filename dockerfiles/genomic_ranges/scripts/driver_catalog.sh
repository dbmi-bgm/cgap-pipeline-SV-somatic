#!/bin/bash

WORKDIR="/usr/local/bin"

while [ "$1" != "" ]; do
    case $1 in
    --ascat)
        shift
        ascat=$1
        ;;
    --gene_panel)
        shift
        gene_panel=$1
        ;;
    --cgap_genes)
        shift
        cgap_genes=$1
        ;;
    --ascat_objects)
        shift
        ascat_objects=$1
        ;;
    --output)
        shift
        output=$1
        ;;
    esac
    shift
done


Rscript $WORKDIR/postprocess_ascat.R --ascat $ascat --ascat_objects $ascat_objects --gene_panel $gene_panel --cgap_genes $cgap_genes --output $output || exit 1
gzip $output  || exit 1

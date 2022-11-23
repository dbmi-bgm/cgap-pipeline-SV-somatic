#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/genomic_ranges:VERSION

baseCommand: [driver_catalog.sh]

inputs:
  - id: ascat
    type: File
    inputBinding:
        prefix: "--ascat"
    doc: TODO

  - id: gene_panel
    type: File
    inputBinding:
        prefix: "--gene_panel"
    doc: TODO
  - id: cgap_genes
    type: File
    inputBinding:
        prefix: "--cgap_genes"
    doc: TODO

  - id: ascat_objects
    type: File
    inputBinding:
        prefix: "--ascat_objects"
    doc: TODO
    
  - id: output
    type: string
    inputBinding:
        prefix: "--output"
    default: putative_drivers_CNV_ASCAT.tsv
    doc: TODO



outputs:
  - id: putative_drivers
    type: File
    outputBinding:
      glob: putative_drivers_CNV_ASCAT.tsv.gz


doc: |
  run driver_catalog.sh
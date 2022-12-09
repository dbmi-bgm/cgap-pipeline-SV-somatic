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
    doc: tsv file containing ASCAT CNVs

  - id: gene_panel
    type: File
    inputBinding:
        prefix: "--gene_panel"
    doc: tsv configuration file of which genes to add to the driver catalog from Hartwig Medical Foundation
  - id: cgap_genes
    type: File
    inputBinding:
        prefix: "--cgap_genes"
    doc: tsv file of genes available on CGAP

  - id: ascat_objects
    type: File
    inputBinding:
        prefix: "--ascat_objects"
    doc: ascat objects from the CGAP SV somatic pipeline (ASCAT)

  - id: output
    type: string
    inputBinding:
        prefix: "--output"
    default: putative_drivers_CNV_ASCAT.tsv
    doc: output file name

outputs:
  - id: putative_drivers_tsv
    type: File
    outputBinding:
      glob: $(inputs.output).gz
    doc: tsv file containing reported putative drivers

doc: |
  run driver_catalog.sh
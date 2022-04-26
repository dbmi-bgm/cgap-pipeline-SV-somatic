#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ascat:1.0.0

baseCommand: [run_ascat.sh]

inputs:
  - id: tumor_file
    type: File
    inputBinding:
      prefix: "--tumor_file"
    doc: tumor sample BAM file

  - id: normal_file
    type: File
    inputBinding:
      prefix: "--normal_file"
    doc: normal sample BAM file

  - id: gender
    type: string
    inputBinding:
        prefix: "--gender"
    doc: gender

  - id: nthreads
    type: int
    default: 23
    inputBinding:
      prefix: "--nthreads"
    doc: number of threads used to run parallel
  
  - id: reference_data
    type: string
    inputBinding:
      prefix: "--reference_data"
    doc: tar file with loci, alleles and GC correction files

outputs:
  - id: tumor_baf
    type: File
    outputBinding:
      glob: Tumor_BAF.txt
  - id: tumor_logr
    type: File 
    outputBinding: 
      glob: After_correction_tumor.germline.png 

doc: |
  run run_ascat.sh
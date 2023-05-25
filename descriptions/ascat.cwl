#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/ascat:VERSION

baseCommand: [run_ascat.sh]

inputs:
  - id: input_tumor_bam
    type: File
    inputBinding:
      prefix: "--input_tumor_bam"
    secondaryFiles:
      - .bai
    doc: tumor sample BAM file

  - id: input_normal_bam
    type: File
    inputBinding:
      prefix: "--input_normal_bam"
    secondaryFiles:
      - .bai
    doc: normal sample BAM file

  - id: gender
    type: string
    inputBinding:
        prefix: "--gender"
    doc: Gender. Possible values: XX, F, XY, M

  - id: nthreads
    type: int
    default: 23
    inputBinding:
      prefix: "--nthreads"
    doc: number of threads used to run ascat
  
  - id: reference_data
    type: File
    inputBinding:
      prefix: "--reference_data"
    doc: tar file of loci, alleles and GC correction files

outputs:
  - id: BAF_LogR_tumor_germline
    type: File
    outputBinding:
      glob: BAF_LogR_tumor_germline.tsv.gz
  - id: after_correction_tumor_germline
    type: File
    outputBinding:
      glob: After_correction_tumor.germline.png
  - id: after_correction_tumor_tumour
    type: File
    outputBinding:
      glob: After_correction_tumor.tumour.png
  - id: before_correction_tumor_tumour
    type: File
    outputBinding:
      glob: Before_correction_tumor.tumour.png
  - id: tumor_ASCATprofile
    type: File
    outputBinding:
      glob: tumor.ASCATprofile.png
  - id: tumor_ASPCF
    type: File
    outputBinding:
      glob: tumor.ASPCF.png
  - id: tumor_rawprofile
    type: File
    outputBinding:
      glob: tumor.rawprofile.png
  - id: tumor_sunrise
    type: File
    outputBinding: 
      glob: tumor.sunrise.png
  - id: cnv_ascat
    type: File 
    outputBinding: 
      glob: cnv_ascat.tsv.gz
  - id: ascat_objects
    type: File 
    outputBinding: 
      glob: ascat_objects.Rdata

doc: |
  run run_ascat.sh

cwlVersion: v1.0

class: Workflow

requirements:
  MultipleInputFeatureRequirement: {}

inputs:
  - id: tumor_file
    type: File
    secondaryFiles:
      - .bai
    doc: tumor sample BAM file

  - id: normal_file
    type: File
    secondaryFiles:
      - .bai
    doc: normal sample BAM file

  - id: gender
    type: string
    doc: lgender

  - id: nthreads
    type: int
    default: true
    doc: number of threads used to run parallel

  - id: reference_data
    type: File
    doc: tar file of loci, alleles and GC correction files

outputs:
  - id: BAF_LogR_tumor_germline
    type: File
    outputSource: ascat/BAF_LogR_tumor_germline
  - id: cnv_ascat
    type: File
    outputSource: ascat/cnv_ascat
  - id: after_correction_tumor_germline
    type: File
    outputSource: ascat/after_correction_tumor_germline
  - id: after_correction_tumor_tumor
    type: File
    outputSource: ascat/after_correction_tumor_tumor
  - id: before_correction_tumor_tumour
    type: File
    outputSource: ascat/before_correction_tumor_tumour
  - id: tumor_ASCATprofile
    type: File
    outputSource: ascat/tumor_ASCATprofile
  - id: tumor_ASPCF
    type: File
    outputSource: ascat/tumor_ASPCF
  - id: tumor_rawprofile
    type: File
    outputSource: ascat/tumor_rawprofile
  - id: tumor_sunrise
    type: File
    outputSource: ascat/tumor_sunrise
  - id: ascat_objects
    type: File
    outputSource: ascat/ascat_objects

steps:
  ascat:
    run: ascat.cwl
    in:
      tumor_file:
        source: tumor_file
      normal_file:
        source: normal_file
      gender:
        source: gender
      nthreads:
        source: nthreads
      reference_data:
        source: reference_data
    out: [BAF_LogR_tumor_germline, tumor_sunrise, tumor_rawprofile, cnv_ascat,tumor_ASPCF, before_correction_tumor_tumour, tumor_ASCATprofile, after_correction_tumor_germline, after_correction_tumor_tumor, ascat_objects]

doc: run run_ascat.sh

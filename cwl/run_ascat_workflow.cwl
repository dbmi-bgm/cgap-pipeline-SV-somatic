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
    type: string
    doc: tar file with loci, alleles and GC correction files

outputs:
  - id: tumor_baf
    type: File
  - id: tumor_logr
    type: File

steps:
  run_ascat:
    run: run_ascat.cwl
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
    out: [tumor_baf, tumor_logr]

doc: run run_ascat.sh
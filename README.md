<img src="https://github.com/dbmi-bgm/cgap-pipeline/blob/master/docs/images/cgap_logo.png" width="200" align="right">

# CGAP Pipeline for Somatic Structural Variants

This repository contains components for the CGAP pipeline for Structural Variants (SVs) in somatic data:

  * CWL workflow descriptions
  * CGAP Portal *Workflow* and *MetaWorkflow* objects
  * CGAP Portal *Software*, *FileFormat*, and *FileReference* objects
  * ECR (Docker) source files, which allow for creation of public Docker images (using `docker build`) or private dynamically-generated ECR images (using [*portal pipeline utils*](https://github.com/dbmi-bgm/portal-pipeline-utils/) `pipeline_deploy`)

The pipeline starts from analysis-ready `bam` files and produces `vcf` files containing calls for SVs as output.
Documentation for all CGAP Pipelines can now be found here:
https://cgap-pipeline-main.readthedocs.io/en/latest/

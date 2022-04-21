library(optparse)

GENOME_VERSION <- "hg38"

tumourLogR_file_name <- "Tumor_LogR.txt"
tumourBAF_file_name <- "Tumor_BAF.txt"
normalLogR_file_name <- "Germline_LogR.txt"
normalBAF_file_name <- "Germline_BAF.txt"
GcCorrections_file_name <- "GC_G1000_hg38.txt"

option_list <- list(
  make_option(
    c("--tumour_file"),
    action = "store",
    type = "character",
    help = "Tumour sample in BAM"
  ),
  
  make_option(
    c("--normal_file"),
    action = "store",
    type = "character",
    help = "Normal sample in BAM"
  ),
  
  make_option(
    c("--gender"),
    type = "character",
    action = "store",
    help = "Gender"
  ),
  
  make_option(
    c("--tumour_name"),
    action = "store",
    type = "character",
    help = "Tumour sample name"
  ),
  
  make_option(
    c("--normal_name"),
    action = "store",
    type = "character",
    help = "Normal sample name"
  ),
  
  
  make_option(
    c("--nthreads"),
    type = "integer",
    help = "Number of threads",
    default = 23
    
  )
)


REQUIRED_PARAMS <-
  c("tumour_file",
    "normal_file",
    "gender",
    "normal_name",
    "tumour_name")

opt = parse_args(OptionParser(option_list = option_list))

if (is.null(opt$tumour_file) |
    is.null(opt$normal_file) | is.null(opt$gender)) {
  stop(paste(
    c("Specify all required parameters: ", REQUIRED_PARAMS),
    collapse = " "
  ))
  
}

if (!(opt$gender %in%  c("XX", "XY"))) {
  stop("Provide correct gender: XY or XX")
}

library(ASCAT)

ascat.prepareHTS(
  tumourseqfile = opt$tumour_file,
  normalseqfile = opt$normal_file,
  tumourname = opt$tumour_name,
  normalname = opt$normal_name,
  allelecounter_exe = "/miniconda3/bin/alleleCounter",
  alleles.prefix = "G1000_alleles_hg38_chr",
  loci.prefix = "G1000_loci_hg38_chr",
  gender = opt$gender,
  genomeVersion = GENOME_VERSION,
  nthreads = opt$threads,
  tumourLogR_file = tumourLogR_file_name,
  tumourBAF_file = tumourBAF_file_name ,
  normalLogR_file = normalLogR_file_name,
  normalBAF_file = normalBAF_file_name
)


ascat.bc <- ascat.loadData(
  Tumor_LogR_file = tumourLogR_file_name,
  Tumor_BAF_file = tumourBAF_file_name ,
  Germline_LogR_file = normalLogR_file_name,
  Germline_BAF_file = normalBAF_file_name,
  genomeVersion = GENOME_VERSION
)
ascat.plotRawData(ascat.bc, img.prefix = "Before_correction_")
ascat.bc <-
  ascat.correctLogR(ascat.bc, GCcontentfile = GcCorrections_file_name)
ascat.plotRawData(ascat.bc, img.prefix = "After_correction_")
ascat.bc <- ascat.aspcf(ascat.bc)
ascat.plotSegmentedData(ascat.bc)
ascat.output <- ascat.runAscat(ascat.bc)
QC <- ascat.metrics(ascat.bc, ascat.output)

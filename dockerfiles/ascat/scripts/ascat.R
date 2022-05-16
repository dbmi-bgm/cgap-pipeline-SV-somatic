library(optparse)

GENOME_VERSION <- "hg38"

tumorLogR_file_name <- "Tumor_LogR.txt"
tumorBAF_file_name <- "Tumor_BAF.txt"
normalLogR_file_name <- "Germline_LogR.txt"
normalBAF_file_name <- "Germline_BAF.txt"
GcCorrections_file_name <- "GC_G1000_hg38.txt"
ascat_objects_file_name <- "ascat_objects.Rdata"
tumor_name  <- "tumor"
normal_name <- "normal"

cnv_filename <- "cnv_ascat.tsv"
measures_file_name <- "BAF_LogR_tumor_germline.tsv"

option_list <- list(
  make_option(
    c("--tumor_file"),
    action = "store",
    type = "character",
    help = "Tumor sample in BAM"
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
    c("--nthreads"),
    type = "integer",
    help = "Number of threads",
    default = 23
    
  )
)


REQUIRED_PARAMS <-
  c("tumor_file",
    "normal_file",
    "gender")

opt = parse_args(OptionParser(option_list = option_list))

if (is.null(opt$tumor_file) |
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
library(tidyverse)
library(tidyr)

ascat.prepareHTS(
  tumourseqfile = opt$tumor_file,
  normalseqfile = opt$normal_file,
  tumourname = tumor_name,
  normalname = normal_name,
  allelecounter_exe = "/miniconda3/bin/alleleCounter",
  alleles.prefix = "G1000_alleles_hg38_chr",
  loci.prefix = "G1000_loci_hg38_chr",
  gender = opt$gender,
  genomeVersion = GENOME_VERSION,
  nthreads = opt$threads,
  tumourLogR_file = tumorLogR_file_name,
  tumourBAF_file = tumorBAF_file_name ,
  normalLogR_file = normalLogR_file_name,
  normalBAF_file = normalBAF_file_name
)


ascat.bc <- ascat.loadData(
  Tumor_LogR_file = tumorLogR_file_name,
  Tumor_BAF_file = tumorBAF_file_name ,
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

save(ascat.output, ascat.bc, QC, file = ascat_objects_file_name)

ascat.output$segments$copyNumber <-  ascat.output$segments$nMajor + ascat.output$segments$nMinor
output_segments <- subset(ascat.output$segments, select = -c(sample))
write.table(output_segments, file=cnv_filename, sep="\t", quote=F, row.names=F, col.names=T)

id <- "chrom_pos"
ascat.bc$Germline_LogR[, id] <- rownames(ascat.bc$Germline_LogR)
ascat.bc$Germline_LogR <- ascat.bc$Germline_LogR[,c(id, "tumor")]
colnames(ascat.bc$Germline_LogR) <- c(id, "germline_LogR")


ascat.bc$Germline_BAF[, id] <- rownames(ascat.bc$Germline_BAF)
colnames(ascat.bc$Germline_BAF) <- c("germline_BAF", id)

ascat.bc$Tumor_LogR[, id] <- rownames(ascat.bc$Tumor_LogR)
colnames(ascat.bc$Tumor_LogR) <- c("tumor_LogR", id)


ascat.bc$Tumor_BAF[, id] <- rownames(ascat.bc$Tumor_BAF)
colnames(ascat.bc$Tumor_BAF) <- c("tumor_BAF", id)


tumor_BAF_segmented <- as.data.frame(ascat.bc$Tumor_BAF_segmented[[1]])
tumor_BAF_segmented[, id] <- rownames(tumor_BAF_segmented)
colnames(tumor_BAF_segmented) <- c("tumor_BAF_segmented", id)

tumor_LogR_segmented <- as.data.frame(ascat.bc$Tumor_LogR_segmented)
tumor_LogR_segmented[, id] <- rownames(tumor_LogR_segmented)
colnames(tumor_LogR_segmented) <- c("tumor_LogR_segmented", id)

measures_list <- list(ascat.bc$Germline_LogR, ascat.bc$Germline_BAF , ascat.bc$Tumor_LogR, ascat.bc$Tumor_BAF, tumor_LogR_segmented, tumor_BAF_segmented)
measures_df <- measures_list %>% reduce(full_join, by=id) %>% separate(chrom_pos, c('Chrom', 'Pos'))
write.table(measures_df, file=measures_file_name, sep="\t", quote=F, row.names=F, col.names=T)

library(GenomicRanges)
library(dplyr)
library(tidyverse)
library(optparse)

option_list <- list(
  make_option(
    c("--ascat"),
    action = "store",
    type = "character",
    help = "tsv file containing ASCAT CNVs"
  ),
  
  make_option(
    c("--gene_panel"),
    action = "store",
    type = "character",
    help = "tsv configuration file of which genes to add to the driver catalog from Hartwig Medical Foundation"
  ),
  
  make_option(
    c("--cgap_genes"),
    type = "character",
    action = "store",
    help = "tsv file containing genes supported by CGAP"
  ),

  make_option(
    c("--output"),
    type = "character",
    action = "store",
    help = "tsv file containing reported putative drivers"
  ),

  make_option(
    c("--ascat_objects"),
    type = "character",
    action = "store",
    help = "ascat objects from the CGAP SV somatic pipeline (ASCAT) (Rdata format)"
  )
)

opt = parse_args(OptionParser(option_list = option_list))
# loading ascat results
ascat_table <-
  read.table(
    gzfile(opt$ascat),
    header = TRUE,
    sep = '\t'
  )


#loading gene panel from Hartwig
driver_gene_panel <-
  read.table(gzfile(opt$gene_panel),
             header = TRUE,
             sep = '\t')

# create cnvs genomic ranges obj
ascat.gr <- GRanges(
  seqnames = Rle(paste0('chr', ascat_table$chr)),
  ranges = IRanges(ascat_table$startpos, ascat_table$endpos),
  strand = rep(c("*"), nrow(ascat_table))
)

ascat.gr$total.cn <- ascat_table$copyNumber
ascat.gr$minor.cn <- ascat_table$nMinor
ascat.gr$major.cn <- ascat_table$nMajor

#genes from CGAP
gene_table <- read.table(gzfile(opt$cgap_genes),
                         sep = '\t',
                         header = TRUE)

# create genes genomic ranges obj
genes.gr <- GRanges(
  seqnames = Rle(paste0('chr', gene_table$chr)),
  ranges = IRanges(gene_table$start,  gene_table$end),
  strand = gene_table$strand
)


#finding overlaps 
overlap.df <- as.data.frame(findOverlaps(genes.gr, ascat.gr))


gene_table$ID_gene <- seq.int(nrow(gene_table))
ascat_table$ID_cv <- seq.int(nrow(ascat_table))


overlap.df <- overlap.df %>%
  rename(ID_gene = queryHits,
         ID_cv = subjectHits)


# left join :  overlaps with ascat table by ID_cv to to find  copy numbers in each region
overlap.df <-
  merge(x = overlap.df,
        y = ascat_table,
        by = "ID_cv",
        all.x = TRUE)



# group by ID_gene to check what is the minimum and maximum value of cnvs in each gene 
grouped <- overlap.df %>% group_by(ID_gene)  %>%
  summarise(max_subjectHits = max(copyNumber),
            min_subjectHits = min(copyNumber))


# inner join with genes from CGAP to find names of the genes, ID gene stores only index
final <-
  merge(x = gene_table, y = grouped, by = "ID_gene") # we have genes that we found some CNVs in


# merge with panel by gene symbol to query the decision tree 
final <-
  merge(x = final, y = driver_gene_panel, by = 'gene') #merges only common genes


#loading ascat objects to check ploidy 
load(opt$ascat_objects)
ploidy <- ascat.output$ploidy
check_ploidy <- 3 * ploidy


# for each gene we check if there is amplification and if we should report it
final$amplification <-
  ifelse((
    final$min_subjectHits > check_ploidy &
      final$reportAmplification == 'TRUE'
  ),
  TRUE,
  FALSE
  )


final$partial_amplification <-
  ifelse((
    final$max_subjectHits > check_ploidy &
      final$reportAmplification == 'TRUE'
  ),
  TRUE,
  FALSE
  )

final$deletion <-
  ifelse(final$min_subjectHits < 0.5 &
           final$reportDeletion == 'TRUE',
         TRUE,
         FALSE)


#select only relevant fields
final <-
  final %>% select(
    gene,
    chr,
    start,
    end,
    max_subjectHits,
    min_subjectHits,
    amplification,
    partial_amplification,
    deletion,
  ) %>% filter(amplification==TRUE | partial_amplification==TRUE | deletion==TRUE)

final$category[final$amplification == TRUE | final$partial_amplification == TRUE ] <- "amplification"
final$category[final$deletion==TRUE] <- "deletion"

final <- final %>% select(gene,
                 chr,
                 start,
                 end,
                 category) %>% rename(chrom = chr) #rename it for GosCan

write.table(final, file=opt$output, sep='\t',row.names = FALSE, quote=FALSE)
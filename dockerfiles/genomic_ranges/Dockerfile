#######################################################################
#     Basic image
#######################################################################
FROM cgap/cgap-ubuntu2004-py-38:0.0.1
MAINTAINER Michele Berselli (berselli.michele@gmail.com), Dominika Maziec (dominika_maziec@hms.harvard.edu)

#######################################################################
#     General updates & installing necessary Linux components
#       - tabix brings in bgzip and tabix
#       - locales for UTF-8
#######################################################################
RUN apt-get update && apt-get install -y \
    locales \
    tabix 
#######################################################################
#     Software
#######################################################################
## Install R
RUN apt-get install -y --no-install-recommends r-base
RUN apt-get install -y --no-install-recommends r-cran-tidyverse r-cran-optparse r-cran-biocmanager

## Install GenomicRanges
RUN R -e "BiocManager::install('GenomicRanges')"

#######################################################################
#     Setting working env
#######################################################################
WORKDIR /usr/local/bin

#######################################################################
#     Scripts
#######################################################################
COPY scripts/driver_catalog.sh .
RUN chmod +x driver_catalog.sh

COPY scripts/postprocess_ascat.R .

#######################################################################
#     Setting env variables
#######################################################################
## Supporting UTF-8
RUN locale-gen "en_US.UTF-8" && update-locale LC_ALL="en_US.UTF-8"
ENV LC_ALL=en_US.UTF-8

CMD ["bash"]

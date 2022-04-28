#######################################################################
#     Basic image
#######################################################################
FROM cgap/cgap-ubuntu2004-py-38:0.0.1
MAINTAINER Phil Grayson (phil.d.grayson@gmail.com), Michele Berselli (berselli.michele@gmail.com), Dominika Maziec (dominika_maziec@hms.harvard.edu)

#######################################################################
#     General updates & installing necessary Linux components
#       - tabix brings in bgzip and tabix
#       - locales for UTF-8
#######################################################################
RUN apt-get update && apt-get install -y \
    locales \
    tabix 

#######################################################################
#     Setting working env
#######################################################################
WORKDIR /usr/local/bin


## Ascat and R
RUN conda install -c bioconda -y r-base==4.1.0 ascat==3.0.0 cancerit-allelecount==4.3.0  && \
    conda clean -a -y -f

## other R packages
RUN R -e "install.packages('optparse', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('tidyverse', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('tibble', repos='http://cran.rstudio.com/')"

COPY run_ascat.sh .
RUN chmod +x run_ascat.sh

COPY scripts/ascat.R .

## Supporting UTF-8
RUN locale-gen "en_US.UTF-8" && update-locale LC_ALL="en_US.UTF-8"
ENV LC_ALL=en_US.UTF-8

CMD ["bash"]
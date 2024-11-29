FROM ghcr.io/lescailab/rstudio-tensorflow:1.0.0

# need JAVA for some R packages
RUN apt-get update && apt-get install default-jdk -y

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libxml2-dev \
    libcairo2-dev \
    libgit2-dev \
    default-libmysqlclient-dev \
    libpq-dev \
    libsasl2-dev \
    libsqlite3-dev \
    libssh2-1-dev \
    libxtst6 \
    libcurl4-openssl-dev \
    unixodbc-dev

# add CRAN repository to ubuntu
RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" | sudo tee /etc/apt/sources.list.d/r.list

# since it is not signed use the command to update apt-get
RUN apt-get update --allow-unauthenticated --allow-insecure-repositories

## now can re-install latest R
RUN echo Y | apt-get install r-base -y --allow-unauthenticated


RUN Rscript -e "install.packages(c(\
                            'ggstats', \
                            'GGally'\
							), dependencies =T)"


## install gsl-config needed for dependencies
RUN mkdir -p /tmp/downloaded_packages
WORKDIR /tmp/downloaded_packages
RUN wget https://ftp.gnu.org/gnu/gsl/gsl-2.7.tar.gz
RUN tar -xvzf gsl-2.7.tar.gz
WORKDIR /tmp/downloaded_packages/gsl-2.7
RUN ./configure
RUN make 
RUN make install
WORKDIR /

## INSTALL additional packages for the course
RUN Rscript -e "install.packages(c(\
							'tidyclust',\
							'kknn',\
							'vip',\
							'xgboost',\
							'glmnet',\
							'randomForest',\
							'ranger', \
							'ggfortify', \
							'ggbeeswarm', \
							'moderndive', \
							'dbscan', \
							'pheatmap', \
							'cowplot', \
							'gghighlight', \
							'MetBrewer', \
							'ggraph', \
							'vroom', \
                            'gert', \
							'stacks', \
                            'doParallel', \
							'future' \
							), dependencies =T)"
    
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/downloaded_packages							
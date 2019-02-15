FROM  unimi-teaching-base:0.1

#
# How to build
# docker build -t unimi-teaching-rnaseq .
#

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y pigz unzip libparallel-forkmanager-perl

WORKDIR /opt

RUN conda install -y -c bioconda \
                 fastqc=0.11.8 \
                 trimmomatic=0.38 \
                 samtools=1.9 \
                 star=2.6.1b &&\
    conda clean --all

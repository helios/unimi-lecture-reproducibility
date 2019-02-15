FROM ubuntu:18.04

LABEL author="Raoul Jean Pierre Bonnal"
LABEL maintainer="bonnal@ingm.org"

ENV TINI_VERSION="v0.18.0"
ENV MINICONDA_VERSION="3-4.5.4"
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH=/opt/conda/bin:$PATH
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get  update --fix-missing && \
    apt-get install -y \
            apt-utils \
            bzip2 \
            build-essential \
	    ca-certificates \
	    curl \
	    git \
	    wget \
	    procps \
	    uuid-runtime 

WORKDIR /opt

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda${MINICONDA_VERSION}-Linux-x86_64.sh -O miniconda.sh && \
    chmod ugo+x miniconda.sh

RUN ./miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN wget --quiet https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini -O /usr/bin/tini
RUN chmod +x /usr/bin/tini


SHELL ["/bin/bash", "-c","-l"]
RUN conda config --add channels defaults &&\
    conda config --add channels conda-forge &&\
    conda config --add channels bioconda

RUN conda install readline=7.0 &&\
    pip install pip==10.0.1 \
                boto3==1.7.50 \
                awscli==1.15.51

SHELL ["/bin/sh", "-c"]
RUN mkdir -p /mnt/home && \
    mkdir -p /run/shm

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
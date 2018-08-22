FROM jupyter/minimal-notebook:2bfbb7d17524
LABEL maintainer="William Hearn <william.hearn@canada.ca>"
LABEL site="https://jupyterhub.readthedocs.io/en/stable/"

ENV _VERSION="0.3.0"

ARG AZURE_ACCOUNT_NAME=jupyter
ENV ACCOUNT_NAME=${AZURE_ACCOUNT_NAME}

ARG AZURE_ACCOUNT_KEY
ENV ACCOUNT_KEY=${AZURE_ACCOUNT_KEY}

USER root

# apt-get and system utilities
RUN apt-get update && apt-get install -y \
    curl apt-transport-https debconf-utils \
    && rm -rf /var/lib/apt/lists/*

# Initial deps
RUN pip install ipystata \
                pandas \
                ipython

# Blobporter
RUN apt-get update && apt-get install -y curl \
                                         ghostscript && \
    curl -L https://github.com/Azure/blobporter/releases/download/v0.6.12/bp_linux.tar.gz -o /tmp/blobporter.tar.gz && \
    tar -xf /tmp/blobporter.tar.gz -C /tmp linux_amd64/blobporter && \
    mv /tmp/linux_amd64/blobporter /usr/local/bin/blobporter && \
    rm -rf /tmp/* && \
    chmod a+x /usr/local/bin/blobporter

RUN cd /usr/local/ && \
    blobporter -c stata -n stata15.tar -t blob-file && \
    tar -xpf stata15.tar && \
    rm stata15.tar

# Blobfuse
ENV BUILD_DEPS="uuid-dev \
                libgcrypt11-dev \
                golang-go \
                build-essential \
                zlib1g-dev \
                fuse \
                pkg-config \
                libfuse-dev \
                cmake "
RUN apt-get update \
    && apt-get install -y --no-install-recommends $BUILD_DEPS gnutls-dev \
                                                              libgnutls30 \
                                                              libcurl3-gnutls \
                                                              libcurl4-openssl-dev \
    && git clone https://github.com/Azure/azure-storage-fuse \
    && cd azure-storage-fuse \
    && ./build.sh \
    && mv build/blobfuse /usr/local/bin \
    && cd .. \
    && rm -rf azure-storage-fuse/ \
    && apt-get purge -y --auto-remove $BUILD_DEPS \
    && rm -rf /var/lib/apt/lists/*

COPY scripts/mnt-blobfuse.sh /usr/local/bin/

# Documentation
COPY conf/docs/ /home/$NB_USER/docs/

RUN chown -R $NB_USER:$NB_GID /home/$NB_USER/docs/

# Prettier graph export
#    sed -i 's/graph export "%s"/graphexportpdf %s/g' /opt/conda/lib/python3.6/site-packages/ipystata/ipystata_magic_batch.py

# custom MS repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# SQL Server drivers
RUN  apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql mssql-tools && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && \
    /bin/bash -c "source ~/.bashrc"

USER $NB_USER

ENV PATH=$PATH:/usr/local/stata15

# https://ideas.repec.org/c/boc/bocode/s457036.html
RUN stata ssc install graphexportpdf

# syntax highlighting
# RUN mkdir -p /opt/conda/lib/python3.6/site-packages/notebook/static/components/codemirror/mode/stata
# COPY conf/stata.js /opt/conda/lib/python3.6/site-packages/notebook/static/components/codemirror/mode/stata/

COPY files.py /etc/jupyter/

RUN ipython /etc/jupyter/files.py

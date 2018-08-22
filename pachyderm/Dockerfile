FROM jupyter/scipy-notebook:2bfbb7d17524
LABEL maintainer="William Hearn <william.hearn@canada.ca>"
LABEL site="https://jupyterhub.readthedocs.io/en/stable/"

USER root

# blobfuse
RUN apt-get update \
    && apt-get install -y --no-install-recommends uuid-dev libgcrypt11-dev golang-go build-essential zlib1g-dev fuse gnutls-dev libcurl3-gnutls libgnutls30 pkg-config libfuse-dev cmake libcurl4-openssl-dev \
    && git clone https://github.com/Azure/azure-storage-fuse \
    && cd azure-storage-fuse \
    && ./build.sh \
    && mv build/blobfuse /usr/local/bin \
    && cd .. \
    && rm -rf azure-storage-fuse/ \
    && rm -rf /var/lib/apt/lists/*

COPY scripts/mnt-blobfuse.sh /usr/local/bin/

USER $NB_USER

# Python extra packages
RUN conda install --quiet --yes -c conda-forge \
    'arrow-cpp=0.9.*' \
    'pyarrow=0.9.*' \
    numpy \
    pytables \
    readline && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR

# Pachyderm Client
RUN pip install python-pachyderm

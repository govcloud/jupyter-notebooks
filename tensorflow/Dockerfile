FROM jupyter/tensorflow-notebook:2bfbb7d17524
LABEL maintainer="William Hearn <william.hearn@canada.ca>"
LABEL site="https://jupyterhub.readthedocs.io/en/stable/"

User root

# Blobfuse
ENV BUILD_DEPS="uuid-dev \
                libgcrypt11-dev \
                golang-go \
                build-essential \
                zlib1g-dev \
                pkg-config \
                libfuse-dev \
                cmake"

RUN apt-get update \
    && apt-get install -y --no-install-recommends $BUILD_DEPS fuse \
                                                              gnutls-dev \
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

USER $NB_UID

# Python extra packages
RUN conda install --quiet --yes \
    psycopg2 && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

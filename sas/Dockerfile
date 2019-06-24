FROM jupyter/minimal-notebook:d4cbf2f80a2a
LABEL maintainer="William Hearn <william.hearn@canada.ca>"
LABEL site="https://jupyterhub.readthedocs.io/en/stable/"

USER root

RUN apt-get update && \
    apt-get install -y curl \
                       apt-transport-https \
                       debconf-utils \
                       libnuma-dev \
                       libmagic-dev \
                       libjpeg62 && \
    rm -rf /var/lib/apt/lists/*

# SASPY

ENV SASPY_VERSION="3.1.0"

RUN pip install sas_kernel \
                azure-storage \
                pandas && \
    mkdir /opt/sasinside/

COPY conf/sascfg.py /opt/conda/lib/python3.6/site-packages/saspy/sascfg.py
COPY conf/SASDeploymentManager/ /opt/sasinside/SASHome/SASDeploymentManager/

RUN chown -R $NB_USER:$NB_GID /opt/sasinside/

RUN jupyter nbextension install --py sas_kernel.showSASLog && \
    jupyter nbextension enable sas_kernel.showSASLog --py && \
    jupyter nbextension install --py sas_kernel.theme && \
    jupyter nbextension enable sas_kernel.theme --py && \
    jupyter nbextension list

# BLOB FUSE

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

COPY conf/docs/ /home/$NB_USER/docs/

RUN chown -R $NB_USER:$NB_GID /home/$NB_USER/docs/

# SQL Server

RUN apt-get update && \
    apt-get install -y gnupg && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2017.list > /etc/apt/sources.list.d/mssql-server.list

RUN apt-get update && \
    apt-get install -y libcurl3 && \
    ACCEPT_EULA=Y \
    apt-get install -y msodbcsql \
                       mssql-server \
                       mssql-tools && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && \
    /bin/bash -c "source ~/.bashrc"

# Startup

ENTRYPOINT ["tini", "-g", "--"]
CMD ["start-notebook.sh"]
COPY scripts/start-notebook.sh /usr/local/bin/
USER $NB_USER

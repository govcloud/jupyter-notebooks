
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements. See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership. The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied. See the License for the
# specific language governing permissions and limitations
# under the License.
#
FROM jupyter/minimal-notebook:2bfbb7d17524
LABEL maintainer="William Hearn <william.hearn@canada.ca>"
LABEL site="https://jupyterhub.readthedocs.io/en/stable/"

ENV _VERSION="0.3.0"

ARG AZURE_ACCOUNT_NAME=jupyter
ENV ACCOUNT_NAME=${AZURE_ACCOUNT_NAME}

ARG AZURE_ACCOUNT_KEY
ENV ACCOUNT_KEY=${AZURE_ACCOUNT_KEY}

USER root

RUN pip install ipystata \
                pandas \
                ipython

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

COPY conf/docs/ /home/$NB_USER/docs/

RUN chown -R $NB_USER:$NB_GID /home/$NB_USER/docs/
#    sed -i 's/graph export "%s"/graphexportpdf %s/g' /opt/conda/lib/python3.6/site-packages/ipystata/ipystata_magic_batch.py

USER $NB_USER

ENV PATH=$PATH:/usr/local/stata15

# https://ideas.repec.org/c/boc/bocode/s457036.html
RUN stata ssc install graphexportpdf

# syntax highlighting
# RUN mkdir -p /opt/conda/lib/python3.6/site-packages/notebook/static/components/codemirror/mode/stata

# COPY conf/stata.js /opt/conda/lib/python3.6/site-packages/notebook/static/components/codemirror/mode/stata/

COPY files.py /etc/jupyter/

RUN ipython /etc/jupyter/files.py

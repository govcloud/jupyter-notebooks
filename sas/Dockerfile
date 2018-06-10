
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

ENV SASPY_VERSION="2.2.4"

USER root

RUN pip install sas_kernel && \
    mkdir /opt/sasinside/

COPY conf/sascfg.py /opt/conda/lib/python3.6/site-packages/saspy/sascfg.py
COPY conf/SASDeploymentManager/ /opt/sasinside/SASHome/SASDeploymentManager/

RUN chown -R $NB_USER:$NB_GID /opt/sasinside/

RUN jupyter nbextension install --py sas_kernel.showSASLog && \
    jupyter nbextension enable sas_kernel.showSASLog --py && \
    jupyter nbextension install --py sas_kernel.theme && \
    jupyter nbextension enable sas_kernel.theme --py && \
    jupyter nbextension list

# java9 install
RUN apt-get update \
  && apt-get -y install software-properties-common python-software-properties \
  && add-apt-repository ppa:linuxuprising/java \
  && apt-get update && \
  echo oracle-java10-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
  && apt-get -y install oracle-java10-installer \
  && apt-get -y remove software-properties-common \
  && apt-get clean autoclean -y \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt \
    /var/lib/dpkg/arch \
    /var/lib/dpkg/available \
    /var/lib/dpkg/cmethopt \
    /var/lib/dpkg/diversions \
    /var/lib/dpkg/diversions-old \
    /var/lib/dpkg/lock \
    /var/lib/dpkg/parts \
    /var/lib/dpkg/statoverride \
    /var/lib/dpkg/status-old \
    /var/lib/dpkg/triggers \
    /var/lib/cache \
    /var/lib/log

USER $NB_USER

FROM jupyter/minimal-notebook:2bfbb7d17524
LABEL maintainer="William Hearn <william.hearn@canada.ca>"
LABEL site="https://jupyterhub.readthedocs.io/en/stable/"

ENV JUPYTER_SCALA_VERSION="0.4.2"
ENV SBT_VERSION="1.1.6"

USER root

RUN \
  apt-get update \
  && apt-get install -y software-properties-common \
                        python-software-properties \
                        curl \
                        openjdk-8-jdk \
  && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/openjdk-8
ENV PATH=${PATH}:${JAVA_HOME}/bin

RUN curl -sL --retry 5 "https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" \
  | gunzip \
  | tar -x -C "/tmp/" \
  && mv "/tmp/sbt" "/opt/sbt-${SBT_VERSION}" \
  && chmod +x "/opt/sbt-${SBT_VERSION}/bin/sbt"

ENV PATH=${PATH}:/opt/sbt-${SBT_VERSION}/bin/

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

USER $NB_USER

RUN curl -sL --retry 5 "https://github.com/jupyter-scala/jupyter-scala/archive/jupyter-scala-v${JUPYTER_SCALA_VERSION}.tar.gz" \
  | gunzip \
  | tar -x -C "/tmp/"

RUN cd "/tmp/jupyter-scala-jupyter-scala-v${JUPYTER_SCALA_VERSION}" && \
  /opt/sbt-${SBT_VERSION}/bin/sbt ++2.11.11 ++2.12.2 publishLocal \
  && cd /tmp/jupyter-scala-${JUPYTER_SCALA_VERSION}/ \
  && ./jupyter-scala --id scala_2_11 --name "Scala (2.11)" --force \
  && cd /tmp/jupyter-scala-${JUPYTER_SCALA_VERSION}/ \
  && sed -i 's/\(SCALA_VERSION=\)\([2-9]\.[0-9][0-9]*\.[0-9][0-9]*\)\(.*\)/\12.12.2\3/' jupyter-scala \
  && ./jupyter-scala --id scala_2_12 --name "Scala (2.12)" --force \
  && rm -r /tmp/jupyter-scala-${JUPYTER_SCALA_VERSION}/ \
  && rm -r /home/$NB_USER/.sbt/* \
  && rm -r /home/$NB_USER/.ivy2/* \
  && rm -r /home/$NB_USER/.ivy2/.sbt* \
  && rm -r /home/$NB_USER/.coursier/*

WORKDIR /home/$NB_USER/work

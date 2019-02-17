FROM openjdk:8u191-jdk-alpine3.9

ENV SBT_VERSION=1.2.8

RUN apk add --no-cache bash curl bc ca-certificates && \
    update-ca-certificates && \
    curl -fsL https://piccolo.link/sbt-$SBT_VERSION.tgz | tar xfz - -C /usr/local && \
    ln -s /usr/local/sbt/bin/* /usr/local/bin/ && \
    apk del curl

ENV SPARK_VERSION 2.4.0
ENV HADOOP_VERSION 2.7
ENV SPARK_HOME /usr/local/share/spark

ENV SPARK_NO_DAEMONIZE=true

# Find the fast mirror by:
# curl -s  http://www.apache.org/dyn/closer.cgi | grep -A3 suggest | grep strong

RUN set -xe && \
    cd tmp && \
    wget http://mirrors.ocf.berkeley.edu/apache/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar -zxvf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    rm *.tgz && \
    mkdir -p `dirname ${SPARK_HOME}` && \
    mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} ${SPARK_HOME}

ENV PATH=$PATH:${SPARK_HOME}/sbin:${SPARK_HOME}/bin

WORKDIR ${SPARK_HOME}

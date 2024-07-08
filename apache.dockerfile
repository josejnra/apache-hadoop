# Based on:
# https://github.com/apache/hadoop/blob/docker-hadoop-3/Dockerfile

FROM apache/hadoop-runner

ENV HADOOP_VERSION 3.4.0

ARG HADOOP_URL=https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz

WORKDIR /opt

RUN sudo rm -rf /opt/hadoop && curl -LSs -o hadoop.tar.gz $HADOOP_URL && tar zxf hadoop.tar.gz && rm hadoop.tar.gz && mv hadoop* hadoop && rm -rf /opt/hadoop/share/doc

WORKDIR /opt/hadoop

# ADD log4j.properties /opt/hadoop/etc/hadoop/log4j.properties

RUN sudo chown -R hadoop:users /opt/hadoop/etc/hadoop/*

ENV HADOOP_CONF_DIR /opt/hadoop/etc/hadoop

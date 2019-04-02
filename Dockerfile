FROM ubuntu:16.04

MAINTAINER Jose Nunes https://github.com/josejnra

# Install Java and other packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common \
    ssh \
    openssh-server \
    rsync && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean

# create ssh
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys && \
    ssh-keyscan -H localhost >> ~/.ssh/known_hosts

ADD hadoop-3.2.0.tar.gz /

# hadoop configs
COPY conf/*.xml /hadoop-3.2.0/etc/hadoop/
RUN echo "export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")" >> /hadoop-3.2.0/etc/hadoop/hadoop-env.sh

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH=$PATH:/hadoop-3.2.0/bin

# Hadoop env
ENV HDFS_NAMENODE_USER root
ENV HDFS_DATANODE_USER root
ENV HDFS_SECONDARYNAMENODE_USER root
ENV YARN_RESOURCEMANAGER_USER root
ENV YARN_NODEMANAGER_USER root

# script to start hadoop
COPY start.sh /start-hadoop.sh
RUN chmod +x /start-hadoop.sh

# expose various ports
EXPOSE 8088 50070 50075 50030 50060 9000

ENTRYPOINT /start-hadoop.sh

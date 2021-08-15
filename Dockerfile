FROM openjdk:11

ENV HADOOP_VERSION=3.3.1

WORKDIR /

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common \
                       ssh \
                       pdsh \
                       openssh-server \
                       rsync

# create ssh
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys && \
    ssh-keyscan -H localhost >> ~/.ssh/known_hosts

RUN wget https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar zxf hadoop-${HADOOP_VERSION}.tar.gz && \
    rm -r hadoop-${HADOOP_VERSION}.tar.gz

# set java version to hadoop env
RUN echo "export JAVA_HOME=$(echo $JAVA_HOME)" >> /hadoop-${HADOOP_VERSION}/etc/hadoop/hadoop-env.sh

ENV PATH=$PATH:/hadoop-${HADOOP_VERSION}/bin

# Hadoop env
ENV HDFS_NAMENODE_USER root
ENV HDFS_DATANODE_USER root
ENV HDFS_SECONDARYNAMENODE_USER root
ENV YARN_RESOURCEMANAGER_USER root
ENV YARN_NODEMANAGER_USER root

# expose multiple ports
EXPOSE 9871 9870 9869 9868 9867 9866 9865 9864 9820 9000 8088

ENTRYPOINT ["/bin/bash"]

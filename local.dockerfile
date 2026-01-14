FROM eclipse-temurin:21-jdk-noble

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common \
                       ssh \
                       pdsh \
                       openssh-server \
                       rsync \
                       net-tools \
                       vim

ENV HADOOP_VERSION 3.4.2

WORKDIR /home/hadoop

# Generate SSH host keys at build time (as root)
RUN ssh-keygen -A && \
    mkdir -p /etc/ssh/keys && \
    cp /etc/ssh/ssh_host_* /etc/ssh/keys/

# Create /run/sshd and set permissions before switching user
RUN mkdir -p /run/sshd && chmod 0755 /run/sshd

# create ssh keys for hadoop user
RUN useradd -rm -d /home/hadoop -s /bin/bash -g root -G sudo hadoop && \
    chown -R hadoop:root /home/hadoop && \
    su - hadoop -c "ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa" && \
    su - hadoop -c "cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys" && \
    su - hadoop -c "chmod 0600 ~/.ssh/authorized_keys"

USER hadoop

RUN wget https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar zxf hadoop-${HADOOP_VERSION}.tar.gz && \
    rm -r hadoop-${HADOOP_VERSION}.tar.gz

# set java version to hadoop env
RUN echo "export JAVA_HOME=$(echo $JAVA_HOME)" >> /home/hadoop/hadoop-${HADOOP_VERSION}/etc/hadoop/hadoop-env.sh

ENV PATH=$PATH:/home/hadoop/hadoop-${HADOOP_VERSION}/bin

# Hadoop env
ENV HDFS_NAMENODE_USER root
ENV HDFS_DATANODE_USER root
ENV HDFS_SECONDARYNAMENODE_USER root
ENV YARN_RESOURCEMANAGER_USER root
ENV YARN_NODEMANAGER_USER root
ENV HADOOP_HOME /home/hadoop/hadoop-${HADOOP_VERSION}

# Switch back to root for running services
USER root

# expose several ports
EXPOSE 9871 9870 9869 9868 9867 9866 9865 9864 9820 9000 8088

ENTRYPOINT ["/bin/bash"]

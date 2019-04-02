# start ssh service
service ssh start 

# Format the filesystem:
hdfs namenode -format

# Start NameNode daemon and DataNode daemon
/hadoop-3.2.0/sbin/start-dfs.sh

# Make the HDFS directories required to execute MapReduce jobs
hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/$(whoami)

# Copy the input files into the distributed filesystem
#bin/hdfs dfs -put etc/hadoop input

# Start ResourceManager daemon and NodeManager daemon
/hadoop-3.2.0/sbin/start-yarn.sh

bash

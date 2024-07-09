# Hadoop
Hadoop is a framework permitting the storage of large volumes of data on node systems. The Hadoop architecture  allows parallel processing of data using several components:

- Hadoop HDFS to store data across slave machines
- Hadoop YARN for resource management in the Hadoop cluster
- Hadoop MapReduce to process data in a distributed fashion
- Zookeeper to ensure synchronization across a cluster

<p align="center">
    <img src="images/hadoop-architecture.png" alt="Hadoop Architecture overview" />
</p>

## HDFS

The **Hadoop Distributed File System** (HDFS) is Hadoop’s storage layer. Housed on multiple servers, data is divided into blocks based on file size. These blocks are then randomly distributed and stored across slave machines. There are three components of the Hadoop Distributed File System:  

- NameNode (a.k.a. masternode): Contains metadata in RAM and disk
- Secondary NameNode: Contains a copy of NameNode’s metadata on disk
- Slave Node: Contains the actual data in the form of blocks

<p align="center">
    <img src="images/hadoop-architecture.png" alt="Hadoop Architecture overview" />
</p>

### NameNode
NameNode is the master server. In a non-high availability cluster, there can be only one NameNode. In a high availability cluster, there is a possibility of two NameNodes, and if there are two NameNodes there is no need for a secondary NameNode. 
NameNode holds metadata information on the various DataNodes, their locations, the size of each block, etc. It also helps to execute file system namespace operations, such as opening, closing, renaming files and directories.

### Secondary NameNode
The secondary NameNode server is responsible for maintaining a copy of the metadata in the disk. The main purpose of the secondary NameNode is to create a new NameNode in case of failure. In a high availability cluster, there are two NameNodes: active and standby. The secondary NameNode performs a similar function to the standby NameNode.


### Datanodes
Datanodes store and maintain the blocks. While there is only one namenode, there can be multiple datanodes, which are responsible for retrieving the blocks when requested by the namenode. Datanodes send the block reports to the namenode every 10 seconds; in this way, the namenode receives information about the datanodes stored in its RAM and disk.


## YARN
Hadoop YARN (**Yet Another Resource Negotiator**) is the cluster resource management layer of Hadoop and is responsible for resource allocation and job scheduling. Introduced in the Hadoop 2.0 version, YARN is the middle layer between HDFS and MapReduce in the Hadoop architecture. The elements of YARN include:

- ResourceManager (one per cluster)
- ApplicationMaster (one per application)
- NodeManagers (one per node)

<p align="center">
    <img src="images/yarn-architecture.gif" alt="YARN Architecture overview" />
</p>

### Resource Manager
Resource Manager manages the resource allocation in the cluster and is responsible for tracking how many resources are available in the cluster and each node manager’s contribution. It has two main components:

- Scheduler: Allocating resources to various running applications and scheduling resources based on the requirements of the application; it doesn’t monitor or track the status of the applications
- Application Manager: Accepting job submissions from the client or monitoring and restarting application masters in case of failure

### Application Master
Application Master manages the resource needs of individual applications and interacts with the scheduler to acquire the required resources. It connects with the node manager to execute and monitor tasks.

### Node Manager
Node Manager tracks running jobs and sends signals (or heartbeats) to the resource manager to relay the status of a node. It also monitors each container’s resource utilization.

### Container
Container houses a collection of resources like RAM, CPU, and network bandwidth. Allocations are based on what YARN has calculated for the resources. The container provides the rights to an application to use specific resource amounts.


### Steps to Running an application in YARN

1. Client submits an application to the ResourceManager
2. ResourceManager allocates a container
3. ApplicationMaster contacts the related NodeManager because it needs to use the containers
4. NodeManager launches the container 
5. Container executes the ApplicationMaster


YARN provides its core services via two types of long-running daemon: a resource manager (one per cluster) to manage the use of resources across the cluster, and node managers running on all the nodes in the cluster to launch and monitor containers. A container executes an application-specific process with a constrained set of resources (memory, CPU, and so on). Depending on how YARN is configured, a container may be a Unix process or a Linux cgroup.

<p align="center">
    <img src="images/yarn-application.png" alt="YARN application anatomy overview" />
</p>

## MapReduce
MapReduce is a framework conducting distributed and parallel processing of large volumes of data. Written using a number of programming languages, it has two main phases: Map Phase and Reduce Phase.

### Map Phase 
Map Phase stores data in the form of blocks. Data is read, processed and given a key-value pair in this phase. It is responsible for running a particular task on one or multiple splits or inputs.

### Reduce Phase
The reduce Phase receives the key-value pair from the map phase. The key-value pair is then aggregated into smaller sets and an output is produced. Processes such as shuffling and sorting occur in the reduce phase.

The mapper function handles the input data and runs a function on every input split (known as map tasks). There can be one or multiple map tasks based on the size of the file and the configuration setup. Data is then sorted, shuffled, and moved to the reduce phase, where a reduce function aggregates the data and provides the output.

### MapReduce Job Execution
- The input data is stored in the HDFS and read using an input format. 
- The file is split into multiple chunks based on the size of the file and the input format. 
- The default chunk size is 128 MB but can be customized. 
- The record reader reads the data from the input splits and forwards this information to the mapper. 
- The mapper breaks the records in every chunk into a list of data elements (or key-value pairs). 
- The combiner works on the intermediate data created by the map tasks and acts as a mini reducer to reduce the data. 
- The partitioner decides how many reduce tasks will be required to aggregate the data. 
- The data is then sorted and shuffled based on their key-value pairs and sent to the reduce function. 
- Based on the output format decided by the reduce function, the output data is then stored on the HDFS.


## References
- [HDFS default config](https://hadoop.apache.org/docs/r3.4.0/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml)
- [Hadoop CORE common default config](https://hadoop.apache.org/docs/r3.4.0/hadoop-project-dist/hadoop-common/core-default.xml)
- [MapReduce default config](https://hadoop.apache.org/docs/r3.4.0/hadoop-mapreduce-client/hadoop-mapreduce-client-core/mapred-default.xml)
- [YARN default config](https://hadoop.apache.org/docs/r3.4.0/hadoop-yarn/hadoop-yarn-common/yarn-default.xml)
- [Hadoop Architecture and Components Explained](https://www.simplilearn.com/tutorials/hadoop-tutorial/hadoop-architecture)
- [Hadoop Architecture](https://www.geeksforgeeks.org/hadoop-architecture/)
- [What Is Hadoop Yarn Architecture & It’s Components](https://www.upgrad.com/blog/what-is-hadoop-yarn-architecture-its-components/)
- [Chapter 4. YARN](https://www.oreilly.com/library/view/hadoop-the-definitive/9781491901687/ch04.html)

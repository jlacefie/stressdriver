Cassandra 2.1 Stress Driver
==========================

This simple shell script will execute all .yaml files included in the yamlfiles directory, giving one the ability to create a multi-table and workload stress load for Cassandra.
Output is logged in the logfiles directory.

# Configuration
To use this tool, create an add the desired .yaml files to the yaml file directory.
.yaml file instructions are documented here http://www.datastax.com/dev/blog/improved-cassandra-2-1-stress-tool-benchmark-any-schema and here http://www.datastax.com/documentation/cassandra/2.1/cassandra/tools/toolsCStress_t.html. There are also some sample .yaml files located here https://github.com/apache/cassandra/tree/trunk/tools.

# Execution
Once .yaml files have been added to the yamlfile directory, you will need to call the driver.sh command passing in the following options.
note: do not escape special characters when passing arguments to the driver.sh"
required options are
-d [nodes] ex. "123.12.1.1,123.12.1.2"
-o [ops] ex. "ops(insert=1)"

optional options are
-r [rate] (optional) ex. "-rate threads>=1 threads<=2"
-n [number of ops] (optional) ex. "n=1000"

These options are based on the Cassandra 2.1 stress options.
note: the stress driver tool currently only supports a subset of the Cassandra 2.1 stress options.

example: ./driver.sh -d "123.12.1.1,123.12.1.2" -r "-rate threads>=1 threads<=2" -o "ops(insert=1)" -n "n=1000000"

# Implementation
As stated, this is a simple shell script.  All it does is start a Cassandra stress process, in background, for each file contained in the yamlfiles directory.  Also, the pids for each background process are recorded in a file for cleanup and status report purposes.

# Stopping an Execution
To kill a current execution of the driver, and Cassandra stress operations, simply call the killdriver.sh shell script.

# Work in Progress
This project is a work in progress.  As stated not all stress options are supported today.  Also, as noted in CASSANDRA-8597, Cassandra stress is evolving as well.


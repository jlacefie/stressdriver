#!/bin/bash
#options available will pass cassandra stress syntax into cassandra stress
#required options are
#-d [nodes] ex. "123.12.1.1,123.12.1.2"
#current options are 
#-r [rate] (optional) ex. "-rate threads\>=1 threads\<=2"
#-o [ops] (optional) ex. "ops\(insert=1\)"
#-n (optional) ex. "n=1000"
nodes="localhost"
rate=""
ops=""
n=""

#validate number parameters and options
#TODO improve validation
if [[ $# -lt 1 ]];
then 
   echo "1 option is required providing a target node list, -d"
   echo "3 options are optional for stressdriver, -r (rate) -o (ops) -n (number of operations)"
   echo "please review the cassandra stress documentation for descriptions of how to use stressdriver's options"
   echo "driver <parameter> <options>"
   exit 1
fi

#TODO add help as an option

#validate and get options
while getopts ":o:r:n:d:" optname
do 
  case "$optname" in
        "r")
          rate=$OPTARG
          ;;
        "o")
          ops=$OPTARG
          ;;
        "n")
          n=$OPTARG
          ;;       
        "d")
          nodes=$OPTARG
          ;;
        "?")
          echo "Unknown option $OPTARG"
          exit 1
          ;;
        ":")
          echo "No argument value for option $OPTARG"
          exit 1
          ;;
        *)
        # Should not occur
          echo "Unknown error while processing options"
          exit 1
          ;;
  esac
done  

echo "starting stress tests for files in the yamlfiles directory"

for f in yamlfiles/*
do
  echo "starting cassandra-stress user profile=$f $ops $n -node $nodes $rate -log file=logfiles/${f##*/}.log"
  cassandra-stress user profile=$f $ops $n -node $nodes $rate -log file=logfiles/${f##*/}.log &  
done

echo "all stress tests have been started"
echo "now waiting for results"

#TODO check for errors and only state success if no errors
wait

echo "all tests completed successfully"

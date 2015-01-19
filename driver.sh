#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"

arg1="${1:-}"
FAIL=0

#options available will pass cassandra stress syntax into cassandra stress
#note: do not escape special characters when passing arguments to the driver.sh"
#required options are
#-d [nodes] ex. "123.12.1.1,123.12.1.2"
#-o [ops] ex. "ops(insert=1)"

#current options are 
#-r [rate] (optional) ex. "-rate threads>=1 threads<=2"
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
   echo "4 options are optional for stressdriver, -r (rate) -o (ops) -n (number of operations)"
   echo "please review the cassandra stress documentation for descriptions of how to use stressdriver's options"
   echo "driver <options>"
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
  echo "starting cassandra-stress user profile=$f $n $ops -node $nodes $rate -log file=logfiles/${f##*/}.log &"
  cassandra-stress user profile=$f $n $ops -node $nodes $rate -log file=logfiles/${f##*/}.log >> logfiles/${f##*/}.out &
done 

echo "all stress tests have been started"
echo "now waiting for results"

#TODO check for errors and only state success if no errors
for job in `jobs -p`
do
  echo $job
  wait $job || let "FAIL+=1"
done
 
echo $FAIL
 
if [ "$FAIL" == "0" ];
then
  echo "all tests completed successfully"
else
  echo "the following number of tests failed: ($FAIL)"
fi 


#!/usr/bin/env bash

kill $(ps aux | grep "cassandra-stress\|cassandra/stress.jar" | awk '{print $2}')

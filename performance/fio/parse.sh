#!/bin/bash

set -e

if [ -z $1 ];
then
        echo Require output file name
        exit 1
fi

RESULT=$1

READ_RAND_IOPS=`cat $RESULT | jq '.jobs[0].read.iops_mean'| xargs printf "%'3f" | cut -f1 -d.`
WRITE_RAND_IOPS=`cat $RESULT | jq '.jobs[1].write.iops_mean'| xargs printf "%'3f" | cut -f1 -d.`
READ_RAND_BW=`cat $RESULT | jq '.jobs[2].read.bw_mean'| xargs printf "%'3f" | cut -f1 -d.`" KiB/sec"
WRITE_RAND_BW=`cat $RESULT | jq '.jobs[3].write.bw_mean'| xargs printf "%'3f" | cut -f1 -d.`" KiB/sec"
READ_RAND_LAT=`cat $RESULT | jq '.jobs[4].read.lat_ns.mean'| xargs printf "%'3f" | cut -f1 -d.`" ns"
WRITE_RAND_LAT=`cat $RESULT | jq '.jobs[5].write.lat_ns.mean'| xargs printf "%'3f" | cut -f1 -d.`" ns"
READ_SEQ_IOPS=`cat $RESULT | jq '.jobs[6].read.iops_mean'| xargs printf "%'3f" | cut -f1 -d.`
WRITE_SEQ_IOPS=`cat $RESULT | jq '.jobs[7].write.iops_mean'| xargs printf "%'3f" | cut -f1 -d.`
READ_SEQ_BW=`cat $RESULT | jq '.jobs[8].read.bw_mean'| xargs printf "%'3f" | cut -f1 -d.`" KiB/sec"
WRITE_SEQ_BW=`cat $RESULT | jq '.jobs[9].write.bw_mean'| xargs printf "%'3f" | cut -f1 -d.`" KiB/sec"
READ_SEQ_LAT=`cat $RESULT | jq '.jobs[10].read.lat_ns.mean'| xargs printf "%'3f" | cut -f1 -d.`" ns"
WRITE_SEQ_LAT=`cat $RESULT | jq '.jobs[11].write.lat_ns.mean'| xargs printf "%'3f" | cut -f1 -d.`" ns"

echo =========================
echo = FIO Benchmark Summary =
echo =========================
echo "Random Read/Write"
echo "IOPS:             $READ_RAND_IOPS / $WRITE_RAND_IOPS"
echo "Bandwidth:        $READ_RAND_BW   / $WRITE_RAND_BW"
echo "Average Latency:  $READ_RAND_LAT  / $WRITE_RAND_LAT"
echo "Sequential Read/Write"
echo "IOPS:             $READ_SEQ_IOPS / $WRITE_SEQ_IOPS"
echo "Bandwidth:        $READ_SEQ_BW   / $WRITE_SEQ_BW"
echo "Average Latency:  $READ_SEQ_LAT  / $WRITE_SEQ_LAT"

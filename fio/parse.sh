#!/bin/bash

set -e

if [ -z $1 ];
then
        echo Require FIO output file name
        exit 1
fi

if [ -z $2 ];
then
        echo Require benchmark summary result file name
        exit 1
fi

OUTPUT=$1
RESULT=$2

READ_RAND_IOPS=`cat $OUTPUT | jq '.jobs[0].read.iops_mean'| xargs printf "%'3f" | cut -f1 -d.`
READ_RAND_IOPS_USR_CPU=`cat $OUTPUT | jq '.jobs[0].usr_cpu'| xargs printf "%'3f" | cut -f1 -d.`"%"
READ_RAND_IOPS_SYS_CPU=`cat $OUTPUT | jq '.jobs[0].sys_cpu'| xargs printf "%'3f" | cut -f1 -d.`"%"
WRITE_RAND_IOPS=`cat $OUTPUT | jq '.jobs[1].write.iops_mean'| xargs printf "%'3f" | cut -f1 -d.`
WRITE_RAND_IOPS_USR_CPU=`cat $OUTPUT | jq '.jobs[1].usr_cpu'| xargs printf "%'3f" | cut -f1 -d.`"%"
WRITE_RAND_IOPS_SYS_CPU=`cat $OUTPUT | jq '.jobs[1].sys_cpu'| xargs printf "%'3f" | cut -f1 -d.`"%"
READ_RAND_BW=`cat $OUTPUT | jq '.jobs[2].read.bw_mean'| xargs printf "%'3f" | cut -f1 -d.`" KiB/sec"
WRITE_RAND_BW=`cat $OUTPUT | jq '.jobs[3].write.bw_mean'| xargs printf "%'3f" | cut -f1 -d.`" KiB/sec"
READ_RAND_LAT=`cat $OUTPUT | jq '.jobs[4].read.lat_ns.mean'| xargs printf "%'3f" | cut -f1 -d.`" ns"
WRITE_RAND_LAT=`cat $OUTPUT | jq '.jobs[5].write.lat_ns.mean'| xargs printf "%'3f" | cut -f1 -d.`" ns"
READ_SEQ_IOPS=`cat $OUTPUT | jq '.jobs[6].read.iops_mean'| xargs printf "%'3f" | cut -f1 -d.`
READ_SEQ_IOPS_USR_CPU=`cat $OUTPUT | jq '.jobs[6].usr_cpu'| xargs printf "%'3f" | cut -f1 -d.`"%"
READ_SEQ_IOPS_SYS_CPU=`cat $OUTPUT | jq '.jobs[6].sys_cpu'| xargs printf "%'3f" | cut -f1 -d.`"%"
WRITE_SEQ_IOPS=`cat $OUTPUT | jq '.jobs[7].write.iops_mean'| xargs printf "%'3f" | cut -f1 -d.`
WRITE_SEQ_IOPS_USR_CPU=`cat $OUTPUT | jq '.jobs[7].usr_cpu'| xargs printf "%'3f" | cut -f1 -d.`"%"
WRITE_SEQ_IOPS_SYS_CPU=`cat $OUTPUT | jq '.jobs[7].sys_cpu'| xargs printf "%'3f" | cut -f1 -d.`"%"
READ_SEQ_BW=`cat $OUTPUT | jq '.jobs[8].read.bw_mean'| xargs printf "%'3f" | cut -f1 -d.`" KiB/sec"
WRITE_SEQ_BW=`cat $OUTPUT | jq '.jobs[9].write.bw_mean'| xargs printf "%'3f" | cut -f1 -d.`" KiB/sec"
READ_SEQ_LAT=`cat $OUTPUT | jq '.jobs[10].read.lat_ns.mean'| xargs printf "%'3f" | cut -f1 -d.`" ns"
WRITE_SEQ_LAT=`cat $OUTPUT | jq '.jobs[11].write.lat_ns.mean'| xargs printf "%'3f" | cut -f1 -d.`" ns"

echo "
=========================
= FIO Benchmark Summary =
=========================

Random Read/Write
IOPS:             $READ_RAND_IOPS  / $WRITE_RAND_IOPS
IOPS CPU(USR/SYS): ( $READ_RAND_IOPS_USR_CPU / $READ_RAND_IOPS_SYS_CPU ) \
/ ( $WRITE_RAND_IOPS_USR_CPU / $WRITE_RAND_IOPS_SYS_CPU )
Bandwidth:        $READ_RAND_BW   / $WRITE_RAND_BW
Average Latency:  $READ_RAND_LAT  / $WRITE_RAND_LAT

Sequential Read/Write
IOPS:             $READ_SEQ_IOPS / $WRITE_SEQ_IOPS
IOPS CPU(USR/SYS): ( $READ_SEQ_IOPS_USR_CPU / $READ_SEQ_IOPS_SYS_CPU ) \
/ ( $WRITE_SEQ_IOPS_USR_CPU / $WRITE_SEQ_IOPS_SYS_CPU )
Bandwidth:        $READ_SEQ_BW   / $WRITE_SEQ_BW
Average Latency:  $READ_SEQ_LAT  / $WRITE_SEQ_LAT
" > $RESULT
cat $RESULT

#!/bin/bash

set -e

if [ -z $1 ];
then
        echo Require FIO output prefix
        exit 1
fi

PREFIX=${1}
OUTPUT=${PREFIX}-benchmark.json
OUTPUT_CPU=${PREFIX}-cpu.json

if [ ! -f "$OUTPUT" ]; then
        echo "$OUTPUT doesn't exist"
        exit 1
fi

if [ ! -f "$OUTPUT_CPU" ]; then
        echo "$OUTPUT_CPU doesn't exist"
        exit 1
fi

RESULT=${1}.summary

READ_RAND_IOPS=`cat $OUTPUT | jq '.jobs[0].read.iops_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`
WRITE_RAND_IOPS=`cat $OUTPUT | jq '.jobs[1].write.iops_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`
READ_RAND_BW=`cat $OUTPUT | jq '.jobs[2].read.bw_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`" KiB/sec"
WRITE_RAND_BW=`cat $OUTPUT | jq '.jobs[3].write.bw_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`" KiB/sec"
READ_RAND_LAT=`cat $OUTPUT | jq '.jobs[4].read.lat_ns.mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`" ns"
WRITE_RAND_LAT=`cat $OUTPUT | jq '.jobs[5].write.lat_ns.mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`" ns"
READ_SEQ_IOPS=`cat $OUTPUT | jq '.jobs[6].read.iops_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`
WRITE_SEQ_IOPS=`cat $OUTPUT | jq '.jobs[7].write.iops_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`
READ_SEQ_BW=`cat $OUTPUT | jq '.jobs[8].read.bw_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`" KiB/sec"
WRITE_SEQ_BW=`cat $OUTPUT | jq '.jobs[9].write.bw_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`" KiB/sec"
READ_SEQ_LAT=`cat $OUTPUT | jq '.jobs[10].read.lat_ns.mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`" ns"
WRITE_SEQ_LAT=`cat $OUTPUT | jq '.jobs[11].write.lat_ns.mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`" ns"

CPU_IDLE_PCT=`cat $OUTPUT_CPU | jq '.cpu_idleness.system' | cut -f1 -d.`"%"

QUICK_MODE_TEXT="QUICK MODE: DISABLED"
if [ -n "$QUICK_MODE" ]; then
	QUICK_MODE_TEXT="QUICK MODE ENABLED"
fi

SIZE_TEXT="SIZE: 10g"
if [ -n "$SIZE" ]; then
	SIZE_TEXT="SIZE: $SIZE"
fi
echo "
=====================
FIO Benchmark Summary
For: $PREFIX
$SIZE_TEXT
$QUICK_MODE_TEXT
=====================

Random Read/Write
IOPS:             $READ_RAND_IOPS  / $WRITE_RAND_IOPS
Bandwidth:        $READ_RAND_BW   / $WRITE_RAND_BW
Average Latency:  $READ_RAND_LAT  / $WRITE_RAND_LAT

Sequential Read/Write
IOPS:             $READ_SEQ_IOPS / $WRITE_SEQ_IOPS
Bandwidth:        $READ_SEQ_BW   / $WRITE_SEQ_BW
Average Latency:  $READ_SEQ_LAT  / $WRITE_SEQ_LAT

CPU Idleness: $CPU_IDLE_PCT
" > $RESULT
cat $RESULT

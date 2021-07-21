#!/bin/bash

set -e

if [ -z $1 ];
then
        echo Require FIO output prefix
        exit 1
fi

PREFIX=${1}
OUTPUT_IOPS=${PREFIX}-iops.json
OUTPUT_BW=${PREFIX}-bandwidth.json
OUTPUT_LAT=${PREFIX}-latency.json

if [ ! -f "$OUTPUT_IOPS" ]; then
        echo "$OUTPUT_IOPS doesn't exist"
else
        READ_RAND_IOPS=`cat $OUTPUT_IOPS | jq '.jobs[0].read.iops_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`
        WRITE_RAND_IOPS=`cat $OUTPUT_IOPS | jq '.jobs[1].write.iops_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`
        READ_SEQ_IOPS=`cat $OUTPUT_IOPS | jq '.jobs[2].read.iops_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`
        WRITE_SEQ_IOPS=`cat $OUTPUT_IOPS | jq '.jobs[3].write.iops_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`
        CPU_IDLE_PCT_IOPS=`cat $OUTPUT_IOPS | jq '.cpu_idleness.system' | cut -f1 -d.`"%"

fi

if [ ! -f "$OUTPUT_BW" ]; then
        echo "$OUTPUT_BW doesn't exist"
else
        READ_RAND_BW=`cat $OUTPUT_BW | jq '.jobs[0].read.bw_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`" KiB/sec"
        WRITE_RAND_BW=`cat $OUTPUT_BW | jq '.jobs[1].write.bw_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`" KiB/sec"
        READ_SEQ_BW=`cat $OUTPUT_BW | jq '.jobs[2].read.bw_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`" KiB/sec"
        WRITE_SEQ_BW=`cat $OUTPUT_BW | jq '.jobs[3].write.bw_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`" KiB/sec"
        CPU_IDLE_PCT_BW=`cat $OUTPUT_BW| jq '.cpu_idleness.system' | cut -f1 -d.`"%"
fi

if [ ! -f "$OUTPUT_LAT" ]; then
        echo "$OUTPUT_LAT doesn't exist"
else
        READ_RAND_LAT=`cat $OUTPUT_LAT | jq '.jobs[0].read.lat_ns.mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`" ns"
        WRITE_RAND_LAT=`cat $OUTPUT_LAT | jq '.jobs[1].write.lat_ns.mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`" ns"
        READ_SEQ_LAT=`cat $OUTPUT_LAT | jq '.jobs[2].read.lat_ns.mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`" ns"
        WRITE_SEQ_LAT=`cat $OUTPUT_LAT | jq '.jobs[3].write.lat_ns.mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`" ns"
        CPU_IDLE_PCT_LAT=`cat $OUTPUT_LAT| jq '.cpu_idleness.system' | cut -f1 -d.`"%"
fi

RESULT=${1}.summary

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

IOPS (Read/Write):
Random:         $READ_RAND_IOPS  / $WRITE_RAND_IOPS
Sequential:     $READ_SEQ_IOPS / $WRITE_SEQ_IOPS
CPU Idleness:   $CPU_IDLE_PCT_IOPS

Bandwidth (Read/Write):
Random:         $READ_RAND_BW / $WRITE_RAND_BW
Sequential:     $READ_SEQ_BW / $WRITE_SEQ_BW
CPU Idleness:   $CPU_IDLE_PCT_BW

Latency (Read/Write):
Random:         $READ_RAND_LAT / $WRITE_RAND_LAT
Sequential:     $READ_SEQ_LAT / $WRITE_SEQ_LAT
CPU Idleness:   $CPU_IDLE_PCT_LAT

" > $RESULT
cat $RESULT

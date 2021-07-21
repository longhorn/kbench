#!/bin/bash

set -e

CURRENT_DIR="$(dirname "$(readlink -f "$0")")"
source $CURRENT_DIR/func.sh

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
        parse_iops $OUTPUT_IOPS
fi

if [ ! -f "$OUTPUT_BW" ]; then
        echo "$OUTPUT_BW doesn't exist"
else
        parse_bw $OUTPUT_BW
fi

if [ ! -f "$OUTPUT_LAT" ]; then
        echo "$OUTPUT_LAT doesn't exist"
else
        parse_lat $OUTPUT_LAT
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

SUMMARY="
=====================
FIO Benchmark Summary
For: $PREFIX
$SIZE_TEXT
$QUICK_MODE_TEXT
=====================
"

printf -v cxt "IOPS (Read/Write)\n$FMT$FMT$FMT\n"\
	"Random:" \
	"$RAND_READ_IOPS / $RAND_WRITE_IOPS" \
	"Sequential:" \
	"$SEQ_READ_IOPS / $SEQ_WRITE_IOPS" \
	"CPU Idleness:" \
	"$CPU_IDLE_PCT_IOPS"
SUMMARY+=$cxt

printf -v cxt "Bandwidth in KiB/sec (Read/Write)\n$FMT$FMT$FMT\n"\
	"Random:" \
	"$RAND_READ_BW / $RAND_WRITE_BW" \
	"Sequential:" \
	"$SEQ_READ_BW / $SEQ_WRITE_BW" \
	"CPU Idleness:" \
	"$CPU_IDLE_PCT_BW"
SUMMARY+=$cxt

printf -v cxt "Latency in ns (Read/Write)\n$FMT$FMT$FMT\n"\
	"Random:" \
	"$RAND_READ_LAT / $RAND_WRITE_LAT" \
	"Sequential:" \
	"$SEQ_READ_LAT / $SEQ_WRITE_LAT" \
	"CPU Idleness:" \
	"$CPU_IDLE_PCT_LAT"
SUMMARY+=$cxt

echo "$SUMMARY" > $RESULT
cat $RESULT

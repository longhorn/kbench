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
OUTPUT_IOPS=/output/${PREFIX}-iops.json
OUTPUT_BW=/output/${PREFIX}-bandwidth.json
OUTPUT_LAT=/output/${PREFIX}-latency.json

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

RESULT=/output/${1}.summary

QUICK_MODE_TEXT="Quick Mode: disabled"
if [ -n "$QUICK_MODE" ]; then
	QUICK_MODE_TEXT="Quick Mode: enabled"
fi

SIZE_TEXT="Size: 10g"
if [ -n "$SIZE" ]; then
	SIZE_TEXT="Size: $SIZE"
fi

SUMMARY="
=========================
FIO Benchmark Summary
For: $PREFIX
CPU Idleness Profiling: $CPU_IDLE_PROF
$SIZE_TEXT
$QUICK_MODE_TEXT
=========================
"

if [ x"$CPU_IDLE_PROF" = x"enabled" ]; then
	printf -v cxt "IOPS (Read/Write)\n$FMT$FMT$FMT\n"\
		"Random:" \
		"$(commaize $RAND_READ_IOPS) / $(commaize $RAND_WRITE_IOPS)" \
		"Sequential:" \
		"$(commaize $SEQ_READ_IOPS) / $(commaize $SEQ_WRITE_IOPS)" \
		"CPU Idleness:" \
		"$CPU_IDLE_PCT_IOPS%"
	SUMMARY+=$cxt

	printf -v cxt "Bandwidth in KiB/sec (Read/Write)\n$FMT$FMT$FMT\n"\
		"Random:" \
		"$(commaize $RAND_READ_BW) / $(commaize $RAND_WRITE_BW)" \
		"Sequential:" \
		"$(commaize $SEQ_READ_BW) / $(commaize $SEQ_WRITE_BW)" \
		"CPU Idleness:" \
		"$CPU_IDLE_PCT_BW%"
	SUMMARY+=$cxt

	printf -v cxt "Latency in ns (Read/Write)\n$FMT$FMT\n"\
		"Random:" \
		"$(commaize $RAND_READ_LAT) / $(commaize $RAND_WRITE_LAT)" \
		"Sequential:" \
		"$(commaize $SEQ_READ_LAT) / $(commaize $SEQ_WRITE_LAT)" \
		"CPU Idleness:" \
		"$CPU_IDLE_PCT_LAT%"
	SUMMARY+=$cxt
else
	printf -v cxt "IOPS (Read/Write)\n$FMT$FMT\n"\
		"Random:" \
		"$(commaize $RAND_READ_IOPS) / $(commaize $RAND_WRITE_IOPS)" \
		"Sequential:" \
		"$(commaize $SEQ_READ_IOPS) / $(commaize $SEQ_WRITE_IOPS)"
	SUMMARY+=$cxt

	printf -v cxt "Bandwidth in KiB/sec (Read/Write)\n$FMT$FMT$FMT\n"\
		"Random:" \
		"$(commaize $RAND_READ_BW) / $(commaize $RAND_WRITE_BW)" \
		"Sequential:" \
		"$(commaize $SEQ_READ_BW) / $(commaize $SEQ_WRITE_BW)"
	SUMMARY+=$cxt

	printf -v cxt "Latency in ns (Read/Write)\n$FMT$FMT\n"\
		"Random:" \
		"$(commaize $RAND_READ_LAT) / $(commaize $RAND_WRITE_LAT)" \
		"Sequential:" \
		"$(commaize $SEQ_READ_LAT) / $(commaize $SEQ_WRITE_LAT)"
	SUMMARY+=$cxt
fi

echo "$SUMMARY" > $RESULT
cat $RESULT

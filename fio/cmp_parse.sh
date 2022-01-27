#!/bin/bash

set -e

CURRENT_DIR="$(dirname "$(readlink -f "$0")")"
source $CURRENT_DIR/func.sh

if [ -z "FIRST_VOL_NAME" ]; then
	echo Require the first volume name
	exit 1
fi

if [ -z "SECOND_VOL_NAME" ]; then
	echo Require the second volume name
	exit 1
fi

FIRST_IOPS=${FIRST_VOL_NAME}-iops.json
FIRST_BW=${FIRST_VOL_NAME}-bandwidth.json
FIRST_LAT=${FIRST_VOL_NAME}-latency.json

SECOND_IOPS=${SECOND_VOL_NAME}-iops.json
SECOND_BW=${SECOND_VOL_NAME}-bandwidth.json
SECOND_LAT=${SECOND_VOL_NAME}-latency.json

parse_iops $FIRST_IOPS
FIRST_RAND_READ_IOPS=$RAND_READ_IOPS
FIRST_RAND_WRITE_IOPS=$RAND_WRITE_IOPS
FIRST_SEQ_READ_IOPS=$SEQ_READ_IOPS
FIRST_SEQ_WRITE_IOPS=$SEQ_WRITE_IOPS
FIRST_CPU_IDLE_PCT_IOPS=$CPU_IDLE_PCT_IOPS

parse_iops $SECOND_IOPS
SECOND_RAND_READ_IOPS=$RAND_READ_IOPS
SECOND_RAND_WRITE_IOPS=$RAND_WRITE_IOPS
SECOND_SEQ_READ_IOPS=$SEQ_READ_IOPS
SECOND_SEQ_WRITE_IOPS=$SEQ_WRITE_IOPS
SECOND_CPU_IDLE_PCT_IOPS=$CPU_IDLE_PCT_IOPS

calc_cmp_iops

parse_bw $FIRST_BW
FIRST_RAND_READ_BW=$RAND_READ_BW
FIRST_RAND_WRITE_BW=$RAND_WRITE_BW
FIRST_SEQ_READ_BW=$SEQ_READ_BW
FIRST_SEQ_WRITE_BW=$SEQ_WRITE_BW
FIRST_CPU_IDLE_PCT_BW=$CPU_IDLE_PCT_BW

parse_bw $SECOND_BW
SECOND_RAND_READ_BW=$RAND_READ_BW
SECOND_RAND_WRITE_BW=$RAND_WRITE_BW
SECOND_SEQ_READ_BW=$SEQ_READ_BW
SECOND_SEQ_WRITE_BW=$SEQ_WRITE_BW
SECOND_CPU_IDLE_PCT_BW=$CPU_IDLE_PCT_BW

calc_cmp_bw

parse_lat $FIRST_LAT
FIRST_RAND_READ_LAT=$RAND_READ_LAT
FIRST_RAND_WRITE_LAT=$RAND_WRITE_LAT
FIRST_SEQ_READ_LAT=$SEQ_READ_LAT
FIRST_SEQ_WRITE_LAT=$SEQ_WRITE_LAT
FIRST_CPU_IDLE_PCT_LAT=$CPU_IDLE_PCT_LAT

parse_lat $SECOND_LAT
SECOND_RAND_READ_LAT=$RAND_READ_LAT
SECOND_RAND_WRITE_LAT=$RAND_WRITE_LAT
SECOND_SEQ_READ_LAT=$SEQ_READ_LAT
SECOND_SEQ_WRITE_LAT=$SEQ_WRITE_LAT
SECOND_CPU_IDLE_PCT_LAT=$CPU_IDLE_PCT_LAT

calc_cmp_lat

RESULT=${FIRST_VOL_NAME}_vs_${SECOND_VOL_NAME}.summary

QUICK_MODE_TEXT="Quick Mode: disabled"
if [ -n "$QUICK_MODE" ]; then
	QUICK_MODE_TEXT="Quick Mode: enabled"
fi

SIZE_TEXT="SIZE: 10g"
if [ -n "$SIZE" ]; then
	SIZE_TEXT="Size: $SIZE"
fi

SUMMARY="
================================
FIO Benchmark Comparsion Summary
For: $FIRST_VOL_NAME vs $SECOND_VOL_NAME
CPU Idleness Profiling: $CPU_IDLE_PROF
$SIZE_TEXT
$QUICK_MODE_TEXT
================================
"

printf -v header "$CMP_FMT" \
	"" $FIRST_VOL_NAME "vs" $SECOND_VOL_NAME ":" "Change"
SUMMARY+=$header

if [ x"$CPU_IDLE_PROF" = x"enabled" ]; then
	printf -v cxt "IOPS (Read/Write)\n$CMP_FMT$CMP_FMT$CMP_FMT\n" \
		"Random:" \
		"$(commaize $FIRST_RAND_READ_IOPS) / $(commaize $FIRST_RAND_WRITE_IOPS)" \
		"vs" \
		"$(commaize $SECOND_RAND_READ_IOPS) / $(commaize $SECOND_RAND_WRITE_IOPS)" \
		":" \
		"$CMP_RAND_READ_IOPS / $CMP_RAND_WRITE_IOPS" \
		"Sequential:" \
		"$(commaize $FIRST_SEQ_READ_IOPS) / $(commaize $FIRST_SEQ_WRITE_IOPS)" \
		"vs" \
		"$(commaize $SECOND_SEQ_READ_IOPS) / $(commaize $SECOND_SEQ_WRITE_IOPS)" \
		":" \
		"$CMP_SEQ_READ_IOPS / $CMP_SEQ_WRITE_IOPS" \
		"CPU Idleness:" \
		"$FIRST_CPU_IDLE_PCT_IOPS%" \
		"vs" \
		"$SECOND_CPU_IDLE_PCT_IOPS%"\
		":" \
		"$CMP_CPU_IDLE_PCT_IOPS%"
	SUMMARY+=$cxt

	printf -v cxt "Bandwidth in KiB/sec (Read/Write)\n$CMP_FMT$CMP_FMT$CMP_FMT\n" \
		"Random:" \
		"$(commaize $FIRST_RAND_READ_BW) / $(commaize $FIRST_RAND_WRITE_BW)" \
		"vs" \
		"$(commaize $SECOND_RAND_READ_BW) / $(commaize $SECOND_RAND_WRITE_BW)" \
		":" \
		"$CMP_RAND_READ_BW / $CMP_RAND_WRITE_BW" \
		"Sequential:" \
		"$(commaize $FIRST_SEQ_READ_BW) / $(commaize $FIRST_SEQ_WRITE_BW)" \
		"vs" \
		"$(commaize $SECOND_SEQ_READ_BW) / $(commaize $SECOND_SEQ_WRITE_BW)" \
		":" \
		"$CMP_SEQ_READ_BW / $CMP_SEQ_WRITE_BW" \
		"CPU Idleness:" \
		"$FIRST_CPU_IDLE_PCT_BW%" \
		"vs" \
		"$SECOND_CPU_IDLE_PCT_BW%" \
		":" \
		"$CMP_CPU_IDLE_PCT_BW%"
	SUMMARY+=$cxt

	printf -v cxt "Latency in ns (Read/Write)\n$CMP_FMT$CMP_FMT$CMP_FMT\n" \
		"Random:" \
		"$(commaize $FIRST_RAND_READ_LAT) / $(commaize $FIRST_RAND_WRITE_LAT)" \
		"vs" \
		"$(commaize $SECOND_RAND_READ_LAT) / $(commaize $SECOND_RAND_WRITE_LAT)" \
		":" \
		"$CMP_RAND_READ_LAT / $CMP_RAND_WRITE_LAT" \
		"Sequential:" \
		"$(commaize $FIRST_SEQ_READ_LAT) / $(commaize $FIRST_SEQ_WRITE_LAT)" \
		"vs" \
		"$(commaize $SECOND_SEQ_READ_LAT) / $(commaize $SECOND_SEQ_WRITE_LAT)" \
		":" \
		"$CMP_SEQ_READ_LAT / $CMP_SEQ_WRITE_LAT" \
		"CPU Idleness:" \
		"$FIRST_CPU_IDLE_PCT_LAT%" \
		"vs" \
		"$SECOND_CPU_IDLE_PCT_LAT%" \
		":" \
		"$CMP_CPU_IDLE_PCT_LAT%"
		SUMMARY+=$cxt
else
	printf -v cxt "IOPS (Read/Write)\n$CMP_FMT$CMP_FMT\n" \
		"Random:" \
		"$(commaize $FIRST_RAND_READ_IOPS) / $(commaize $FIRST_RAND_WRITE_IOPS)" \
		"vs" \
		"$(commaize $SECOND_RAND_READ_IOPS) / $(commaize $SECOND_RAND_WRITE_IOPS)" \
		":" \
		"$CMP_RAND_READ_IOPS / $CMP_RAND_WRITE_IOPS" \
		"Sequential:" \
		"$(commaize $FIRST_SEQ_READ_IOPS) / $(commaize $FIRST_SEQ_WRITE_IOPS)" \
		"vs" \
		"$(commaize $SECOND_SEQ_READ_IOPS) / $(commaize $SECOND_SEQ_WRITE_IOPS)" \
		":" \
		"$CMP_SEQ_READ_IOPS / $CMP_SEQ_WRITE_IOPS"
	SUMMARY+=$cxt

	printf -v cxt "Bandwidth in KiB/sec (Read/Write)\n$CMP_FMT$CMP_FMT\n" \
		"Random:" \
		"$(commaize $FIRST_RAND_READ_BW) / $(commaize $FIRST_RAND_WRITE_BW)" \
		"vs" \
		"$(commaize $SECOND_RAND_READ_BW) / $(commaize $SECOND_RAND_WRITE_BW)" \
		":" \
		"$CMP_RAND_READ_BW / $CMP_RAND_WRITE_BW" \
		"Sequential:" \
		"$(commaize $FIRST_SEQ_READ_BW) / $(commaize $FIRST_SEQ_WRITE_BW)" \
		"vs" \
		"$(commaize $SECOND_SEQ_READ_BW) / $(commaize $SECOND_SEQ_WRITE_BW)" \
		":" \
		"$CMP_SEQ_READ_BW / $CMP_SEQ_WRITE_BW"
	SUMMARY+=$cxt

	printf -v cxt "Latency in ns (Read/Write)\n$CMP_FMT$CMP_FMT\n" \
		"Random:" \
		"$(commaize $FIRST_RAND_READ_LAT) / $(commaize $FIRST_RAND_WRITE_LAT)" \
		"vs" \
		"$(commaize $SECOND_RAND_READ_LAT) / $(commaize $SECOND_RAND_WRITE_LAT)" \
		":" \
		"$CMP_RAND_READ_LAT / $CMP_RAND_WRITE_LAT" \
		"Sequential:" \
		"$(commaize $FIRST_SEQ_READ_LAT) / $(commaize $FIRST_SEQ_WRITE_LAT)" \
		"vs" \
		"$(commaize $SECOND_SEQ_READ_LAT) / $(commaize $SECOND_SEQ_WRITE_LAT)" \
		":" \
		"$CMP_SEQ_READ_LAT / $CMP_SEQ_WRITE_LAT"
		SUMMARY+=$cxt
fi

echo "$SUMMARY" > $RESULT
cat $RESULT

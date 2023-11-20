#!/bin/bash

#sleep 1000000
set -e

CURRENT_DIR="$(dirname "$(readlink -f "$0")")"

TEST_FILE=$1

# cmdline overrides the environment variable
if [ -z "$TEST_FILE" ]; then
	TEST_FILE=$FILE_NAME
fi

if [ -z "$TEST_FILE" ]; then
        echo Require test file name
        exit 1
fi

if [ x"$CPU_IDLE_PROF" = x"enabled" ]; then
	IDLE_PROF="--idle-prof=percpu"
fi

echo TEST_FILE: $TEST_FILE

OUTPUT=$2
if [ -z $OUTPUT ];
then
	OUTPUT=test_device
fi
echo TEST_OUTPUT_PREFIX: $OUTPUT

BACKEND_DEVICE=$3
if [ -z "$BACKEND_DEVICE" ]; then
        BACKEND_DEVICE=$LONGHORN_BACKEND_DEVICE
fi
if [ -z "$BACKEND_DEVICE" ]; then
        BACKEND_DEVICE=""
fi

TEST_SIZE=$4
if [ -z "$TEST_SIZE" ]; then
       TEST_SIZE=$SIZE
fi
if [ -z "$TEST_SIZE" ]; then
       TEST_SIZE="10g"
fi
echo TEST_SIZE: $TEST_SIZE

IOPS_FIO="iops.fio"
BW_FIO="bandwidth.fio"
LAT_FIO="latency.fio"
if [ -n "$QUICK_MODE" ]; then
	echo QUICK_MODE: enabled
        IOPS_FIO="iops-quick.fio"
        BW_FIO="bandwidth-quick.fio"
        LAT_FIO="latency-quick.fio"
fi

OUTPUT_IOPS=/output/${OUTPUT}-iops.json
OUTPUT_IOPS_IOSTAT=/output/${OUTPUT}-iops-iostat.log
OUTPUT_BW=/output/${OUTPUT}-bandwidth.json
OUTPUT_BW_IOSTAT=/output/${OUTPUT}-bandwidth-iostat.log
OUTPUT_LAT=/output/${OUTPUT}-latency.json
OUTPUT_LAT_IOSTAT=/output/${OUTPUT}-latency-iostat.log


# clean up the previous result
if [ -z "$SKIP_CLEANUP" ]; then
        rm -rf /output/*
fi

echo Benchmarking $IOPS_FIO into $OUTPUT_IOPS
iostat -x -k -t -y 1 $BACKEND_DEVICE > $OUTPUT_IOPS_IOSTAT &
IOSTAT_PID=$!

fio $CURRENT_DIR/$IOPS_FIO $IDLE_PROF --filename=$TEST_FILE --size=$TEST_SIZE \
	--output-format=json --output=$OUTPUT_IOPS
echo "Benchmarking $IOPS_FIO into $OUTPUT_IOPS done, kill the iostat process (pid: $IOSTAT_PID)..."
kill -9 $IOSTAT_PID

echo Benchmarking $BW_FIO into $OUTPUT_BW
iostat -x -k -t -y 1 $BACKEND_DEVICE > $OUTPUT_BW_IOSTAT &
IOSTAT_PID=$!

fio $CURRENT_DIR/$BW_FIO $IDLE_PROF --filename=$TEST_FILE --size=$TEST_SIZE \
	--output-format=json --output=$OUTPUT_BW
echo "Benchmarking $BW_FIO into $OUTPUT_BW done, kill the iostat process (pid: $IOSTAT_PID)..."
kill -9 $IOSTAT_PID

echo Benchmarking $LAT_FIO into $OUTPUT_LAT
iostat -x -k -t -y 1 $BACKEND_DEVICE > $OUTPUT_LAT_IOSTAT &
IOSTAT_PID=$!

fio $CURRENT_DIR/$LAT_FIO $IDLE_PROF --filename=$TEST_FILE --size=$TEST_SIZE \
	--output-format=json --output=$OUTPUT_LAT
echo "Benchmarking $LAT_FIO into $OUTPUT_LAT done, kill the iostat process (pid: $IOSTAT_PID)..."
kill -9 $IOSTAT_PID

if [ -z "$SKIP_PARSE" ]; then
        $CURRENT_DIR/parse.sh $OUTPUT
fi

#!/bin/bash

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

echo TEST_FILE: $TEST_FILE

OUTPUT=$2
if [ -z $OUTPUT ];
then
	OUTPUT=test_device
fi
echo TEST_OUTPUT_PREFIX: $OUTPUT

TEST_SIZE=$3
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

OUTPUT_IOPS=${OUTPUT}-iops.json
OUTPUT_BW=${OUTPUT}-bandwidth.json
OUTPUT_LAT=${OUTPUT}-latency.json

echo Benchmarking $IOPS_FIO into $OUTPUT_IOPS
fio $CURRENT_DIR/$IOPS_FIO --idle-prof=percpu --filename=$TEST_FILE --size=$TEST_SIZE \
	--output-format=json --output=$OUTPUT_IOPS
echo Benchmarking $BW_FIO into $OUTPUT_BW
fio $CURRENT_DIR/$BW_FIO --idle-prof=percpu --filename=$TEST_FILE --size=$TEST_SIZE \
	--output-format=json --output=$OUTPUT_BW
echo Benchmarking $LAT_FIO into $OUTPUT_LAT
fio $CURRENT_DIR/$LAT_FIO --idle-prof=percpu --filename=$TEST_FILE --size=$TEST_SIZE \
	--output-format=json --output=$OUTPUT_LAT

if [ -z "$SKIP_PARSE" ]; then
        $CURRENT_DIR/parse.sh $OUTPUT
fi

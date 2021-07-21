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

TEST_SIZE="10g"
if [ -n "$SIZE" ]; then
	TEST_SIZE=$SIZE
fi
echo TEST_SIZE: $TEST_SIZE

OUTPUT=$2
if [ -z $OUTPUT ];
then
	OUTPUT=test_device
fi

IOPS_FIO="iops.fio"
BW_FIO="bandwidth.fio"
LAT_FIO="latency.fio"
if [ -n "$QUICK_MODE" ]; then
	echo QUICK_MODE: enabled
        IOPS_FIO="iops-quick.fio"
        BW_FIO="bandwidth-quick.fio"
        LAT_FIO="latency-quick.fio"
fi

echo Benchmarking $IOPS_FIO
fio $CURRENT_DIR/$IOPS_FIO --idle-prof=percpu --filename=$TEST_FILE --size=$TEST_SIZE \
	--output-format=json --output=${OUTPUT}-iops.json
echo Benchmarking $BW_FIO
fio $CURRENT_DIR/$BW_FIO --idle-prof=percpu --filename=$TEST_FILE --size=$TEST_SIZE \
	--output-format=json --output=${OUTPUT}-bandwidth.json
echo Benchmarking $LAT_FIO
fio $CURRENT_DIR/$LAT_FIO --idle-prof=percpu --filename=$TEST_FILE --size=$TEST_SIZE \
	--output-format=json --output=${OUTPUT}-latency.json

$CURRENT_DIR/parse.sh $OUTPUT

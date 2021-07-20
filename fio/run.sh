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

BENCHMARK_FIO="benchmark.fio"
CPU_FIO="cpu.fio"
if [ -n "$QUICK_MODE" ]; then
	echo QUICK_MODE: enabled
	BENCHMARK_FIO="benchmark-quick.fio"
	CPU_FIO="cpu-quick.fio"
fi
echo Running $BENCHMARK_FIO and $CPU_FIO

fio $CURRENT_DIR/$BENCHMARK_FIO --eta=always --eta-interval=10s --filename=$TEST_FILE --size=$TEST_SIZE \
	--output-format=json --output=${OUTPUT}-benchmark.json
fio $CURRENT_DIR/$CPU_FIO --eta=always --eta-interval=10s --idle-prof=percpu --filename=$TEST_FILE --size=$TEST_SIZE \
	--output-format=json --output=${OUTPUT}-cpu.json

$CURRENT_DIR/parse.sh $OUTPUT

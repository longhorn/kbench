#!/bin/bash

set -e

CURRENT_DIR="$(dirname "$(readlink -f "$0")")"
TEST_FILE="${1:-$FILE_NAME}"
OUTPUT="${2:-test_device}"
TEST_SIZE="${3:-${SIZE:-10g}}"

if [ -z "$TEST_FILE" ]; then
    echo "Require test file name"
    exit 1
fi

echo "TEST_FILE: $TEST_FILE"
echo "TEST_OUTPUT_PREFIX: $OUTPUT"
echo "TEST_SIZE: $TEST_SIZE"

if [ x"$CPU_IDLE_PROF" = x"enabled" ]; then
    IDLE_PROF="--idle-prof=percpu"
fi

IO_TYPES="${IO_TYPES:-seqread,seqwrite,randread,randwrite}"
METRICS="${METRICS:-bandwidth,iops,latency}"

echo "IO_TYPES: $IO_TYPES"
echo "METRICS: $METRICS"

IFS=',' read -r -a io_types_array <<< "${IO_TYPES}"
IFS=',' read -r -a metrics_array <<< "${METRICS}"

for TYPE in "${io_types_array[@]}"; do
    for METRIC in "${metrics_array[@]}"; do
        echo "Running $TYPE $METRIC test"

        JOB_FILE="$CURRENT_DIR/jobs/$METRIC.fio"
        if [ "$QUICK_MODE" = "enabled" ]; then
                JOB_FILE="$CURRENT_DIR/jobs/$METRIC-quick.fio"
        fi

        fio "$CURRENT_DIR/jobs/$METRIC.fio" $IDLE_PROF --section="${TYPE}-${METRIC}" --filename="$TEST_FILE" --size="$TEST_SIZE" --output-format=json --output="${OUTPUT}-${TYPE}-${METRIC}.json"
    done
done

"$CURRENT_DIR/parse.sh" "$IO_TYPES" "$METRICS" "$OUTPUT" "false"
"$CURRENT_DIR/parse.sh" "$IO_TYPES" "latency" "$OUTPUT" "true"


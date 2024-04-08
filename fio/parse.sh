#!/bin/bash

set -e

CURRENT_DIR="$(dirname "$(readlink -f "$0")")"
source $CURRENT_DIR/func.sh

append_metric() {
    local metric_name="${1}"
    local metric_unit="${2}"
    local randread="${3}"
    local cpu_idle_pct_randread="${4}"
    local randwrite="${5}"
    local cpu_idle_pct_randwrite="${6}"
    local seqread="${7}"
    local cpu_idle_pct_seqread="${8}"
    local seqwrite="${9}"
    local cpu_idle_pct_seqwrite="${10}"

    if [ "$CPU_IDLE_PROF" = "enabled" ] && [ "$P99_LATENCY" = "false" ]; then
        # If CPU idle profiling is enabled, include it in the output
        printf -v cxt "%s in %s with CPU idleness in percent (Read/Write)\n$FMT$FMT\n" \
            "$metric_name" "$metric_unit" \
            "Random:" \
            "$(commaize "${randread:-0}") ($(commaize "${cpu_idle_pct_randread:-0}")) / $(commaize "${randwrite:-0}") ($(commaize "${cpu_idle_pct_randwrite:-0}"))" \
            "Sequential:" \
            "$(commaize "${seqread:-0}") ($(commaize "${cpu_idle_pct_seqread:-0}")) / $(commaize "${seqwrite:-0}") ($(commaize "${cpu_idle_pct_seqwrite:-0}"))"
    else
        # If CPU idle profiling is not enabled, exclude it from the output
        printf -v cxt "%s in %s (Read/Write)\n$FMT$FMT\n" \
            "$metric_name" "$metric_unit" \
            "Random:" \
            "$(commaize "${randread:-0}") / $(commaize "${randwrite:-0}")" \
            "Sequential:" \
            "$(commaize "${seqread:-0}") / $(commaize "${seqwrite:-0}")"
    fi
    SUMMARY+="$cxt"
}


if [ -z "${1}" ]; then
    echo Require FIO IO types
    exit 1
fi
IO_TYPES="${1}"

if [ -z "${2}" ]; then
    echo Require FIO metrics
    exit 1
fi
METRICS="${2}"

if [ -z "${3}" ]; then
    echo Require FIO output prefix
    exit 1
fi
PREFIX="${3}"

P99_LATENCY="${4:-true}"

IFS=',' read -r -a io_types_array <<< "${IO_TYPES}"
IFS=',' read -r -a metrics_array <<< "${METRICS}"

for TYPE in "${io_types_array[@]}"; do
    for METRIC in "${metrics_array[@]}"; do
        OUTPUT="${PREFIX}-${TYPE}-${METRIC}.json"
        if [ "$P99_LATENCY" = "true" ]; then
            parse_${TYPE}_${METRIC}_p99 "$OUTPUT"
        else
            parse_${TYPE}_${METRIC} "$OUTPUT"
        fi
    done
done

# Initialize the result file name
# Build the summary with header information
if [ "$P99_LATENCY" = "false" ]; then
    RESULT="${PREFIX}.summary"
    TITLE="FIO Benchmark Summary"
else
    RESULT="${PREFIX}_p99_latency.summary"
    TITLE="FIO Benchmark P99 Latency Summary"
fi

# Construct the SUMMARY with dynamic content
SUMMARY="
==================================
$TITLE
For: $PREFIX
CPU Idleness Profiling: ${CPU_IDLE_PROF:-not provided}
Size: ${SIZE:-10g}
Quick Mode: ${QUICK_MODE:-disabled}
==================================
"

# Append performance metrics to the summary
if [ "$P99_LATENCY" = "false" ]; then
    append_metric "IOPS" "ops" \
        "$RANDREAD_IOPS" "$CPU_IDLE_PCT_RANDREAD_IOPS" \
        "$RANDWRITE_IOPS" "$CPU_IDLE_PCT_RANDWRITE_IOPS" \
        "$SEQREAD_IOPS" "$CPU_IDLE_PCT_SEQREAD_IOPS" \
        "$SEQWRITE_IOPS" "$CPU_IDLE_PCT_SEQWRITE_IOPS"
    append_metric "Bandwidth" "KiB/sec" \
        "$RANDREAD_BANDWIDTH" "$CPU_IDLE_PCT_RANDREAD_BANDWIDTH" \
        "$RANDWRITE_BANDWIDTH" "$CPU_IDLE_PCT_RANDWRITE_BANDWIDTH" \
        "$SEQREAD_BANDWIDTH" "$CPU_IDLE_PCT_SEQREAD_BANDWIDTH" \
        "$SEQWRITE_BANDWIDTH" "$CPU_IDLE_PCT_SEQWRITE_BANDWIDTH"
fi

append_metric "Latency" "ns" \
    "$RANDREAD_LATENCY" "$CPU_IDLE_PCT_RANDREAD_LATENCY" \
    "$RANDWRITE_LATENCY" "$CPU_IDLE_PCT_RANDWRITE_LATENCY" \
    "$SEQREAD_LATENCY" "$CPU_IDLE_PCT_SEQREAD_LATENCY" \
    "$SEQWRITE_LATENCY" "$CPU_IDLE_PCT_SEQWRITE_LATENCY"

echo "$SUMMARY" > "$RESULT"
cat "$RESULT"

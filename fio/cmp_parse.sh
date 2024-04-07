#!/bin/bash

set -e

CURRENT_DIR="$(dirname "$(readlink -f "$0")")"
source $CURRENT_DIR/func.sh

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

if [ -z "FIRST_VOL_NAME" ]; then
    echo Require the first volume name
    exit 1
fi

if [ -z "SECOND_VOL_NAME" ]; then
    echo Require the second volume name
    exit 1
fi

IFS=',' read -r -a io_types_array <<< "${IO_TYPES}"
IFS=',' read -r -a metrics_array <<< "${METRICS}"

to_uppercase() {
    local input_str="$1"
    local uppercase_str="${input_str^^}" # Convert to uppercase
    echo "$uppercase_str"
}

parse_metrics() {
    local vol_name="$1"
    local prefix="$2"

    if [[ -z "$vol_name" || -z "$prefix" ]]; then
        echo "parse_metrics: Missing required parameters." >&2
        return 1
    fi

    for METRIC in "${metrics_array[@]}"; do
        for IO_TYPE in "${io_types_array[@]}"; do
            local output="${vol_name}-${IO_TYPE}-${METRIC}.json"
            local parse_func="parse_${IO_TYPE}_${METRIC}"

            if declare -f "$parse_func" > /dev/null; then
                $parse_func "$output"

                local metric=`to_uppercase $METRIC`
                local io_type=`to_uppercase $IO_TYPE`
                local var_suffix=""
                local var_name=""

                var_suffix="${io_type}_${metric^^}"
                var_name="${prefix}_${var_suffix}"
                declare -g "$var_name=${!var_suffix}"

                var_suffix="CPU_IDLE_PCT_${io_type}_${metric^^}"
                var_name="${prefix}_${var_suffix}"
                declare -g "$var_name=${!var_suffix}"
            else
                echo "parse_metrics: Parser function '$parse_func' not found for $output." >&2
            fi
        done
    done
}

parse_metrics "$FIRST_VOL_NAME" "FIRST"
parse_metrics "$SECOND_VOL_NAME" "SECOND"

calc_cmp_iops
calc_cmp_bandwidth
calc_cmp_latency

# Build the summary with header information
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

#!/bin/bash

# Define a function to add metrics to the summary
add_metrics_to_summary() {
    local metric_name="${1}"
    local metric_unit="${2}"

    local first_randread="${3}"
    local first_cpu_idle_pct_randread="${4}"
    local first_randwrite="${5}"
    local first_cpu_idle_pct_randwrite="${6}"
    local second_randread="${7}"
    local second_cpu_idle_pct_randread="${8}"
    local second_randwrite="${9}"
    local second_cpu_idle_pct_randwrite="${10}"
    local cmp_randread="${11}"
    local cmp_cpu_idle_pct_randread="${12}"
    local cmp_randwrite="${13}"
    local cmp_cpu_idle_pct_randwrite="${14}"

    local first_seqread="${15}"
    local first_cpu_idle_pct_seqread="${16}"
    local first_seqwrite="${17}"
    local first_cpu_idle_pct_seqwrite="${18}"
    local second_seqread="${19}"
    local second_cpu_idle_pct_seqread="${20}"
    local second_seqwrite="${21}"
    local second_cpu_idle_pct_seqwrite="${22}"
    local cmp_seqread="${23}"
    local cmp_cpu_idle_pct_seqread="${24}"
    local cmp_seqwrite="${25}"
    local cmp_cpu_idle_pct_seqwrite="${26}"

    if [ "$CPU_IDLE_PROF" = "enabled" ]; then
        printf -v cxt "${metric_name} in ${metric_unit} with CPU idleness in percent (Read/Write)\n${CMP_FMT}${CMP_FMT}${CMP_FMT}\n" \
            "Random:" \
            "$(commaize "${first_randread}") ($(commaize "${first_cpu_idle_pct_randread}")) / $(commaize "${first_randwrite}") ($(commaize "${first_cpu_idle_pct_randwrite}"))" \
            "vs" \
            "$(commaize "${second_randread}") ($(commaize "${second_cpu_idle_pct_randread}")) / $(commaize "${second_randwrite}") ($(commaize "${second_cpu_idle_pct_randwrite}"))" ":" \
            "${cmp_randread} (${cmp_cpu_idle_pct_randread}) / ${cmp_randwrite} (${cmp_cpu_idle_pct_randwrite})" \
            "Sequential:" \
            "$(commaize "${first_seqread}") ($(commaize "${first_cpu_idle_pct_seqread}")) / $(commaize "${first_seqwrite}") ($(commaize "${first_cpu_idle_pct_seqwrite}"))" \
            "vs" \
            "$(commaize "${second_seqread}") ($(commaize "${second_cpu_idle_pct_seqread}")) / $(commaize "${second_seqwrite}") ($(commaize "${second_cpu_idle_pct_seqwrite}"))" ":" \
            "${cmp_seqread} (${cmp_cpu_idle_pct_seqread}) / ${cmp_seqwrite} (${cmp_cpu_idle_pct_seqwrite})"
    else
        printf -v cxt "${metric_name} in KiB/sec (Read/Write)\n${CMP_FMT}${CMP_FMT}${CMP_FMT}\n" \
            "Random:" \
            "$(commaize "${first_randread}") / $(commaize "${first_randwrite}")" \
            "vs" \
            "$(commaize "${second_randread}") / $(commaize "${second_randwrite}")" ":" \
            "${cmp_randread} / ${cmp_randwrite}" \
            "Sequential:" \
            "$(commaize "${first_seqread}") / $(commaize "${first_seqwrite}")" \
            "vs" \
            "$(commaize "${second_seqread}") / $(commaize "${second_seqwrite}")" ":" \
            "${cmp_seqread} / ${cmp_seqwrite}"
    fi
    SUMMARY+="${cxt}"
}

# Check CPU_IDLE_PROF status
CPU_IDLE_STATUS="disabled"
if [ "x$CPU_IDLE_PROF" = "xenabled" ]; then
    CPU_IDLE_STATUS="enabled"
fi

# Example usage
add_metrics_to_summary "IOPS" "ops" \
    "$FIRST_RANDREAD_IOPS" "$FIRST_CPU_IDLE_PCT_RANDREAD_IOPS" \
    "$FIRST_RANDWRITE_IOPS" "$FIRST_CPU_IDLE_PCT_RANDWRITE_IOPS" \
    "$SECOND_RANDREAD_IOPS" "$SECOND_CPU_IDLE_PCT_RANDREAD_IOPS" \
    "$SECOND_RANDWRITE_IOPS" "$SECOND_CPU_IDLE_PCT_RANDWRITE_IOPS" \
    "$CMP_RANDREAD_IOPS" "$CMP_CPU_IDLE_PCT_RANDREAD_IOPS" \
    "$CMP_RANDWRITE_IOPS" "$CMP_CPU_IDLE_PCT_RANDWRITE_IOPS" \
    "$FIRST_SEQREAD_IOPS" "$FIRST_CPU_IDLE_PCT_SEQREAD_IOPS" \
    "$FIRST_SEQWRITE_IOPS" "$FIRST_CPU_IDLE_PCT_SEQWRITE_IOPS" \
    "$SECOND_SEQREAD_IOPS" "$SECOND_CPU_IDLE_PCT_SEQREAD_IOPS" \
    "$SECOND_SEQWRITE_IOPS" "$SECOND_CPU_IDLE_PCT_SEQWRITE_IOPS" \
    "$CMP_SEQREAD_IOPS" "$CMP_CPU_IDLE_PCT_SEQREAD_IOPS" \
    "$CMP_SEQWRITE_IOPS" "$CMP_CPU_IDLE_PCT_SEQWRITE_IOPS"

add_metrics_to_summary "Bandwidth" "KiB/sec" \
    "$FIRST_RANDREAD_BANDWIDTH" "$FIRST_CPU_IDLE_PCT_RANDREAD_BANDWIDTH" \
    "$FIRST_RANDWRITE_BANDWIDTH" "$FIRST_CPU_IDLE_PCT_RANDWRITE_BANDWIDTH" \
    "$SECOND_RANDREAD_BANDWIDTH" "$SECOND_CPU_IDLE_PCT_RANDREAD_BANDWIDTH" \
    "$SECOND_RANDWRITE_BANDWIDTH" "$SECOND_CPU_IDLE_PCT_RANDWRITE_BANDWIDTH" \
    "$CMP_RANDREAD_BANDWIDTH" "$CMP_CPU_IDLE_PCT_RANDREAD_BANDWIDTH" \
    "$CMP_RANDWRITE_BANDWIDTH" "$CMP_CPU_IDLE_PCT_RANDWRITE_BANDWIDTH" \
    "$FIRST_SEQREAD_BANDWIDTH" "$FIRST_CPU_IDLE_PCT_SEQREAD_BANDWIDTH" \
    "$FIRST_SEQWRITE_BANDWIDTH" "$FIRST_CPU_IDLE_PCT_SEQWRITE_BANDWIDTH" \
    "$SECOND_SEQREAD_BANDWIDTH" "$SECOND_CPU_IDLE_PCT_SEQREAD_BANDWIDTH" \
    "$SECOND_SEQWRITE_BANDWIDTH" "$SECOND_CPU_IDLE_PCT_SEQWRITE_BANDWIDTH" \
    "$CMP_SEQREAD_BANDWIDTH" "$CMP_CPU_IDLE_PCT_SEQREAD_BANDWIDTH" \
    "$CMP_SEQWRITE_BANDWIDTH" "$CMP_CPU_IDLE_PCT_SEQWRITE_BANDWIDTH"

add_metrics_to_summary "Latency" "ns" \
    "$FIRST_RANDREAD_LATENCY" "$FIRST_CPU_IDLE_PCT_RANDREAD_LATENCY" \
    "$FIRST_RANDWRITE_LATENCY" "$FIRST_CPU_IDLE_PCT_RANDWRITE_LATENCY" \
    "$SECOND_RANDREAD_LATENCY" "$SECOND_CPU_IDLE_PCT_RANDREAD_LATENCY" \
    "$SECOND_RANDWRITE_LATENCY" "$SECOND_CPU_IDLE_PCT_RANDWRITE_LATENCY" \
    "$CMP_RANDREAD_LATENCY" "$CMP_CPU_IDLE_PCT_RANDREAD_LATENCY" \
    "$CMP_RANDWRITE_LATENCY" "$CMP_CPU_IDLE_PCT_RANDWRITE_LATENCY" \
    "$FIRST_SEQREAD_LATENCY" "$FIRST_CPU_IDLE_PCT_SEQREAD_LATENCY" \
    "$FIRST_SEQWRITE_LATENCY" "$FIRST_CPU_IDLE_PCT_SEQWRITE_LATENCY" \
    "$SECOND_SEQREAD_LATENCY" "$SECOND_CPU_IDLE_PCT_SEQREAD_LATENCY" \
    "$SECOND_SEQWRITE_LATENCY" "$SECOND_CPU_IDLE_PCT_SEQWRITE_LATENCY" \
    "$CMP_SEQREAD_LATENCY" "$CMP_CPU_IDLE_PCT_SEQREAD_LATENCY" \
    "$CMP_SEQWRITE_LATENCY" "$CMP_CPU_IDLE_PCT_SEQWRITE_LATENCY"


echo "$SUMMARY" > $RESULT
cat $RESULT



#!/bin/bash

parse_iops() {
        local OUTPUT_IOPS=$1
        RAND_READ_IOPS=`cat $OUTPUT_IOPS | jq '.jobs[0].read.iops_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`
        RAND_WRITE_IOPS=`cat $OUTPUT_IOPS | jq '.jobs[1].write.iops_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`
        SEQ_READ_IOPS=`cat $OUTPUT_IOPS | jq '.jobs[2].read.iops_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`
        SEQ_WRITE_IOPS=`cat $OUTPUT_IOPS | jq '.jobs[3].write.iops_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`
        CPU_IDLE_PCT_IOPS=`cat $OUTPUT_IOPS | jq '.cpu_idleness.system' | cut -f1 -d.`"%"
}

parse_bw() {
        local OUTPUT_BW=$1
        RAND_READ_BW=`cat $OUTPUT_BW | jq '.jobs[0].read.bw_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`
        RAND_WRITE_BW=`cat $OUTPUT_BW | jq '.jobs[1].write.bw_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`
        SEQ_READ_BW=`cat $OUTPUT_BW | jq '.jobs[2].read.bw_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`
        SEQ_WRITE_BW=`cat $OUTPUT_BW | jq '.jobs[3].write.bw_mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`
        CPU_IDLE_PCT_BW=`cat $OUTPUT_BW| jq '.cpu_idleness.system' | cut -f1 -d.`"%"
}

parse_lat() {
        local OUTPUT_LAT=$1
        RAND_READ_LAT=`cat $OUTPUT_LAT | jq '.jobs[0].read.lat_ns.mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`
        RAND_WRITE_LAT=`cat $OUTPUT_LAT | jq '.jobs[1].write.lat_ns.mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`
        SEQ_READ_LAT=`cat $OUTPUT_LAT | jq '.jobs[2].read.lat_ns.mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`
        SEQ_WRITE_LAT=`cat $OUTPUT_LAT | jq '.jobs[3].write.lat_ns.mean'| sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | cut -f1 -d.`
        CPU_IDLE_PCT_LAT=`cat $OUTPUT_LAT| jq '.cpu_idleness.system' | cut -f1 -d.`"%"
}

FMT="%15s%25s\n"
CMP_FMT="%15s%25s%5s%25s\n"


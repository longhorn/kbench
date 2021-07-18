#!/bin/bash

set -e

if [ -z $1 ];
then
        echo Require test file name
        exit 1
fi

if [ -z $2 ];
then
        echo Require output file prefix
        exit 1
fi

TESTFILE=$1
OUTPUT=$2

fio benchmark.fio --filename=$TESTFILE --output-format=json --output=${OUTPUT}-benchmark.json
fio cpu.fio --idle-prof=percpu --filename=$TESTFILE --output-format=json --output=${OUTPUT}-cpu.json

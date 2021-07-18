#!/bin/bash

set -e

if [ -z $1 ];
then
        echo Require test file name
        exit 1
fi

if [ -z $2 ];
then
        echo Require output file name
        exit 1
fi

TESTFILE=$1
RESULT=$2

fio benchmark.fio --filename=$TESTFILE --output-format=json --output=$RESULT

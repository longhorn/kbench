#!/bin/bash

set -e

if [ -z $1 ];
then
        echo Require output file name
        exit 1
fi

RESULT=$1

fio benchmark.fio --output-format=json --output=$RESULT

#!/bin/bash

set -e

CURRENT_DIR="$(dirname "$(readlink -f "$0")")"
source $CURRENT_DIR/func.sh

if [ -z "FIRST_VOL_NAME" ]; then
	echo Require the first volume name
	exit 1
fi

if [ -z "FIRST_VOL_FILE" ]; then
	echo Require the first volume file location
	exit 1
fi

if [ -z "SECOND_VOL_NAME" ]; then
	echo Require the second volume name
	exit 1
fi

if [ -z "SECOND_VOL_FILE" ]; then
	echo Require the second volume file location
	exit 1
fi

#disable parsing in run.sh
export SKIP_PARSE=1

$CURRENT_DIR/run.sh $FIRST_VOL_FILE $FIRST_VOL_NAME
$CURRENT_DIR/run.sh $SECOND_VOL_FILE $SECOND_VOL_NAME

$CURRENT_DIR/cmp_parse.sh

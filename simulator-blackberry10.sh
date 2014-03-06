#!/bin/bash

if [ -z "$BASH_VERSION" ]; then
	exec bash "$0" "$@"
	exit $?
fi

SRCLOC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "$OSMAND_BUILD_TOOL" ]; then
	OSMAND_BUILD_TOOL=makefile
fi

OSMAND_TARGET_PREFIX="$OSMAND_TARGET_PREFIX" OSMAND_TARGET=simulator-blackberry10-gcc "$SRCLOC/utils/$OSMAND_BUILD_TOOL.sh" "$@"

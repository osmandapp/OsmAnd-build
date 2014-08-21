#!/bin/bash

if [ -z "$BASH_VERSION" ]; then
	echo "Invalid shell, re-running using bash..."
	exec bash "$0" "$@"
	exit $?
fi
SRCLOC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# By default, 'make' is used
if [ -z "$OSMAND_BUILD_TOOL" ]; then
	OSMAND_BUILD_TOOL=makefile
fi

OSMAND_TARGET_PREFIX="$OSMAND_TARGET_PREFIX" OSMAND_CROSSPLATFORM_TARGET=fat-ios-clang "$SRCLOC/utils/$OSMAND_BUILD_TOOL.sh" "$@"

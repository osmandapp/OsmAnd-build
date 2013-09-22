#!/bin/bash

SRCLOC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "$OSMAND_BUILD_TOOL" ]; then
	OSMAND_BUILD_TOOL=makefile
fi

OSMAND_TARGET_PREFIX="$OSMAND_TARGET_PREFIX" OSMAND_TARGET=simulator-ios-clang "$SRCLOC/utils/$OSMAND_BUILD_TOOL.sh" "$@"

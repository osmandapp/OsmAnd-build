#!/bin/bash

SRCLOC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "$OSMAND_BUILD_TOOL" ]; then
	OSMAND_BUILD_TOOL=makefile
fi

JAVA_HOME="`/usr/libexec/java_home`" OSMAND_TARGET_PREFIX="$OSMAND_TARGET_PREFIX" OSMAND_TARGET=x86_64-darwin-clang "$SRCLOC/utils/$OSMAND_BUILD_TOOL.sh" "$@"

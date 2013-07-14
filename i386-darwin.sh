#!/bin/bash
if [ ! -n "$OSMAND_TARGET_PREFIX" ]; then
    SNAME=`basename $0`
    OSMAND_TARGET_PREFIX=${SNAME%.*}
fi
if [ -z "$OSMAND_BUILD_TOOL" ]; then
	OSMAND_BUILD_TOOL=makefile
fi
JAVA_HOME="`/usr/libexec/java_home`" OSMAND_TARGET_PREFIX="$OSMAND_TARGET_PREFIX" OSMAND_TARGET=i386-darwin-clang "$(dirname $0)/utils/$OSMAND_BUILD_TOOL.sh" "$@"

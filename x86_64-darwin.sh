#!/bin/bash
if [ ! -n "$OSMAND_TARGET_PREFIX" ]; then
    SNAME=`basename $0`
    OSMAND_TARGET_PREFIX=${SNAME%.*}
fi
JAVA_HOME="`/usr/libexec/java_home`" OSMAND_TARGET_PREFIX="$OSMAND_TARGET_PREFIX" OSMAND_TARGET=x86_64-darwin-clang "$(dirname $0)/utils/makefile.sh" "$@"

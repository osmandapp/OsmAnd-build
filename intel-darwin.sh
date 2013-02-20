#!/bin/bash
if [ ! -n "$OSMAND_TARGET_PREFIX" ]; then
    SNAME=`basename $0`
    OSMAND_TARGET_PREFIX=${SNAME%.*}
fi
"../core/externals/qtbase-desktop/build.sh"
OSMAND_TARGET_PREFIX="$OSMAND_TARGET_PREFIX" OSMAND_TARGET=intel-darwin-clang "$(dirname $0)/utils/makefile.sh" "$@"
#!/bin/bash

if [ -z "$BASH_VERSION" ]; then
	exec bash "$0" "$@"
	exit $?
fi

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TARGET_BUILD_TOOL_SUFFIX=makefile CMAKE_GENERATOR="Unix Makefiles" "$SCRIPT_LOCATION/common.sh" $*

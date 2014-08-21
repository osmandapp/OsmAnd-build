#!/bin/bash

if [ -z "$BASH_VERSION" ]; then
	echo "Invalid shell, re-running using bash..."
	exec bash "$0" "$@"
	exit $?
fi
SRCLOC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TARGET_BUILD_TOOL_SUFFIX=makefile CMAKE_GENERATOR="Unix Makefiles" "$SRCLOC/generate.sh" $*

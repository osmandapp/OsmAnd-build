#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_TOOL_SUFFIX=makefile CMAKE_GENERATOR="Unix Makefiles" "$SCRIPT_LOCATION/common.sh" $*

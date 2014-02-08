#!/bin/bash

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_TOOL_SUFFIX=xcode CMAKE_GENERATOR="Xcode" "$SCRIPT_LOCATION/common.sh" $*

#!/bin/bash

if [ -z "$BASH_VERSION" ]; then
	echo "Invalid shell, re-running using bash..."
	exec bash "$0" "$@"
	exit $?
fi
SRCLOC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Verify environment
if [[ -n "$OSMAND_TARGET" ]]; then
	echo "Baking project files for native target '${OSMAND_TARGET}'"
	OSMAND_TARGET_SPECIFICATION="-DOSMAND_TARGET=${OSMAND_TARGET}"
	if [[ -f "$SRCLOC/../targets/${OSMAND_TARGET}.sh" ]]; then
		echo "Applying specific settings from 'build/targets/${OSMAND_TARGET}.sh'"
		source "$SRCLOC/../targets/${OSMAND_TARGET}.sh"
	else
		echo "No specific settings found (should be in 'build/targets/${OSMAND_TARGET}.sh')"
	fi
elif [[ -n "$OSMAND_CROSSPLATFORM_TARGET" ]]; then
	echo "Baking project files for cross-platform target '${OSMAND_CROSSPLATFORM_TARGET}'"
	OSMAND_TARGET_SPECIFICATION="-DCMAKE_TOOLCHAIN_FILE=targets/${OSMAND_CROSSPLATFORM_TARGET}.cmake"
else
	echo "OSMAND_TARGET and OSMAND_CROSSPLATFORM_TARGET is not set - one of them needs to be set"
	exit 1
fi

# Configure build type
CMAKE_BUILD_TYPE=""
BUILD_TYPE_SUFFIX=""
if [ -n "$1" ]
then
	case "$1" in
		debug)		CMAKE_BUILD_TYPE="Debug"
					BUILD_TYPE_SUFFIX="debug"
					;;
		release)	CMAKE_BUILD_TYPE="Release"
					BUILD_TYPE_SUFFIX="release"
					;;
		safemode)	CMAKE_BUILD_TYPE="RelWithDebInfo"
					BUILD_TYPE_SUFFIX="safemode"
					;;
	esac
fi
if [ -n "$CMAKE_BUILD_TYPE" ]
then
	echo "Target build mode: $CMAKE_BUILD_TYPE"
	CMAKE_BUILD_TYPE="-DCMAKE_BUILD_TYPE:STRING=$CMAKE_BUILD_TYPE"
	BUILD_TYPE_SUFFIX="-$BUILD_TYPE_SUFFIX"
fi

# Specific CPU configuration
OSMAND_CPU_SPECIFIC_DEFINE=""
CPU_SPECIFIC_SUFFIX=""
if [ -n "$OSMAND_SPECIFIC_CPU_NAME" ]; then
	echo "Specific CPU: ${OSMAND_SPECIFIC_CPU_NAME}"
	OSMAND_CPU_SPECIFIC_DEFINE="-DCMAKE_SPECIFIC_CPU_NAME:STRING=${OSMAND_SPECIFIC_CPU_NAME}"
	CPU_SPECIFIC_SUFFIX="-${OSMAND_SPECIFIC_CPU_NAME}"
fi

# Get target prefix
TARGET_PREFIX=""
if [ -n "$OSMAND_TARGET_PREFIX" ]; then
	TARGET_PREFIX="${OSMAND_TARGET_PREFIX}-"
fi

# Check for specific compiler selected
if [[ -n "$OSMAND_CC" ]]; then
	echo "Using specific C compiler: ${OSMAND_CC}"
	export CC=$OSMAND_CC
fi
if [[ -n "$OSMAND_CXX" ]]; then
	echo "Using specific C++ compiler: ${OSMAND_CXX}"
	export CXX=$OSMAND_CXX
fi

WORK_ROOT="$SRCLOC/.."
if [[ "$(uname -a)" =~ Cygwin ]]; then
	WORK_ROOT=$(cygpath -w "$WORK_ROOT")
fi

BAKED_NAME=""
if [[ -n "$OSMAND_TARGET" ]]; then
	BAKED_NAME="${TARGET_PREFIX}${OSMAND_TARGET}${CPU_SPECIFIC_SUFFIX}${BUILD_TYPE_SUFFIX}.${TARGET_BUILD_TOOL_SUFFIX}"
elif [[ -n "$OSMAND_CROSSPLATFORM_TARGET" ]]; then
	BAKED_NAME="${TARGET_PREFIX}${OSMAND_CROSSPLATFORM_TARGET}${CPU_SPECIFIC_SUFFIX}${BUILD_TYPE_SUFFIX}.${TARGET_BUILD_TOOL_SUFFIX}"
fi
echo "Baking project files '${BAKED_NAME}'"
BAKED_DIR="${SRCLOC}/../../baked/${BAKED_NAME}"
if [[ -d "$BAKED_DIR" ]]; then
	#rm -rf "$BAKED_DIR"
    echo "Possibly baked dir $BAKED_DIR needs to be deleted."
fi
mkdir -p "$BAKED_DIR"
echo "To trace errors with cmake set ENV_VARIABLE OSMAND_CMAKE_EXTRA_OPTS=--trace-expand"
(cd "$BAKED_DIR" && \
	cmake $OSMAND_CMAKE_EXTRA_OPTS -G "$CMAKE_GENERATOR" \
		-DCMAKE_TARGET_BUILD_TOOL:STRING=$TARGET_BUILD_TOOL_SUFFIX \
		$OSMAND_TARGET_SPECIFICATION \
		$CMAKE_BUILD_TYPE \
		$OSMAND_CPU_SPECIFIC_DEFINE \
		"$WORK_ROOT")
retcode=$?
if [ $retcode -ne 0 ]; then
	echo "Failed to bake project files '${BAKED_NAME}' ($retcode)"
	#rm -rf "$BAKED_DIR"
	exit $retcode
fi
exit 0

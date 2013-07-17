cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)

set(OSMAND_ROOT "${CMAKE_CURRENT_LIST_DIR}/..")

# Output paths
set(OSMAND_OUTPUT_ROOT "${OSMAND_ROOT}/binaries/${CMAKE_TARGET_OS}/${CMAKE_TARGET_CPU_ARCH}/${CMAKE_TARGET_CPU_NAME}/${CMAKE_BUILD_TYPE}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${OSMAND_OUTPUT_ROOT}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${OSMAND_OUTPUT_ROOT}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${OSMAND_OUTPUT_ROOT}")

# For gcc family, ensure that there are no undefined symbols
if(CMAKE_COMPILER_FAMILY STREQUAL "gcc")
	set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--no-undefined")
	set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--no-undefined")
endif()

# For gcc and clang, allow all warnings
if(CMAKE_COMPILER_FAMILY STREQUAL "gcc" OR CMAKE_COMPILER_FAMILY STREQUAL "clang")
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -fPIC")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -fPIC")
endif()

# Include CPU specific settings
if(DEFINED CMAKE_TARGET_CPU_NAME)
	include("cpu-specific/${CMAKE_TARGET_CPU_NAME}.cmake")
endif()

# Declare what target we have
add_definitions(-DOSMAND_TARGET_OS_${CMAKE_TARGET_OS})

# Target specific changes
if(CMAKE_TARGET_OS STREQUAL "linux")
elseif(CMAKE_TARGET_OS STREQUAL "darwin")
elseif(CMAKE_TARGET_OS STREQUAL "windows")
	if(MSVC)
		add_definitions(-DUNICODE -D_UNICODE -D_VARIADIC_MAX=10)
	endif()
endif()

# Don't define min and max macros
add_definitions(-DNOMINMAX)

# Extend modules search path (Qt)
if(DEFINED ENV{OSMAND_QT})
	message("Using Qt5: $ENV{OSMAND_QT}")
	list(APPEND CMAKE_PREFIX_PATH "$ENV{OSMAND_QT}/lib/cmake")
else()
	if(CMAKE_TARGET_OS STREQUAL "linux" OR CMAKE_TARGET_OS STREQUAL "darwin" OR CMAKE_TARGET_OS STREQUAL "windows")
		set(OSMAND_QT_FLAVOUR "desktop")
	elseif(CMAKE_TARGET_OS STREQUAL "ios")
		set(OSMAND_QT_FLAVOUR "ios")
	else()
		message(FATAL_ERROR "Failed to determine Qt flavour")
	endif()

	if(EXISTS "${OSMAND_ROOT}/core/externals/qtbase-${OSMAND_QT_FLAVOUR}/upstream.patched.${CMAKE_TARGET_OS}/lib/cmake")
		message("Using bundled Qt5: ${OSMAND_ROOT}/core/externals/qtbase-${OSMAND_QT_FLAVOUR}/upstream.patched.${CMAKE_TARGET_OS}")
		list(APPEND CMAKE_PREFIX_PATH "${OSMAND_ROOT}/core/externals/qtbase-${OSMAND_QT_FLAVOUR}/upstream.patched.${CMAKE_TARGET_OS}/lib/cmake")
	endif()
	if(EXISTS "${OSMAND_ROOT}/core/externals/qtbase-${OSMAND_QT_FLAVOUR}/upstream.patched.${CMAKE_TARGET_OS}.${CMAKE_TARGET_CPU_ARCH}/lib/cmake")
		message("Using bundled Qt5: ${OSMAND_ROOT}/core/externals/qtbase-${OSMAND_QT_FLAVOUR}/upstream.patched.${CMAKE_TARGET_OS}.${CMAKE_TARGET_CPU_ARCH}")
		list(APPEND CMAKE_PREFIX_PATH "${OSMAND_ROOT}/core/externals/qtbase-${OSMAND_QT_FLAVOUR}/upstream.patched.${CMAKE_TARGET_OS}.${CMAKE_TARGET_CPU_ARCH}/lib/cmake")
	endif()
endif()

# Core
if(EXISTS "${OSMAND_ROOT}/core")
	include("${OSMAND_ROOT}/core/core.cmake")
endif()

# JNI is only valid on platforms where Java exists
if(CMAKE_TARGET_OS STREQUAL "linux" OR CMAKE_TARGET_OS STREQUAL "darwin" OR CMAKE_TARGET_OS STREQUAL "windows" OR CMAKE_TARGET_OS STREQUAL "android")
	if(EXISTS "${OSMAND_ROOT}/jni")
		include("${OSMAND_ROOT}/jni/jni.cmake")
	endif()
endif()

# Tools are only valid on desktop platforms
if(CMAKE_TARGET_OS STREQUAL "linux" OR CMAKE_TARGET_OS STREQUAL "darwin" OR CMAKE_TARGET_OS STREQUAL "windows")
	if(EXISTS "${OSMAND_ROOT}/tools")
		include("${OSMAND_ROOT}/tools/tools.cmake")
	endif()
endif()

cmake_minimum_required(VERSION 2.8.7 FATAL_ERROR)

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
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")
endif()

# Include CPU specific settings
if(DEFINED CMAKE_TARGET_CPU_NAME)
	include("cpu-specific/${CMAKE_TARGET_CPU_NAME}.cmake")
endif()

# Take CMAKE_*_COMPILER_FLAGS if needed
if(CMAKE_C_COMPILER_FLAGS)
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_C_COMPILER_FLAGS}")
endif()
if(CMAKE_CXX_COMPILER_FLAGS)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_COMPILER_FLAGS}")
endif()

# Extend modules search path
if(EXISTS "${OSMAND_ROOT}/core/externals/qtbase-desktop/upstream.patched.${CMAKE_TARGET_OS}/lib/cmake")
	list(APPEND CMAKE_PREFIX_PATH "${OSMAND_ROOT}/core/externals/qtbase-desktop/upstream.patched.${CMAKE_TARGET_OS}/lib/cmake")
endif()

# Core
if(EXISTS "${OSMAND_ROOT}/core")
	include("${OSMAND_ROOT}/core/core.cmake")
endif()

# Tools
if(EXISTS "${OSMAND_ROOT}/tools")
	include("${OSMAND_ROOT}/tools/tools.cmake")
endif()
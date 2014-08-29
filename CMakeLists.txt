cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)

# Set the global project name
project("OsmAnd_projects")

set(OSMAND_ROOT "${CMAKE_CURRENT_LIST_DIR}/..")

# Import target settings if specified
if (DEFINED OSMAND_TARGET)
	message("Using '${OSMAND_TARGET}' target settings")
	include("${OSMAND_ROOT}/build/targets/${OSMAND_TARGET}.cmake")
else()
	message("Using cross-platform target settings from toolchain file '${CMAKE_TOOLCHAIN_FILE}'")
endif()

# Output paths
if (CMAKE_TARGET_BUILD_TOOL STREQUAL "msvs" OR
	CMAKE_TARGET_BUILD_TOOL STREQUAL "make" OR
	CMAKE_TARGET_BUILD_TOOL STREQUAL "nmake")
	set(OSMAND_OUTPUT_ROOT "${OSMAND_ROOT}/binaries/${CMAKE_TARGET_OS}/${CMAKE_COMPILER_FAMILY}-${CMAKE_TARGET_CPU_ARCH}/${CMAKE_TARGET_CPU_NAME}/${CMAKE_BUILD_TYPE}")
elseif (CMAKE_TARGET_BUILD_TOOL STREQUAL "xcode")
	set(OSMAND_OUTPUT_ROOT "${OSMAND_ROOT}/binaries/${CMAKE_TARGET_OS}.${CMAKE_COMPILER_FAMILY}$(EFFECTIVE_PLATFORM_NAME)")
endif()
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${OSMAND_OUTPUT_ROOT}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${OSMAND_OUTPUT_ROOT}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${OSMAND_OUTPUT_ROOT}")

# Enable languages
enable_language(C)
enable_language(CXX)
enable_language(ASM OPTIONAL)

# For gcc family, ensure that there are no undefined symbols
if (CMAKE_COMPILER_FAMILY STREQUAL "gcc")
	set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--no-undefined")
	set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--no-undefined")
endif()

# Use proper optimization for gcc and clang
if (CMAKE_COMPILER_FAMILY STREQUAL "gcc" OR CMAKE_COMPILER_FAMILY STREQUAL "clang")
	set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -fPIC")
	set(CMAKE_ASM_FLAGS_DEBUG "-O0 -g")
	set(CMAKE_ASM_FLAGS_RELWITHDEBINFO "-O3 -g")
	set(CMAKE_ASM_FLAGS_RELEASE "-O3")

	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
	set(CMAKE_C_FLAGS_DEBUG "-O0 -g")
	set(CMAKE_C_FLAGS_RELWITHDEBINFO "-O3 -g")
	set(CMAKE_C_FLAGS_RELEASE "-O3")

	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
	set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g")
	set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O3 -g")
	set(CMAKE_CXX_FLAGS_RELEASE "-O3")
endif()

# Tune MSVC compiler
if (CMAKE_COMPILER_FAMILY STREQUAL "msvc")
	add_definitions(-DUNICODE -D_UNICODE -D_VARIADIC_MAX=10 -D__STDC_FORMAT_MACROS)
endif()

# Add definitions to mark built type
set(CMAKE_ASM_FLAGS_DEBUG "${CMAKE_ASM_FLAGS_DEBUG} -DDEBUG -D_DEBUG")
set(CMAKE_ASM_FLAGS_RELWITHDEBINFO "${CMAKE_ASM_FLAGS_RELWITHDEBINFO} -DRELEASE -DNDEBUG")
set(CMAKE_ASM_FLAGS_RELEASE "${CMAKE_ASM_FLAGS_RELEASE} -DRELEASE -DNDEBUG")

set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -DDEBUG -D_DEBUG")
set(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO} -DRELEASE -DNDEBUG")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -DRELEASE -DNDEBUG")

set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DDEBUG -D_DEBUG")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -DRELEASE -DNDEBUG")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -DRELEASE -DNDEBUG")

# Include CPU specific settings
if (DEFINED CMAKE_TARGET_CPU_NAME)
	include("cpu-specific/${CMAKE_TARGET_CPU_NAME}.cmake")
endif()

# Expose target environment to code
add_definitions(
	-DOSMAND_TARGET_OS_${CMAKE_TARGET_OS}
	-DOSMAND_TARGET_CPU_ARCH_${CMAKE_TARGET_CPU_ARCH}
	-DOSMAND_TARGET_CPU_ARCH_FAMILY_${CMAKE_TARGET_CPU_ARCH_FAMILY}
	-DOSMAND_COMPILER_FAMILY_${CMAKE_COMPILER_FAMILY}
)

# Target specific changes
if (CMAKE_TARGET_OS STREQUAL "linux")
elseif (CMAKE_TARGET_OS STREQUAL "macosx")
elseif (CMAKE_TARGET_OS STREQUAL "windows")
elseif (CMAKE_TARGET_OS STREQUAL "qnx")
	include_directories(AFTER
		${QNX_TARGET}/usr/include/freetype2
	)
endif()

# Don't define min and max macros
add_definitions(-DNOMINMAX)

# Common utilities
include("${OSMAND_ROOT}/build/utils/common.cmake")

# Qt
include("${OSMAND_ROOT}/build/qt.cmake")

# Target extras
if (EXISTS "${OSMAND_ROOT}/build/extras/${CMAKE_TARGET_OS}.cmake")
	include("${OSMAND_ROOT}/build/extras/${CMAKE_TARGET_OS}.cmake")
endif()

# Core
if (EXISTS "${OSMAND_ROOT}/core")
	include("${OSMAND_ROOT}/core/core.cmake")
endif()

# Tools are only valid on desktop platforms
if (CMAKE_TARGET_OS STREQUAL "linux" OR CMAKE_TARGET_OS STREQUAL "macosx" OR CMAKE_TARGET_OS STREQUAL "windows")
	if (EXISTS "${OSMAND_ROOT}/tools")
		include("${OSMAND_ROOT}/tools/tools.cmake")
	endif()
endif()

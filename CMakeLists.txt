cmake_minimum_required(VERSION 3.0 FATAL_ERROR)

# Set the global project name
project("OsmAnd_projects")

set(OSMAND_ROOT "${CMAKE_CURRENT_LIST_DIR}/..")

# Import target settings if specified
if (DEFINED OSMAND_TARGET)
	message("Using '${OSMAND_TARGET}' target settings")
	include("${OSMAND_ROOT}/build/targets/${OSMAND_TARGET}.cmake")
elseif (DEFINED CMAKE_TOOLCHAIN_FILE)
	message("Using cross-platform target settings from toolchain file '${CMAKE_TOOLCHAIN_FILE}'")
else()
	message("Nor OSMAND_TARGET nor CMAKE_TOOLCHAIN_FILE was set, trying to determine build environment:")

	# CMAKE_TARGET_BUILD_TOOL from CMAKE_BUILD_TOOL
	if (CMAKE_BUILD_TOOL MATCHES "[^A-Za-z]?make[^A-Za-z]?")
		set(CMAKE_TARGET_BUILD_TOOL "make")
	elseif (CMAKE_BUILD_TOOL STREQUAL "[^A-Za-z]?nmake[^A-Za-z]?")
		set(CMAKE_TARGET_BUILD_TOOL "nmake")
	elseif (CMAKE_BUILD_TOOL STREQUAL "[^A-Za-z]?xcodebuild[^A-Za-z]?")
		set(CMAKE_TARGET_BUILD_TOOL "xcode")
	elseif (CMAKE_BUILD_TOOL STREQUAL "[^A-Za-z]?MSBuild[^A-Za-z]?")
		set(CMAKE_TARGET_BUILD_TOOL "msvs")
	else()
		message(FATAL_ERROR "Unsupported CMAKE_BUILD_TOOL '${CMAKE_BUILD_TOOL}'")
	endif()

	# CMAKE_TARGET_OS from various variables
	if (UNIX AND NOT APPLE AND NOT CYGWIN)
		set(CMAKE_TARGET_OS linux)
	elseif (APPLE)
		set(CMAKE_TARGET_OS macosx)
	elseif ((WIN32 AND NOT CYGWIN) OR MSYS)
		set(CMAKE_TARGET_OS windows)
	elseif (CYGWIN)
		set(CMAKE_TARGET_OS cygwin)
	else()
		message(FATAL_ERROR "Unsupported host environment")
	endif()

	# CMAKE_TARGET_CPU_ARCH
	set(CMAKE_TARGET_CPU_ARCH i686)
	
	# CMAKE_TARGET_CPU_ARCH_FAMILY
	set(CMAKE_TARGET_CPU_ARCH_FAMILY x86)
	
	# CMAKE_SHARED_LIBS_ALLOWED_ON_TARGET and CMAKE_STATIC_LIBS_ALLOWED_ON_TARGET are probably true
	set(CMAKE_SHARED_LIBS_ALLOWED_ON_TARGET ON)
	set(CMAKE_STATIC_LIBS_ALLOWED_ON_TARGET ON)

	# CMAKE_COMPILER_FAMILY from CMAKE_CXX_COMPILER_ID
	if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
		set(CMAKE_COMPILER_FAMILY clang)
	elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
		set(CMAKE_COMPILER_FAMILY gcc)
	elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
		set(CMAKE_COMPILER_FAMILY msvc)
	else()
		message(FATAL_ERROR "Unsupported compiler ID '${CMAKE_CXX_COMPILER_ID}'")
	endif()

	# Additional settings
	if (CMAKE_COMPILER_FAMILY STREQUAL "gcc" OR
	    CMAKE_COMPILER_FAMILY STREQUAL "clang")

	    if (CMAKE_TARGET_OS STREQUAL "linux" OR
	        CMAKE_TARGET_OS STREQUAL "windows" OR
	        CMAKE_TARGET_OS STREQUAL "cygwin")
	        if (CMAKE_TARGET_CPU_ARCH STREQUAL "i686")
	            set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -m32")
                set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32")
                set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32")
	        endif()
        endif()
		
		if (CMAKE_TARGET_OS STREQUAL "windows")
			set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -mdll -static-libgcc -static-libstdc++")
			set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -static-libgcc -static-libstdc++")
			set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -mconsole -static-libgcc -static-libstdc++")
        endif()
	endif()
endif()
message("CMAKE_TARGET_OS = ${CMAKE_TARGET_OS}")
message("CMAKE_TARGET_CPU_ARCH = ${CMAKE_TARGET_CPU_ARCH}")
message("CMAKE_TARGET_CPU_ARCH_FAMILY = ${CMAKE_TARGET_CPU_ARCH_FAMILY}")
message("CMAKE_SHARED_LIBS_ALLOWED_ON_TARGET = ${CMAKE_SHARED_LIBS_ALLOWED_ON_TARGET}")
message("CMAKE_STATIC_LIBS_ALLOWED_ON_TARGET = ${CMAKE_STATIC_LIBS_ALLOWED_ON_TARGET}")
message("CMAKE_COMPILER_FAMILY = ${CMAKE_COMPILER_FAMILY}")

# Don't use RPATH for build or install
set(CMAKE_SKIP_RPATH ON)
set(CMAKE_SKIP_INSTALL_RPATH ON)
set(CMAKE_MACOSX_RPATH OFF)

# Output paths
if (CMAKE_TARGET_BUILD_TOOL STREQUAL "xcode" AND
	CMAKE_TARGET_OS STREQUAL "ios")
	set(OSMAND_OUTPUT_ROOT "${OSMAND_ROOT}/binaries/${CMAKE_TARGET_OS}.${CMAKE_COMPILER_FAMILY}$(EFFECTIVE_PLATFORM_NAME)")
elseif (CMAKE_TARGET_BUILD_TOOL STREQUAL "xcode" OR CMAKE_TARGET_BUILD_TOOL STREQUAL "msvs")
	set(OSMAND_OUTPUT_ROOT "${OSMAND_ROOT}/binaries/${CMAKE_TARGET_OS}/${CMAKE_COMPILER_FAMILY}-${CMAKE_TARGET_CPU_ARCH}/${CMAKE_TARGET_CPU_NAME}")
else()
	set(OSMAND_OUTPUT_ROOT "${OSMAND_ROOT}/binaries/${CMAKE_TARGET_OS}/${CMAKE_COMPILER_FAMILY}-${CMAKE_TARGET_CPU_ARCH}/${CMAKE_TARGET_CPU_NAME}/${CMAKE_BUILD_TYPE}")
endif()
message("OSMAND_OUTPUT_ROOT = ${OSMAND_OUTPUT_ROOT}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${OSMAND_OUTPUT_ROOT}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${OSMAND_OUTPUT_ROOT}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${OSMAND_OUTPUT_ROOT}")

# Enable languages
enable_language(C)
enable_language(CXX)
enable_language(ASM OPTIONAL)

# For gcc and clang family, use C++11 
if (CMAKE_COMPILER_FAMILY STREQUAL "gcc" OR CMAKE_COMPILER_FAMILY STREQUAL "clang")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++11")
endif()

# For gcc and clang family, ensure that there are no undefined symbols
if ((CMAKE_COMPILER_FAMILY STREQUAL "gcc" OR CMAKE_COMPILER_FAMILY STREQUAL "clang") AND
	(CMAKE_TARGET_OS STREQUAL "linux" OR CMAKE_TARGET_OS STREQUAL "android"))
	set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--no-undefined")
	set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -Wl,--no-undefined")
	set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--no-undefined")
endif()

# For gcc and clang family, by default hide all symbols
if (CMAKE_COMPILER_FAMILY STREQUAL "gcc" OR CMAKE_COMPILER_FAMILY STREQUAL "clang")
	set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -fvisibility=hidden")
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fvisibility=hidden")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden -fvisibility-inlines-hidden")
endif()

# Use proper optimization for gcc and clang
if (CMAKE_COMPILER_FAMILY STREQUAL "gcc" OR CMAKE_COMPILER_FAMILY STREQUAL "clang")
	set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS}")
	set(CMAKE_ASM_FLAGS_DEBUG "${CMAKE_ASM_FLAGS_DEBUG} -O0 -g")
	set(CMAKE_ASM_FLAGS_RELWITHDEBINFO "${CMAKE_ASM_FLAGS_RELWITHDEBINFO} -O3 -g")
	set(CMAKE_ASM_FLAGS_RELEASE "${CMAKE_ASM_FLAGS_RELEASE} -O3")

	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
	set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0 -g")
	set(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO} -O3 -g")
	set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3")

	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
	set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0 -g")
	set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -O3 -g")
	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3")
endif()

# Strip as much as possible in release builds
if (CMAKE_COMPILER_FAMILY STREQUAL "gcc" OR CMAKE_COMPILER_FAMILY STREQUAL "clang")
	set(CMAKE_ASM_FLAGS_RELEASE "${CMAKE_ASM_FLAGS_RELEASE} -fdata-sections -ffunction-sections")
	set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -fdata-sections -ffunction-sections")
	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -fdata-sections -ffunction-sections")
endif()
if ((CMAKE_COMPILER_FAMILY STREQUAL "gcc" OR CMAKE_COMPILER_FAMILY STREQUAL "clang") AND
	(CMAKE_TARGET_OS STREQUAL "linux" OR CMAKE_TARGET_OS STREQUAL "android"))
	set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} -Wl,--gc-sections -Wl,-S")
	set(CMAKE_MODULE_LINKER_FLAGS_RELEASE "${CMAKE_MODULE_LINKER_FLAGS_RELEASE} -Wl,--gc-sections -Wl,-S")
	set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} -Wl,--gc-sections -Wl,-S")
endif()
if ((CMAKE_COMPILER_FAMILY STREQUAL "gcc" OR CMAKE_COMPILER_FAMILY STREQUAL "clang") AND
	(CMAKE_TARGET_OS STREQUAL "macosx" OR CMAKE_TARGET_OS STREQUAL "ios"))
	set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} -Wl,-dead_strip")
	set(CMAKE_MODULE_LINKER_FLAGS_RELEASE "${CMAKE_MODULE_LINKER_FLAGS_RELEASE} -Wl,-dead_strip")
	set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} -Wl,-dead_strip")
endif()

if ((CMAKE_COMPILER_FAMILY STREQUAL "msvc") OR
	(CMAKE_TARGET_OS STREQUAL "windows" AND CMAKE_COMPILER_FAMILY STREQUAL "gcc"))
	add_definitions(-D_VARIADIC_MAX=10)
endif()
if (CMAKE_TARGET_OS STREQUAL "windows" AND CMAKE_COMPILER_FAMILY STREQUAL "gcc")
	add_definitions(-DMINGW_HAS_SECURE_API=1)
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
string(REGEX REPLACE "[^A-Za-z0-9_]" "_" purified_CMAKE_TARGET_OS ${CMAKE_TARGET_OS})
string(REGEX REPLACE "[^A-Za-z0-9_]" "_" purified_CMAKE_TARGET_CPU_ARCH ${CMAKE_TARGET_CPU_ARCH})
string(REGEX REPLACE "[^A-Za-z0-9_]" "_" purified_CMAKE_TARGET_CPU_ARCH_FAMILY ${CMAKE_TARGET_CPU_ARCH_FAMILY})
string(REGEX REPLACE "[^A-Za-z0-9_]" "_" purified_CMAKE_COMPILER_FAMILY ${CMAKE_COMPILER_FAMILY})
add_definitions(
	-DOSMAND_TARGET_OS_${purified_CMAKE_TARGET_OS}
	-DOSMAND_TARGET_CPU_ARCH_${purified_CMAKE_TARGET_CPU_ARCH}
	-DOSMAND_TARGET_CPU_ARCH_FAMILY_${purified_CMAKE_TARGET_CPU_ARCH_FAMILY}
	-DOSMAND_COMPILER_FAMILY_${purified_CMAKE_COMPILER_FAMILY}
)

# Target specific changes
if (CMAKE_TARGET_OS STREQUAL "linux")
elseif (CMAKE_TARGET_OS STREQUAL "macosx")
elseif (CMAKE_TARGET_OS STREQUAL "windows")
	# Unicode by default, Windows Vista minimum required
	add_definitions(-DWINVER=0x0600 -D_WIN32_WINNT=0x0600)
	add_definitions(-DUNICODE -D_UNICODE)
elseif (CMAKE_TARGET_OS STREQUAL "qnx")
	include_directories(AFTER
		"${QNX_TARGET}/usr/include/freetype2"
	)
endif()

# Adjust some global settings:
# - Don't define min and max macros
# - Define PRIu64 and etc.
add_definitions(
	-DNOMINMAX
	-D__STDC_FORMAT_MACROS=1)

message("CMAKE_ASM_FLAGS = ${CMAKE_ASM_FLAGS}")
message("CMAKE_C_FLAGS = ${CMAKE_C_FLAGS}")
message("CMAKE_CXX_FLAGS = ${CMAKE_CXX_FLAGS}")

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

# Resources
if (EXISTS "${OSMAND_ROOT}/resources")
	include("${OSMAND_ROOT}/resources/resources.cmake")
endif()

# Tools are only valid on desktop platforms
if (CMAKE_TARGET_OS STREQUAL "linux" OR
    CMAKE_TARGET_OS STREQUAL "macosx" OR
    CMAKE_TARGET_OS STREQUAL "windows")
	if (EXISTS "${OSMAND_ROOT}/tools")
		include("${OSMAND_ROOT}/tools/tools.cmake")
	endif()
endif()

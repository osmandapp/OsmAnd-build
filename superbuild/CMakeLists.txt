cmake_minimum_required(VERSION 3.0)

project(superbuild)

include(ExternalProject)

set(GeographicLib_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/geographiclib-prefix")

#    URL https://sourceforge.net/projects/geographiclib/files/distrib/GeographicLib-1.46.tar.gz/download
ExternalProject_Add(geographiclib
	URL http://builder.osmand.net/dependencies-mirror/geographiclib-1.46.tar.gz
	PATCH_COMMAND patch src/DMS.cpp < ${CMAKE_CURRENT_LIST_DIR}/geographiclib/0-custom-delimiters.patch
	CMAKE_ARGS
		-DBUILD_SHARED_LIBS:BOOL=ON
		-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
		-DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
		-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_BINARY_DIR}
		-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
		-DBUILD_NETGEOGRAPHICLIB:BOOL=OFF
		-DGEOGRAPHICLIB_DOCUMENTATION:BOOL=OFF
		-DGEOGRAPHICLIB_LIB_TYPE:STRING=STATIC
)

# Hint: set  MAKEFLAGS='-j5' variable for faster build on 4 kernels
ExternalProject_Add(main
	DOWNLOAD_COMMAND ""
	BUILD_COMMAND ${CMAKE_MAKE_PROGRAM} ${MAKEFLAGS}
	INSTALL_COMMAND ""
	SOURCE_DIR ${PROJECT_SOURCE_DIR}/..
	DEPENDS geographiclib
	STEP_TARGETS OsmAndCore_shared_standalone
	CMAKE_ARGS
		-DHAVE_LZMA_H:INTERNAL=
		-DOSMAND_TARGET:STRING=${OSMAND_TARGET}
		-DCMAKE_MODULE_PATH:PATH=${GeographicLib_PREFIX}/src/geographiclib-build
		-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
)


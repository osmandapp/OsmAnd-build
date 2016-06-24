cmake_minimum_required(VERSION 3.0)

project(superbuild)

include(ExternalProject)

set(GeographicLib_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/geographiclib-prefix")

#    URL https://sourceforge.net/projects/geographiclib/files/distrib/GeographicLib-1.46.tar.gz/download
ExternalProject_Add(geographiclib
    PREFIX ${GeographicLib_PREFIX}
    URL http://builder.osmand.net/dependencies-mirror/geographiclib-1.46.tar.gz
    PATCH_COMMAND patch src/DMS.cpp < ${CMAKE_CURRENT_LIST_DIR}/geographiclib/0-custom-delimiters.patch
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_BINARY_DIR}
        -DBUILD_SHARED_LIBS:BOOL=ON
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -DGEOGRAPHICLIB_LIB_TYPE:STRING=STATIC
        -DGEOGRAPHICLIB_DOCUMENTATION:BOOL=OFF
        -DBUILD_NETGEOGRAPHICLIB:BOOL=OFF
)

#    Use export MAKEFLAGS='-j5' to get the same result as with supplying:
#    BUILD_COMMAND make -j5
ExternalProject_Add(main
    DOWNLOAD_COMMAND ""
    INSTALL_COMMAND ""
    SOURCE_DIR ${PROJECT_SOURCE_DIR}/..
	DEPENDS geographiclib
    CMAKE_ARGS
        -DHAVE_LZMA_H:INTERNAL=
        -DOSMAND_TARGET:STRING=${OSMAND_TARGET}
        -DCMAKE_PREFIX_PATH:PATH=${GeographicLib_PREFIX}/src/geographiclib-build
        --target OsmAndCore_shared_standalone
)

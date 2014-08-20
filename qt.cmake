# Qt selection: external, system or embedded
if (DEFINED ENV{OSMAND_EXTERNAL_QT})
	# External
	set(OSMAND_EXTERNAL_QT ON)
	message("Using external Qt5: $ENV{OSMAND_EXTERNAL_QT}")
	list(APPEND CMAKE_PREFIX_PATH "$ENV{OSMAND_EXTERNAL_QT}/lib/cmake")
elseif (DEFINED ENV{OSMAND_SYSTEM_QT})
	# System
	set(OSMAND_SYSTEM_QT ON)
	message("Using system Qt5.")
else()
	# Embedded: shared and static
	set(OSMAND_EMBEDDED_QT ON)

	# Flavour: desktop, iOS or etc.
	if (CMAKE_TARGET_OS STREQUAL "linux" OR CMAKE_TARGET_OS STREQUAL "macosx" OR CMAKE_TARGET_OS STREQUAL "windows")
		set(OSMAND_QT_FLAVOUR "desktop")
	elseif (CMAKE_TARGET_OS STREQUAL "ios")
		set(OSMAND_QT_FLAVOUR "ios")
	else()
		message(FATAL_ERROR "Failed to determine Qt flavour")
	endif()

	# Since Qt is also an upstream, configure it and build
	set(QT_WAS_CONFIGURED -1)
	prepare_upstream_ex("${OSMAND_ROOT}/core/externals/qtbase-${OSMAND_QT_FLAVOUR}" QT_WAS_CONFIGURED)
	if (QT_WAS_CONFIGURED)
		if (CMAKE_HOST_WIN32 AND NOT CYGWIN)
			execute_process(
				COMMAND cmd /C "build.bat ${CMAKE_TARGET_OS} ${CMAKE_COMPILER_FAMILY} ${CMAKE_TARGET_CPU_ARCH}"
				WORKING_DIRECTORY "${OSMAND_ROOT}/core/externals/qtbase-${OSMAND_QT_FLAVOUR}"
				RESULT_VARIABLE EMBEDDED_QT_BUILD_RESULT)
		else()
			execute_process(
				COMMAND "./build.sh ${CMAKE_TARGET_OS} ${CMAKE_COMPILER_FAMILY} ${CMAKE_TARGET_CPU_ARCH}"
				WORKING_DIRECTORY "${OSMAND_ROOT}/core/externals/qtbase-${OSMAND_QT_FLAVOUR}"
				RESULT_VARIABLE EMBEDDED_QT_BUILD_RESULT)
		endif()
		
		if (EMBEDDED_QT_BUILD_RESULT)
			message(FATAL_ERROR "Failed to build embedded Qt for ${CMAKE_TARGET_OS}/${CMAKE_COMPILER_FAMILY}/${CMAKE_TARGET_CPU_ARCH}")
		endif()
	endif()

	# If shared libs are allowed, they need shared Qt
	if (CMAKE_SHARED_LIBS_ALLOWED_ON_TARGET)
		if (EXISTS "${OSMAND_ROOT}/core/externals/qtbase-${OSMAND_QT_FLAVOUR}/upstream.patched.${CMAKE_TARGET_OS}.${CMAKE_COMPILER_FAMILY}-${CMAKE_TARGET_CPU_ARCH}.shared/lib/cmake")
			set(OSMAND_EMBEDDED_QT_SHARED "${OSMAND_ROOT}/core/externals/qtbase-${OSMAND_QT_FLAVOUR}/upstream.patched.${CMAKE_TARGET_OS}.${CMAKE_COMPILER_FAMILY}-${CMAKE_TARGET_CPU_ARCH}.shared")
		elseif (EXISTS "${OSMAND_ROOT}/core/externals/qtbase-${OSMAND_QT_FLAVOUR}/upstream.patched.${CMAKE_TARGET_OS}.${CMAKE_COMPILER_FAMILY}.shared/lib/cmake")
			set(OSMAND_EMBEDDED_QT_SHARED "${OSMAND_ROOT}/core/externals/qtbase-${OSMAND_QT_FLAVOUR}/upstream.patched.${CMAKE_TARGET_OS}.${CMAKE_COMPILER_FAMILY}.shared")
		endif()

		if (NOT DEFINED OSMAND_EMBEDDED_QT_SHARED)
			message(FATAL_ERROR "Embedded shared Qt not found")
		else()
			message("Using embedded Qt5 (shared): ${OSMAND_EMBEDDED_QT_SHARED}")
		endif()
	endif()

	# If static libs are allowed, they need static Qt
	if (CMAKE_STATIC_LIBS_ALLOWED_ON_TARGET)
		if (EXISTS "${OSMAND_ROOT}/core/externals/qtbase-${OSMAND_QT_FLAVOUR}/upstream.patched.${CMAKE_TARGET_OS}.${CMAKE_COMPILER_FAMILY}-${CMAKE_TARGET_CPU_ARCH}.static/lib/cmake")
			set(OSMAND_EMBEDDED_QT_STATIC "${OSMAND_ROOT}/core/externals/qtbase-${OSMAND_QT_FLAVOUR}/upstream.patched.${CMAKE_TARGET_OS}.${CMAKE_COMPILER_FAMILY}-${CMAKE_TARGET_CPU_ARCH}.static")
		elseif (EXISTS "${OSMAND_ROOT}/core/externals/qtbase-${OSMAND_QT_FLAVOUR}/upstream.patched.${CMAKE_TARGET_OS}.${CMAKE_COMPILER_FAMILY}.static/lib/cmake")
			set(OSMAND_EMBEDDED_QT_STATIC "${OSMAND_ROOT}/core/externals/qtbase-${OSMAND_QT_FLAVOUR}/upstream.patched.${CMAKE_TARGET_OS}.${CMAKE_COMPILER_FAMILY}.static")
		endif()

		if (NOT DEFINED OSMAND_EMBEDDED_QT_STATIC)
			message(FATAL_ERROR "Embedded static Qt not found")
		else()
			message("Using embedded Qt5 (static): ${OSMAND_EMBEDDED_QT_STATIC}")
		endif()
	endif()
endif()

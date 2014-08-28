# prepare_upstream_ex: Checks if upstream is present and is correctly configured at specified path
macro(prepare_upstream_ex UPSTREAM_BASE_PATH UPSTREAM_WAS_CONFIGURED)
	# 'stamp' file is updated manually when anything is changed. So including this file will trigger
	# cmake project regeneration. Regeneration itself will allow to check what should be performed.
	include("${UPSTREAM_BASE_PATH}/stamp")

	if (NOT EXISTS "${UPSTREAM_BASE_PATH}/upstream.patched")
		set(UPSTREAM_VERSION_STAMPS_DIFFER 1)
	else()
		# If stamps differ, upstream needs to be reconfigured
		execute_process(
			COMMAND ${CMAKE_COMMAND} -E compare_files "${UPSTREAM_BASE_PATH}/stamp" "${UPSTREAM_BASE_PATH}/.stamp"
			RESULT_VARIABLE UPSTREAM_VERSION_STAMPS_DIFFER)
	endif()
	
	if (UPSTREAM_VERSION_STAMPS_DIFFER)
		if (CMAKE_HOST_WIN32 AND NOT CYGWIN)
			execute_process(
				COMMAND cmd /C "bash --login ${UPSTREAM_BASE_PATH}/configure.sh"
				WORKING_DIRECTORY "${UPSTREAM_BASE_PATH}"
				RESULT_VARIABLE UPSTREAM_CONFIGURE_FAILED)
		else()
			execute_process(
				COMMAND "./configure.sh"
				WORKING_DIRECTORY "${UPSTREAM_BASE_PATH}"
				RESULT_VARIABLE UPSTREAM_CONFIGURE_FAILED)
		endif()
		if (UPSTREAM_CONFIGURE_FAILED)
			message(FATAL_ERROR "Failed to configure upstream for ${CMAKE_TARGET_OS}/${CMAKE_COMPILER_FAMILY}/${CMAKE_TARGET_CPU_ARCH}: ${UPSTREAM_CONFIGURE_FAILED}")
		endif()
		set(${UPSTREAM_WAS_CONFIGURED} 1)
	else()
		set(${UPSTREAM_WAS_CONFIGURED} 0)
	endif()
endmacro()

# prepare_upstream: Checks if upstream is present and is correctly configured at current CMakeList directory
macro(prepare_upstream)
	set(UPSTREAM_WAS_CONFIGURED -1)
	prepare_upstream_ex(${CMAKE_CURRENT_LIST_DIR} UPSTREAM_WAS_CONFIGURED)
endmacro()

# build_upstream_ex: Checks if upstream build is present and is built at specified path
macro(build_upstream_ex UPSTREAM_BASE_PATH)
	if (CMAKE_HOST_WIN32 AND NOT CYGWIN)
		execute_process(
			COMMAND cmd /C "build.bat ${CMAKE_TARGET_OS} ${CMAKE_COMPILER_FAMILY} ${CMAKE_TARGET_CPU_ARCH}"
			WORKING_DIRECTORY "${UPSTREAM_BASE_PATH}"
			RESULT_VARIABLE UPSTREAM_BUILD_FAILED)
	else()
		execute_process(
			COMMAND ./build.sh "${CMAKE_TARGET_OS}" "${CMAKE_COMPILER_FAMILY}" "${CMAKE_TARGET_CPU_ARCH}"
			WORKING_DIRECTORY "${UPSTREAM_BASE_PATH}"
			RESULT_VARIABLE UPSTREAM_BUILD_FAILED)
	endif()

	if (UPSTREAM_BUILD_FAILED)
		message(FATAL_ERROR "Failed to build upstream for ${CMAKE_TARGET_OS}/${CMAKE_COMPILER_FAMILY}/${CMAKE_TARGET_CPU_ARCH}: ${UPSTREAM_BUILD_FAILED}")
	endif()
endmacro()

# build_upstream: Checks if upstream build is present and is built at current CMakeList directory
macro(build_upstream)
	build_upstream_ex(${CMAKE_CURRENT_LIST_DIR})
endmacro()

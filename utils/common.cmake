# prepare_upstream: Checks if upstream is present and is correctly configured
macro(prepare_upstream)
	# 'stamp' file is updated manually when anything is changed. So including this file will trigger
	# cmake project regeneration. Regeneration itself will allow to check what should be performed.
	include("${CMAKE_CURRENT_LIST_DIR}/stamp")

	# If stamps differ, upstream needs to be reconfigured
	execute_process(
		COMMAND ${CMAKE_COMMAND} -E compare_files "${CMAKE_CURRENT_LIST_DIR}/stamp" "${CMAKE_CURRENT_LIST_DIR}/.stamp"
		RESULT_VARIABLE UPSTREAM_VERSION_STAMPS_DIFFER)
	if (UPSTREAM_VERSION_STAMPS_DIFFER)
		if (CMAKE_HOST_WIN32 AND NOT CYGWIN)
			execute_process(
				COMMAND cmd /C "bash --login ${CMAKE_CURRENT_LIST_DIR}/configure.sh"
				WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
				RESULT_VARIABLE UPSTREAM_CONFIGURE_FAILED)
		else()
			execute_process(
				COMMAND "configure.sh"
				WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
				RESULT_VARIABLE UPSTREAM_CONFIGURE_FAILED)
		endif()
		if (UPSTREAM_CONFIGURE_FAILED)
			message(FATAL_ERROR "Failed to configure upstream: ${UPSTREAM_CONFIGURE_FAILED}")
		endif()
	endif()
endmacro()

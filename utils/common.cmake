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
			message(FATAL_ERROR "Failed to configure upstream \"${UPSTREAM_BASE_PATH}\" for ${CMAKE_TARGET_OS}/${CMAKE_COMPILER_FAMILY}/${CMAKE_TARGET_CPU_ARCH}: ${UPSTREAM_CONFIGURE_FAILED}")
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
		message(FATAL_ERROR "Failed to build upstream \"${UPSTREAM_BASE_PATH}\" for ${CMAKE_TARGET_OS}/${CMAKE_COMPILER_FAMILY}/${CMAKE_TARGET_CPU_ARCH}: ${UPSTREAM_BUILD_FAILED}")
	endif()
endmacro()

# build_upstream: Checks if upstream build is present and is built at current CMakeList directory
macro(build_upstream)
	build_upstream_ex(${CMAKE_CURRENT_LIST_DIR})
endmacro()

# link_entire_static_library: Links entire static library using method depending on linker used
macro(link_entire_static_library TARGET_NAME STATIC_LIBRARY_NAME)
	if (CMAKE_TARGET_OS STREQUAL "linux")
		target_link_libraries(${TARGET_NAME}
			"-Wl,--whole-archive" ${STATIC_LIBRARY_NAME} "-Wl,--no-whole-archive"
		)
	elseif (CMAKE_TARGET_OS STREQUAL "macosx" OR CMAKE_TARGET_OS STREQUAL "ios")
		if (CMAKE_TARGET_BUILD_TOOL STREQUAL "xcode")
			target_link_libraries(${TARGET_NAME}
				"-Wl,-force_load,$(CONFIGURATION_BUILD_DIR)/lib${STATIC_LIBRARY_NAME}.a" ${STATIC_LIBRARY_NAME}
			)
		else()
			target_link_libraries(${TARGET_NAME}
				"-Wl,-force_load,${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}/lib${STATIC_LIBRARY_NAME}.a" ${STATIC_LIBRARY_NAME}
			)
		endif()
	elseif (CMAKE_TARGET_OS STREQUAL "windows" AND CMAKE_COMPILER_FAMILY STREQUAL "gcc")
		target_link_libraries(${TARGET_NAME}
			"-Wl,--whole-archive" ${STATIC_LIBRARY_NAME} "-Wl,--no-whole-archive"
		)
	else()
		target_link_libraries(${TARGET_NAME}
			${STATIC_LIBRARY_NAME}
		)
	endif()
endmacro()

# save/save_and_set/restore
macro(save VARIABLE_NAME)
	set(__OLD__${VARIABLE_NAME} ${${VARIABLE_NAME}})
endmacro()
macro(save_and_set VARIABLE_NAME NEW_VALUE)
	save(VARIABLE_NAME)
	set(${VARIABLE_NAME} ${NEW_VALUE})
endmacro()
macro(restore VARIABLE_NAME)
	set(${VARIABLE_NAME} ${__OLD__${VARIABLE_NAME}})
	unset(__OLD__${VARIABLE_NAME})
endmacro()

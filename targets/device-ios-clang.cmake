set(CMAKE_SYSTEM_NAME iOS)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_TARGET_OS ios)
set(CMAKE_TARGET_CPU_ARCH device)
set(CMAKE_TARGET_CPU_ARCH_FAMILY arm)
set(CMAKE_SHARED_LIBS_ALLOWED_ON_TARGET FALSE)
set(CMAKE_STATIC_LIBS_ALLOWED_ON_TARGET TRUE)

# C
execute_process(COMMAND xcodebuild -sdk iphoneos -find-executable clang OUTPUT_VARIABLE _SDK_CLANG_PATH)
string(STRIP "${_SDK_CLANG_PATH}" SDK_CLANG_PATH)
set(CMAKE_C_COMPILER ${SDK_CLANG_PATH})

# C++
execute_process(COMMAND xcodebuild -sdk iphoneos -find-executable clang++ OUTPUT_VARIABLE _SDK_CLANGPP_PATH)
string(STRIP "${_SDK_CLANGPP_PATH}" SDK_CLANGPP_PATH)
set(CMAKE_CXX_COMPILER ${SDK_CLANGPP_PATH})

set(CMAKE_COMPILER_FAMILY clang)

execute_process(COMMAND xcodebuild -sdk iphoneos -find-library system OUTPUT_VARIABLE _SDK_SYSTEMLIB_PATH)
string(STRIP "${_SDK_SYSTEMLIB_PATH}" SDK_SYSTEMLIB_PATH)
string(REPLACE "/usr/lib/libsystem.dylib" "" SDK_ROOT "${SDK_SYSTEMLIB_PATH}")

set(_common_flags "-isysroot ${SDK_ROOT} -arch armv8 -stdlib=libc++ -miphoneos-version-min=10.3 -fPIC")
set(CMAKE_ASM_FLAGS "${_common_flags}")
set(CMAKE_C_FLAGS "${_common_flags}")
set(CMAKE_CXX_FLAGS "${_common_flags}")

set(CMAKE_FIND_FRAMEWORK FIRST)
set(CMAKE_SYSTEM_FRAMEWORK_PATH
	${SDK_ROOT}/System/Library/Frameworks
	${SDK_ROOT}/System/Library/PrivateFrameworks
	${SDK_ROOT}/Developer/Library/Frameworks
)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Finalize settings
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS}" CACHE STRING "ASM compiler flags")
set(CMAKE_ASM_FLAGS_DEBUG "${CMAKE_ASM_FLAGS_DEBUG}" CACHE STRING "ASM compiler flags (debug)")
set(CMAKE_ASM_FLAGS_RELEASE "${CMAKE_ASM_FLAGS_RELEASE}" CACHE STRING "ASM compiler flags (release)")
set(CMAKE_ASM_FLAGS_RELWITHDEBINFO "${CMAKE_ASM_FLAGS_RELWITHDEBINFO}" CACHE STRING "ASM compiler flags (release-with-debug-info)")
set(CMAKE_ASM_FLAGS_MINSIZEREL "${CMAKE_ASM_FLAGS_MINSIZEREL}" CACHE STRING "ASM compiler flags (min-size-release)")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "C compiler flags")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}" CACHE STRING "C compiler flags (debug)")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}" CACHE STRING "C compiler flags (release)")
set(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO}" CACHE STRING "C compiler flags (release-with-debug-info)")
set(CMAKE_C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL}" CACHE STRING "C compiler flags (min-size-release)")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}" CACHE STRING "CXX compiler flags")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG}" CACHE STRING "CXX compiler flags (debug)")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}" CACHE STRING "CXX compiler flags (release)")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}" CACHE STRING "CXX compiler flags (release-with-debug-info)")
set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL}" CACHE STRING "CXX compiler flags (min-size-release)")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS}" CACHE STRING "Executable linker flags")
set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS}" CACHE STRING "Module linker flags")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS}" CACHE STRING "Shared linker flags")
set(CMAKE_STATIC_LINKER_FLAGS "${CMAKE_STATIC_LINKER_FLAGS}" CACHE STRING "Static linker flags")

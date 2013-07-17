set(CMAKE_TARGET_OS ios)
set(CMAKE_TARGET_CPU_ARCH device)
set(CMAKE_SHARED_LIBS_ALLOWED_ON_TARGET FALSE)
set(CMAKE_STATIC_LIBS_ALLOWED_ON_TARGET TRUE)
execute_process(COMMAND xcodebuild -sdk iphoneos -find-executable clang OUTPUT_VARIABLE _SDK_CLANG_PATH)
string(STRIP "${_SDK_CLANG_PATH}" SDK_CLANG_PATH)
set(CMAKE_C_COMPILER ${SDK_CLANG_PATH})
execute_process(COMMAND xcodebuild -sdk iphoneos -find-executable clang++ OUTPUT_VARIABLE _SDK_CLANGPP_PATH)
string(STRIP "${_SDK_CLANGPP_PATH}" SDK_CLANGPP_PATH)
set(CMAKE_CXX_COMPILER ${SDK_CLANGPP_PATH})
set(CMAKE_COMPILER_FAMILY clang)
execute_process(COMMAND xcodebuild -sdk iphoneos -find-library system OUTPUT_VARIABLE _SDK_SYSTEMLIB_PATH)
string(STRIP "${_SDK_SYSTEMLIB_PATH}" SDK_SYSTEMLIB_PATH)
string(REPLACE "/usr/lib/libsystem.dylib" "" SDK_ROOT "${SDK_SYSTEMLIB_PATH}")
message("iOS SDK: ${SDK_ROOT}")
set(CMAKE_C_FLAGS "-isysroot ${SDK_ROOT} -arch armv7 -arch armv7s -stdlib=libc++")
set(CMAKE_CXX_FLAGS "-isysroot ${SDK_ROOT} -arch armv7 -arch armv7s -std=c++11 -stdlib=libc++")

set (CMAKE_FIND_FRAMEWORK FIRST)
set (CMAKE_SYSTEM_FRAMEWORK_PATH
	${SDK_ROOT}/System/Library/Frameworks
	${SDK_ROOT}/System/Library/PrivateFrameworks
	${SDK_ROOT}/Developer/Library/Frameworks
)
set (CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY)
set (CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set (CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

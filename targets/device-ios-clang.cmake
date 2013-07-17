set(CMAKE_TARGET_OS ios)
set(CMAKE_TARGET_CPU_ARCH device)
set(CMAKE_SHARED_LIBS_ALLOWED_ON_TARGET FALSE)
set(CMAKE_STATIC_LIBS_ALLOWED_ON_TARGET TRUE)
execute_process(COMMAND xcodebuild -sdk iphoneos -find-executable clang OUTPUT_VARIABLE _CMAKE_C_COMPILER)
set(CMAKE_C_COMPILER ${_CMAKE_C_COMPILER})
execute_process(COMMAND xcodebuild -sdk iphoneos -find-executable clang++ OUTPUT_VARIABLE _CMAKE_CXX_COMPILER)
set(CMAKE_CXX_COMPILER ${_CMAKE_CXX_COMPILER})
set(CMAKE_COMPILER_FAMILY clang)
execute_process(COMMAND xcodebuild -sdk iphoneos -find-library system OUTPUT_VARIABLE _SDK_SYSTEMLIB)
string(REPLACE "/usr/lib/libsystem.dylib" "" SDK_ROOT "${_SDK_SYSTEMLIB}")
set(CMAKE_C_COMPILER_FLAGS "-isysroot ${SDK_ROOT} -arch armv7 -arch armv7s -stdlib=libc++")
set(CMAKE_CXX_COMPILER_FLAGS "-isysroot ${SDK_ROOT} -arch armv7 -arch armv7s -std=c++11 -stdlib=libc++")

set (CMAKE_FIND_FRAMEWORK FIRST)
set (CMAKE_SYSTEM_FRAMEWORK_PATH
	${SDK_ROOT}/System/Library/Frameworks
	${SDK_ROOT}/System/Library/PrivateFrameworks
	${SDK_ROOT}/Developer/Library/Frameworks
)
set (CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY)
set (CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set (CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Mark that compiler works, since iOS target will fail these tests
#set(CMAKE_C_COMPILER_WORKS TRUE)
#set(CMAKE_CXX_COMPILER_WORKS TRUE)

#set(CMAKE_XCODE_ATTRIBUTE_GCC_VERSION "com.apple.compilers.llvm.clang.1_0")
#set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LANGUAGE_STANDARD "c++0x")
#set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY "libc++")

#set(CMAKE_IOS_DEVELOPER_ROOT ${CMAKE_IOS_DEVELOPER_ROOT} CACHE PATH "Location of iOS Platform")
#set(CMAKE_IOS_SDK_ROOT ${CMAKE_IOS_SDK_ROOT} CACHE PATH "Location of the selected iOS SDK")
#set(CMAKE_OSX_DEPLOYMENT_TARGET "5.0")
#set(CMAKE_OSX_SYSROOT ${CMAKE_IOS_SDK_ROOT} CACHE PATH "Sysroot used for iOS support")
#set(CMAKE_OSX_ARCHITECTURES "armv7" CACHE string "Build architecture for iOS")

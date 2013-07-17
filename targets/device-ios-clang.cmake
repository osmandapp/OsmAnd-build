set(CMAKE_TARGET_OS ios)
set(CMAKE_TARGET_CPU_ARCH device)
set(CMAKE_SHARED_LIBS_ALLOWED_ON_TARGET FALSE)
set(CMAKE_STATIC_LIBS_ALLOWED_ON_TARGET TRUE)
set(CMAKE_C_COMPILER /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang)
set(CMAKE_CXX_COMPILER /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++)
set(CMAKE_COMPILER_FAMILY clang)
set(CMAKE_C_COMPILER_FLAGS "-stdlib=libc++")
set(CMAKE_CXX_COMPILER_FLAGS "-std=c++11 -stdlib=libc++")

set(CMAKE_IOS_DEVELOPER_ROOT "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer")
set(CMAKE_IOS_SDK_ROOT "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk")

set (CMAKE_FIND_FRAMEWORK FIRST)
set (CMAKE_SYSTEM_FRAMEWORK_PATH
	${CMAKE_IOS_SDK_ROOT}/System/Library/Frameworks
	${CMAKE_IOS_SDK_ROOT}/System/Library/PrivateFrameworks
	${CMAKE_IOS_SDK_ROOT}/Developer/Library/Frameworks
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

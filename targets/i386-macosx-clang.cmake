set(CMAKE_SYSTEM_NAME MacOSX)
set(CMAKE_SYSTEM_PROCESSOR x86)
set(CMAKE_TARGET_OS macosx)
set(CMAKE_TARGET_CPU_ARCH i386)
set(CMAKE_TARGET_CPU_ARCH_FAMILY x86)
set(CMAKE_SHARED_LIBS_ALLOWED_ON_TARGET TRUE)
set(CMAKE_STATIC_LIBS_ALLOWED_ON_TARGET TRUE)
set(CMAKE_C_COMPILER /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang)
set(CMAKE_CXX_COMPILER /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++)
set(CMAKE_COMPILER_FAMILY clang)
set(CMAKE_COMPILER_C_FLAGS "-stdlib=libc++ -arch i386 -mmacosx-version-min=10.7")
set(CMAKE_COMPILER_CXX_FLAGS "-std=c++11 -stdlib=libc++ -arch i386 -mmacosx-version-min=10.7")
set(CMAKE_OSX_ARCHITECTURES "i386")
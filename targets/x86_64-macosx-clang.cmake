set(CMAKE_TARGET_OS macosx)
set(CMAKE_TARGET_CPU_ARCH x86_64)
set(CMAKE_TARGET_CPU_ARCH_FAMILY x86)
set(CMAKE_SHARED_LIBS_ALLOWED_ON_TARGET TRUE)
set(CMAKE_STATIC_LIBS_ALLOWED_ON_TARGET TRUE)
set(CMAKE_COMPILER_FAMILY clang)
set(CMAKE_ASM_FLAGS "-stdlib=libc++ -arch x86_64 -mmacosx-version-min=10.7 -fPIC")
set(CMAKE_C_FLAGS "-stdlib=libc++ -arch x86_64 -mmacosx-version-min=10.7 -fPIC")
set(CMAKE_CXX_FLAGS "-std=c++11 -stdlib=libc++ -arch x86_64 -mmacosx-version-min=10.7 -fPIC")
set(CMAKE_OSX_ARCHITECTURES "x86_64")

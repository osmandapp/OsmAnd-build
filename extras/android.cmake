# Extra projects for android target

project(android_cpufeatures)
add_library(android_cpufeatures STATIC
	"${ANDROID_NDK}/sources/android/cpufeatures/cpu-features.c"
)
target_include_directories(android_cpufeatures
	PUBLIC
		"${ANDROID_NDK}/sources/android/cpufeatures"
)

@echo off

setlocal
set SRCLOC=%~dp0

set "TARGET_BUILD_TOOL_SUFFIX=mingw32-make"
set "CMAKE_GENERATOR=MinGW Makefiles"
"%SRCLOC%generate.cmd" %*

endlocal

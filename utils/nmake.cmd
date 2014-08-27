@echo off

setlocal
set SRCLOC=%~dp0

call "%VS120COMNTOOLS%\VCVarsQueryRegistry.bat"
call "%VCINSTALLDIR%\vcvarsall.bat" x86
set TARGET_BUILD_TOOL_SUFFIX=nmake
set CMAKE_GENERATOR=NMake Makefiles
"%SRCLOC%generate.cmd" %*

endlocal

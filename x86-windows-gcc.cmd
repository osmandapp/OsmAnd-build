@echo off

setlocal
set SRCLOC=%~dp0

REM By default, 'mingw32-make' is used
if "%OSMAND_BUILD_TOOL%"=="" (
	set OSMAND_BUILD_TOOL=mingw32-make
)

set OSMAND_CROSSPLATFORM_TARGET=i686-windows-gcc
"%SRCLOC%utils\%OSMAND_BUILD_TOOL%.cmd" %*

endlocal

@echo off

setlocal
set SRCLOC=%~dp0

REM Verify environment
set validTarget=0
if not "%OSMAND_TARGET%"=="" (
	set validTarget=1
	echo Baking project files for native target '%OSMAND_TARGET%'
	if exist "%SRCLOC%..\targets\%OSMAND_TARGET%.cmd" (
		echo Applying specific settings from 'build\targets\%OSMAND_TARGET%.cmd'
		call "%SRCLOC%..\targets\%OSMAND_TARGET%.cmd"
	)
	if not exist "%SRCLOC%..\targets\%OSMAND_TARGET%.cmd" (
		echo No specific settings found (should be in 'build\targets\%OSMAND_TARGET%.cmd')
	)
)
if not "%OSMAND_CROSSPLATFORM_TARGET%"=="" (
	set validTarget=1
	echo Baking project files for cross-platform target '%OSMAND_CROSSPLATFORM_TARGET%'
	set OSMAND_TARGET_SPECIFICATION=-DCMAKE_TOOLCHAIN_FILE=targets/%OSMAND_CROSSPLATFORM_TARGET%.cmake
)
if not "%validTarget%"=="1" (
	echo OSMAND_TARGET and OSMAND_CROSSPLATFORM_TARGET is not set - one of them needs to be set
	exit /B 1
)

REM Configure build type
set CMAKE_BUILD_TYPE=
set BUILD_TYPE_SUFFIX=
if "%1"=="debug" (
	set CMAKE_BUILD_TYPE=Debug
	set BUILD_TYPE_SUFFIX=debug
)
if "%1"=="release" (
	set CMAKE_BUILD_TYPE=Release
	set BUILD_TYPE_SUFFIX=release
)
if "%1"=="safemode" (
	set CMAKE_BUILD_TYPE=RelWithDebInfo
	set BUILD_TYPE_SUFFIX=safemode
)
if not "%CMAKE_BUILD_TYPE%"=="" (
	echo Target build mode: %CMAKE_BUILD_TYPE%
	set CMAKE_BUILD_TYPE=-DCMAKE_BUILD_TYPE:STRING=%CMAKE_BUILD_TYPE%
	set BUILD_TYPE_SUFFIX=-%BUILD_TYPE_SUFFIX%
)

REM Specific CPU configuration
set OSMAND_CPU_SPECIFIC_DEFINE=
set CPU_SPECIFIC_SUFFIX=
if not "%OSMAND_SPECIFIC_CPU_NAME%"=="" (
	echo Specific CPU: %OSMAND_SPECIFIC_CPU_NAME%
	set OSMAND_CPU_SPECIFIC_DEFINE=-DCMAKE_SPECIFIC_CPU_NAME:STRING=%OSMAND_SPECIFIC_CPU_NAME%
	set CPU_SPECIFIC_SUFFIX=-%OSMAND_SPECIFIC_CPU_NAME%
)

REM Get target prefix
set TARGET_PREFIX=
if not "%OSMAND_TARGET_PREFIX%"=="" (
	set TARGET_PREFIX=%OSMAND_TARGET_PREFIX%-
)

set "WORK_ROOT=%SRCLOC%.."

set BAKED_DIR=
if not "%OSMAND_TARGET%"=="" (
	set "BAKED_DIR=%SRCLOC%..\..\baked\%TARGET_PREFIX%%OSMAND_TARGET%%CPU_SPECIFIC_SUFFIX%%BUILD_TYPE_SUFFIX%.%TARGET_BUILD_TOOL_SUFFIX%"
)
if not "%OSMAND_CROSSPLATFORM_TARGET%"=="" (
	set "BAKED_DIR=%SRCLOC%..\..\baked\%TARGET_PREFIX%%OSMAND_CROSSPLATFORM_TARGET%%CPU_SPECIFIC_SUFFIX%%BUILD_TYPE_SUFFIX%.%TARGET_BUILD_TOOL_SUFFIX%"
)
echo Baking project files in %BAKED_DIR%
if exist "%BAKED_DIR%" (
	rmdir /S /Q "%BAKED_DIR%"
)
mkdir "%BAKED_DIR%"
pushd %BAKED_DIR% && (^
cmake -G "%CMAKE_GENERATOR%" ^
	-DCMAKE_TARGET_BUILD_TOOL:STRING=%TARGET_BUILD_TOOL_SUFFIX% ^
	%OSMAND_TARGET_SPECIFICATION% ^
	%CMAKE_BUILD_TYPE% ^
	%OSMAND_CPU_SPECIFIC_DEFINE% ^
	"%WORK_ROOT%" & popd )
		
endlocal

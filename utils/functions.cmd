@echo off

REM >>> 'cleanupEnvironment' function
:cleanupEnvironment
setlocal

REM ASM
if not "%ASM%"=="" (
	echo ASM was set to '%ASM%', unsetting...
	set "ASM="
)

REM CC
if not "%CC%"=="" (
	echo CC was set to '%CC%', unsetting...
	set "CC="
)

REM CXX
if not "%CXX%"=="" (
	echo CXX was set to '%CXX%', unsetting...
	set "CXX="
)

endlocal
exit /B
REM <<< 'cleanupEnvironment' function

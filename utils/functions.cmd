@echo off

REM Perform call to specific function
call %*
goto :EOF

REM >>> 'cleanupEnvironment' function
:cleanupEnvironment

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

goto :EOF
REM <<< 'cleanupEnvironment' function

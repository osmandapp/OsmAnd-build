@echo off
set ORIGINAL_DIR=%CD%
set BAKED_DIR=%~dp0..\baked\%~n0.msvs
rmdir /S /Q "%BAKED_DIR%"
mkdir "%BAKED_DIR%"
chdir "%BAKED_DIR%"
cmake.exe -G "Visual Studio 12" ^
	-DCMAKE_TARGET_BUILD_TOOL:STRING=msvs ^
	-DOSMAND_TARGET:STRING=x86-windows-msvc ^
	"%~dp0"
chdir %ORIGINAL_DIR%

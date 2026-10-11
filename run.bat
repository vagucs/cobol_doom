@echo off
setlocal
cd /d "%~dp0"
set "PATH=C:\msys64\ucrt64\bin;%PATH%"
call build.bat
if errorlevel 1 exit /b 1
build\cobol_doom.exe %*
exit /b %ERRORLEVEL%

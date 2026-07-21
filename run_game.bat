@echo off
setlocal

if defined GODOT_EXE (
  "%GODOT_EXE%" --path "%~dp0"
  exit /b %ERRORLEVEL%
)

where godot.exe >nul 2>nul
if not errorlevel 1 (
  godot.exe --path "%~dp0"
  exit /b %ERRORLEVEL%
)

set "LOCAL_GODOT=G:\software\Godot\4.7.1-stable\Godot_v4.7.1-stable_win64.exe"
if exist "%LOCAL_GODOT%" (
  "%LOCAL_GODOT%" --path "%~dp0"
  exit /b %ERRORLEVEL%
)

echo Godot was not found.
echo Set GODOT_EXE to your Godot executable or add Godot to PATH.
exit /b 1

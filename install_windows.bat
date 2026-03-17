@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM RecipeTube Windows installer helper.
REM - Downloads the latest installer from a URL you provide
REM - Runs it silently (/S)
REM
REM Usage:
REM   install_windows.bat https://YOUR_DOWNLOADS_HOST
REM Example:
REM   install_windows.bat https://xxxxx.trycloudflare.com
REM
REM The host must serve:
REM   /downloads/RecipeTube-Setup.exe

set "BASE_URL=%~1"
if "%BASE_URL%"=="" (
  echo.
  echo Usage: %~nx0 https://YOUR_DOWNLOADS_HOST
  echo Example: %~nx0 https://xxxxx.trycloudflare.com
  echo.
  pause
  exit /b 1
)

REM Trim trailing slash
if "%BASE_URL:~-1%"=="/" set "BASE_URL=%BASE_URL:~0,-1%"

set "EXE_URL=%BASE_URL%/downloads/RecipeTube-Setup.exe"
set "OUT_EXE=%TEMP%\\RecipeTube-Setup.exe"

echo Downloading RecipeTube installer...
echo   %EXE_URL%
echo   -> %OUT_EXE%
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop';" ^
  "Invoke-WebRequest -Uri '%EXE_URL%' -OutFile '%OUT_EXE%' -UseBasicParsing;" ^
  "$len=(Get-Item '%OUT_EXE%').Length;" ^
  "if($len -lt 10485760){ throw ('Downloaded file too small: ' + $len + ' bytes'); }"

if errorlevel 1 (
  echo.
  echo Download failed.
  pause
  exit /b 1
)

echo Running installer silently...
start "" /wait "%OUT_EXE%" /S

if errorlevel 1 (
  echo.
  echo Installer returned an error.
  pause
  exit /b 1
)

echo.
echo Done.
echo If Windows SmartScreen blocks it, click More info -> Run anyway (or sign the app later).
pause


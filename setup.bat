@echo off
setlocal
cd /d "%~dp0"

echo ============================================================
echo   Crow Bandit - setup (install Argon for Roblox Studio sync)
echo ============================================================
echo.

set "ARGON_EXE=%USERPROFILE%\.argon\bin\argon.exe"

REM --- 1. Git check -------------------------------------------------
where git >nul 2>nul
if errorlevel 1 (
  echo [!] Git was not found on this PC.
  echo     Install it (one of these), then run setup.bat again:
  echo       winget install --id Git.Git -e
  echo       or GitHub Desktop: https://desktop.github.com
  echo.
  pause
) else (
  echo [ok] Git found.
)

REM --- 2. Argon CLI -------------------------------------------------
if exist "%ARGON_EXE%" (
  echo [ok] Argon already installed.
  goto :plugin
)

echo [..] Downloading Argon...
set "VER=2.0.29"
set "URL=https://github.com/argon-rbx/argon/releases/download/%VER%/argon-%VER%-windows-x86_64.zip"
set "ZIP=%TEMP%\argon-%VER%.zip"

curl -L --fail --silent --show-error -o "%ZIP%" "%URL%"
if errorlevel 1 (
  echo [!] Download failed. Check your internet connection, then retry.
  pause
  exit /b 1
)

echo [..] Unpacking...
powershell -NoProfile -ExecutionPolicy Bypass -Command "New-Item -ItemType Directory -Force -Path (Join-Path $env:USERPROFILE '.argon\bin') | Out-Null; Expand-Archive -Force -Path '%ZIP%' -DestinationPath (Join-Path $env:USERPROFILE '.argon\bin')"

if not exist "%ARGON_EXE%" (
  echo [!] Something went wrong while unpacking.
  pause
  exit /b 1
)

REM First run registers Argon in PATH and installs its Studio plugin.
"%ARGON_EXE%" --version >nul 2>nul

:plugin
echo [..] Installing the Argon plugin into Roblox Studio...
"%ARGON_EXE%" plugin install -y

echo.
echo [done] Argon is ready.
echo Next: open the game in Roblox Studio, then run sync.bat
echo.
pause

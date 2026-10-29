@echo off
setlocal enableextensions
cd /d "%~dp0"

echo ============================================================
echo   Crow Bandit - start
echo ============================================================
echo.

set "ARGON_EXE=%USERPROFILE%\.argon\bin\argon.exe"
set "REPO=https://github.com/erikgrante-del/crow-bandit.git"
set "PLACE_URI=roblox-studio:1+launchmode:edit+task:EditPlace+placeId:125437574506590+universeId:10773637194"

REM 1) folder must be the cloned repo
if not exist ".git" (
  echo [!] This folder is not the project copy.
  echo     Clone it first:
  echo       git clone %REPO%
  echo.
  pause
  exit /b 1
)

REM 2) is Argon installed
if not exist "%ARGON_EXE%" (
  echo [..] First run - installing Argon, please wait.
  powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\install-argon.ps1"
  if not exist "%ARGON_EXE%" (
    echo [!] Argon install failed.
    pause
    exit /b 1
  )
)

REM 3) is origin configured
git remote get-url origin >nul 2>nul
if errorlevel 1 (
  echo [..] Adding repository address.
  git remote add origin %REPO%
  git fetch origin
  git branch --set-upstream-to=origin/main main >nul 2>nul
)

REM 4) Argon server
echo [..] Starting Argon server on http://localhost:8000
start "Argon server" "%ARGON_EXE%" serve

REM 5) GitHub auto-sync
echo [..] Starting GitHub auto-sync.
start "AutoSync" powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\autosync.ps1"

REM 6) open the place
echo [..] Opening Crow Bandit in Roblox Studio.
start "" "%PLACE_URI%"

echo.
echo ============================================================
echo  DONE. Everything is running.
echo  In Studio the Argon panel should show: Synced
echo  If not - open the Argon panel and press Connect.
echo ============================================================
echo.
pause

@echo off
setlocal enableextensions
cd /d "%~dp0"

echo ============================================================
echo   Crow Bandit - one-click start
echo ============================================================
echo.

set "ARGON_EXE=%USERPROFILE%\.argon\bin\argon.exe"
set "REPO=https://github.com/erikgrante-del/crow-bandit.git"
set "PLACE_URI=roblox-studio:1+launchmode:edit+task:EditPlace+placeId:125437574506590+universeId:10773637194"

REM --- 1. must be a git clone -------------------------------------
if not exist ".git" (
  echo [!] This folder is not a clone of the project.
  echo     Clone it first, then run Start.bat again:
  echo       git clone %REPO%
  echo.
  pause
  exit /b 1
)

REM --- 2. Argon installed? ---------------------------------------
if not exist "%ARGON_EXE%" (
  echo [..] First run: installing Argon (one time)...
  powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\install-argon.ps1"
  if not exist "%ARGON_EXE%" (
    echo [!] Argon install failed.
    pause
    exit /b 1
  )
)

REM --- 3. git remote configured? ---------------------------------
git remote get-url origin >nul 2>nul
if errorlevel 1 (
  echo [..] Adding git remote 'origin'...
  git remote add origin %REPO%
  git fetch origin
  git branch --set-upstream-to=origin/main main >nul 2>nul
)

REM --- 4. start the Argon server ---------------------------------
echo [..] Starting Argon server on http://localhost:8000 ...
start "Argon server" cmd /k ""%ARGON_EXE%" serve"

REM --- 5. start auto git sync ------------------------------------
echo [..] Starting auto git sync...
start "AutoSync" powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\autosync.ps1"

REM --- 6. open the place in Roblox Studio ------------------------
echo [..] Opening Crow Bandit in Roblox Studio...
start "" "%PLACE_URI%"

echo.
echo ============================================================
echo  Done. Everything is running.
echo.
echo  In Roblox Studio: the Argon panel should show "Synced".
echo  If not, open it and press Connect.
echo ============================================================
echo.
timeout /t 10 >nul

@echo off
setlocal
cd /d "%~dp0"

echo ============================================================
echo   Crow Bandit - near-live sync (Argon + Git)
echo ============================================================
echo.

if not exist ".git" (
  echo [!] This folder is not a Git repository. Run: git clone ^<repo-url^>
  pause
  exit /b 1
)

set "ARGON_EXE=%USERPROFILE%\.argon\bin\argon.exe"
if not exist "%ARGON_EXE%" (
  echo [!] Argon not found. Run setup.bat first.
  pause
  exit /b 1
)

echo [..] Starting Argon server (http://localhost:8000) ...
start "Argon server" cmd /k ""%ARGON_EXE%" serve"

echo [..] Starting auto git sync (pull/push every 5 s) ...
start "AutoSync" powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\autosync.ps1"

echo.
echo Both windows are up.
echo In Roblox Studio: open the place, then the "Argon" tab -^> Connect.
echo.
pause

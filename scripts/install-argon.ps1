# Installs the Argon CLI + Roblox Studio plugin (one time).
# Safe to run again: it just exits if Argon is already there.

$ErrorActionPreference = "Stop"
$ver = "2.0.29"
$binDir = Join-Path $env:USERPROFILE ".argon\bin"
$exe = Join-Path $binDir "argon.exe"

if (Test-Path $exe) {
    Write-Host "[ok] Argon is already installed."
    exit 0
}

$url = "https://github.com/argon-rbx/argon/releases/download/$ver/argon-$ver-windows-x86_64.zip"
$zip = Join-Path $env:TEMP "argon-$ver.zip"

Write-Host "[..] Downloading Argon $ver ..."
& curl.exe -L --fail --silent --show-error -o $zip $url
if ($LASTEXITCODE -ne 0 -or -not (Test-Path $zip)) {
    throw "Argon download failed. Check your internet connection (and your proxy app)."
}

Write-Host "[..] Unpacking ..."
New-Item -ItemType Directory -Force -Path $binDir | Out-Null
Expand-Archive -Force -Path $zip -DestinationPath $binDir

if (-not (Test-Path $exe)) { throw "argon.exe not found after unpacking." }

# First run registers Argon in PATH.
& $exe --version | Out-Null

Write-Host "[..] Installing the Argon plugin into Roblox Studio ..."
& $exe plugin install -y | Out-Null

Write-Host "[ok] Argon installed."

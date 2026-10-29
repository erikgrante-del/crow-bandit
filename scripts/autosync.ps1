# Near-live Git sync: pull remote changes and push local ones every few seconds.
# This is the "almost Team Create" part: your saves reach your friend's Studio
# within a few seconds, without clicking anything.

$ErrorActionPreference = "Continue"
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

if (-not (Test-Path (Join-Path $root ".git"))) {
    Write-Host "[!] This folder is not a Git repository." -ForegroundColor Red
    exit 1
}

$remote = git remote 2>$null
if (-not $remote) {
    Write-Host "[!] No git remote configured." -ForegroundColor Red
    Write-Host "    Create a repo on GitHub, then run:"
    Write-Host "      git remote add origin <URL>"
    Write-Host "      git branch -M main"
    Write-Host "      git push -u origin main"
    exit 1
}

$interval = 5
Write-Host "AutoSync started: pull/push every $interval s. Press Ctrl+C to stop."
Write-Host "Repo: $root"
Write-Host ""

while ($true) {
    git add -A 2>$null | Out-Null
    $staged = git diff --cached --name-only 2>$null
    if ($staged) {
        git commit -q -m ("autosync " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss")) 2>$null | Out-Null
        $n = ($staged | Measure-Object).Count
        Write-Host ("[+] committed {0} file(s)" -f $n)
    }

    $pull = git pull --rebase --autostash -q 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[!] Pull failed (merge conflict?). Resolve it manually, then restart sync.bat." -ForegroundColor Red
        Write-Host $pull
        break
    }

    git push -q 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[!] Push failed. Check remote/credentials (git remote -v)." -ForegroundColor Yellow
    }

    Start-Sleep -Seconds $interval
}

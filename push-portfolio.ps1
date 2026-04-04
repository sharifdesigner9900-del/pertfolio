# Run in PowerShell:  cd "d:\pertfolio website"
#                       .\push-portfolio.ps1
#
# Fixes "dubious ownership" on exFAT/USB/network drives by registering this folder as safe.

$ErrorActionPreference = "Continue"
Set-Location $PSScriptRoot

$git = $null
foreach ($c in @("$env:ProgramFiles\Git\bin\git.exe", "${env:ProgramFiles(x86)}\Git\bin\git.exe")) {
    if (Test-Path -LiteralPath $c) { $git = $c; break }
}
if (-not $git) {
    $cmd = Get-Command git -ErrorAction SilentlyContinue
    if ($cmd) { $git = "git" }
}
if (-not $git) {
    Write-Host "Git not found. Install Git for Windows, then open a NEW PowerShell window and run this script again." -ForegroundColor Red
    exit 1
}

Write-Host "Using: $git" -ForegroundColor Gray

# Required on some drives (exFAT, etc.) — without this, Git refuses the repo and `git diff --cached` breaks.
$repoFull = (Get-Item -LiteralPath $PSScriptRoot).FullName
$repoForGit = $repoFull -replace "\\", "/"
Write-Host "Trusting repo for Git: $repoForGit" -ForegroundColor Gray
& $git config --global --add safe.directory $repoForGit 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Note: could not set safe.directory (may already be set)." -ForegroundColor DarkYellow
}

if (-not (Test-Path ".git")) {
    & $git init
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

& $git add .
& $git status

# Avoid `git diff --cached` here — it fails if Git still treats the folder as "not a repo".
$porcelain = (& $git status --porcelain 2>$null | Out-String).Trim()
if ($porcelain.Length -eq 0) {
    Write-Host "Nothing new to commit (working tree clean)." -ForegroundColor Yellow
} else {
    & $git commit -m "Portfolio: Hashmi Studio site"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Commit failed. See messages above." -ForegroundColor Red
        exit $LASTEXITCODE
    }
}

& $git branch -M main 2>$null

$existing = $null
$urlCheck = & $git remote get-url origin 2>&1
if ($LASTEXITCODE -eq 0 -and $urlCheck) {
    $existing = ([string]$urlCheck).Trim()
}

if ($existing) {
    Write-Host "Remote origin already set: $existing" -ForegroundColor Cyan
    $url = Read-Host "Press Enter to keep it, or paste a new HTTPS URL"
    if ($url) {
        & $git remote remove origin
        & $git remote add origin $url.Trim()
    }
} else {
    $url = Read-Host "Paste your empty GitHub repo HTTPS URL (https://github.com/USER/REPO.git)"
    if (-not $url) { Write-Host "No URL given." -ForegroundColor Red; exit 1 }
    & $git remote add origin $url.Trim()
}

Write-Host "Pushing to origin main... (Git may open a browser or ask for username + token)" -ForegroundColor Cyan
& $git push -u origin main
if ($LASTEXITCODE -eq 0) {
    Write-Host "Done. Import this repo on Vercel to go live." -ForegroundColor Green
} else {
    Write-Host "Push failed. Use a Personal Access Token (repo scope) at https://github.com/settings/tokens as the password when Git asks." -ForegroundColor Yellow
}

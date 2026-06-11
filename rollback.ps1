# Swap the live root between the current redesign and the previous (legacy) version.
# Usage:  .\rollback.ps1            -> restore previous version to root
#         .\rollback.ps1 -Forward   -> re-promote the redesign to root
param([switch]$Forward)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

if ($Forward) {
    git show fable-redesign:index.html > index.html
    $msg = "Promote redesign to root"
    Write-Host "Promoted redesign to root." -ForegroundColor Green
} else {
    if (-not (Test-Path "legacy\index.html")) { throw "legacy\index.html not found." }
    Copy-Item "index.html" "redesign-backup.html" -Force
    Copy-Item "legacy\index.html" "index.html" -Force
    $msg = "Rollback: restore previous version to root"
    Write-Host "Restored previous version to root (redesign saved to redesign-backup.html)." -ForegroundColor Yellow
}

git add index.html
git commit -m $msg
git push
Write-Host "Pushed. Live in ~30-60s at https://mihirsethidp.github.io/UserFlowConfiguration/" -ForegroundColor Cyan

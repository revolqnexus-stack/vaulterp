@echo off

REM Launch GoldVault — double-click this on the USB drive.

cd /d "%~dp0app"

if not exist "GoldVault.exe" (

  echo GoldVault.exe not found. Copy the full app folder from your backup.

  pause

  exit /b 1

)

start "" "GoldVault.exe"


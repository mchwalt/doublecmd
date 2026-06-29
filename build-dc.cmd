@echo off
rem Double-click launcher for build-dc.ps1 (handles LAZARUS_HOME short path
rem and auto-retries on flaky FPC internal errors by cleaning the units dir).
rem Pass-through args, e.g.:  build-dc.cmd release   |   build-dc.cmd -Clean
pwsh -NoProfile -ExecutionPolicy Bypass -File "%~dp0build-dc.ps1" %*
if errorlevel 1 (
  echo.
  pause
)

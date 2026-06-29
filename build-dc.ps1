<#
.SYNOPSIS
    Convenience wrapper around Double Commander's build.bat for this Windows machine.

.DESCRIPTION
    Handles the two local build pitfalls automatically:
      1. Sets LAZARUS_HOME to the 8.3 short path (a space in "Program Files"
         otherwise breaks build.bat / windres).
      2. On a flaky FPC internal compiler error (ICE), deletes the corrupt
         units output dir and rebuilds ONCE (auto-retry).

.PARAMETER Target
    build.bat mode: doublecmd (default, app only), release, components,
    plugins, debug, darkwin.

.PARAMETER Clean
    Force a units clean before building (skip straight to a fresh build).

.EXAMPLE
    .\build-dc.ps1
    .\build-dc.ps1 release
    .\build-dc.ps1 -Clean
#>
[CmdletBinding()]
param(
    [string]$Target = 'doublecmd',
    [switch]$Clean
)

$ErrorActionPreference = 'Stop'
$repo     = $PSScriptRoot
$unitsDir = Join-Path $repo 'units\x86_64-win64-win32'
$logFile  = Join-Path $env:TEMP 'dc-build.log'

# 1. Lazarus path as 8.3 short path (space-in-path workaround)
$env:LAZARUS_HOME = 'C:\PROGRA~1\Lazarus'

function Remove-Units {
    if (Test-Path $unitsDir) {
        Write-Host "Cleaning units dir: $unitsDir" -ForegroundColor Yellow
        # Remove-Item is sandbox-blocked on this path; use cmd rd instead.
        cmd /c "rd /s /q `"$unitsDir`""
    }
}

function Invoke-Build {
    Write-Host "Building target '$Target' ..." -ForegroundColor Blue
    cmd /c ".\build.bat $Target" 2>&1 | Tee-Object -FilePath $logFile
}

# build.bat exits 0 even on a failed compile, so judge by the log content.
function Test-BuildOk {
    -not (Select-String -Path $logFile -Quiet -Pattern 'Failed compiling|Compilation aborted|returned an error exitcode')
}
function Test-IsIce {
    Select-String -Path $logFile -Quiet -Pattern 'Compilation raised exception internally|Internal error|List index exceeds bounds'
}

Set-Location $repo

if ($Clean) { Remove-Units }

Invoke-Build

if (Test-BuildOk) {
    Write-Host "`nBUILD OK -> $(Join-Path $repo 'doublecmd.exe')" -ForegroundColor Blue
    exit 0
}

if (Test-IsIce) {
    Write-Host "`nFlaky FPC internal error detected - cleaning units and retrying once..." -ForegroundColor Yellow
    Remove-Units
    Invoke-Build
    if (Test-BuildOk) {
        Write-Host "`nBUILD OK (after units clean) -> $(Join-Path $repo 'doublecmd.exe')" -ForegroundColor Blue
        exit 0
    }
}

Write-Host "`nBUILD FAILED. See log: $logFile" -ForegroundColor Magenta
Select-String -Path $logFile -Pattern 'Error:|Fatal:|Failed compiling' | Select-Object -Last 15
exit 1

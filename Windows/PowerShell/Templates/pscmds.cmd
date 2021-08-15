@ REM Invoke PowerShell commands below : POWERSHELL_COMMANDS.
@ REM NOTE: This script must be encoded with UTF8 without BOM.
@ SETLOCAL ENABLEEXTENSIONS 
@ SET "ERRORLEVEL=" & SET "PSCMDARGS=%*"
@ IF DEFINED PSCMDARGS @ SET "PSCMDARGS=%PSCMDARGS:"=\"%"
@ SET "PSCMDPATH=%~f0" & SET "PSCMDLINE=$PSCmdCommandPath = $env:PSCMDPATH"
@ SET "PSCMDLINE=%PSCMDLINE%; $PSCmdScriptRoot = $(Split-Path $PSCmdCommandPath -Parent)"
@ SET "PSCMDLINE=%PSCMDLINE%; $PSDefaultParameterValues['*:Encoding'] = 'UTF8'"
@ SET "PSCMDLINE=%PSCMDLINE%; $OutputEncoding = [System.Text.UTF8Encoding]::new($false)"
@ SET "PSCMDLINE=%PSCMDLINE%; [System.Console]::InputEncoding = $OutputEncoding"
@ SET "PSCMDLINE=%PSCMDLINE%; [System.Console]::OutputEncoding = $OutputEncoding"
@ SET "PSCMDLINE=%PSCMDLINE%; $PSCmdContent = $(Get-Content -LiteralPath $PSCmdCommandPath)"
@ SET "PSCMDLINE=%PSCMDLINE%; $PSCmdIndex = $PSCmdContent.IndexOf(': POWERSHELL_COMMANDS')"
@ SET "PSCMDLINE=%PSCMDLINE%; $PSCmdNoLabel = 'Label : POWERSHELL_COMMANDS not found.'"
@ SET "PSCMDLINE=%PSCMDLINE%; if ($PSCmdIndex -lt 0) { Write-Error $PSCmdNoLabel; exit 1 }"
@ SET "PSCMDLINE=%PSCMDLINE%; $PSCmdRange = $($PSCmdIndex + 1)..$($PSCmdContent.Length)"
@ SET "PSCMDLINE=%PSCMDLINE%; $PSCmdContent = $($PSCmdContent[$PSCmdRange] | Out-String)"
@ SET "PSCMDLINE=%PSCMDLINE%; & $([scriptblock]::Create($PSCmdContent)) %PSCMDARGS% "
@ PowerShell -Command "%PSCMDLINE%"
@ EXIT /B %ERRORLEVEL%

@ REM Write PowerShell commands below : POWERSHELL_COMMANDS.
@ REM Use $PSCmdCommandPath & $PSCmdScriptRoot to refer the script path,
@ REM     as $PSCommandPath & $PSScriptRoot are not overridable.
: POWERSHELL_COMMANDS

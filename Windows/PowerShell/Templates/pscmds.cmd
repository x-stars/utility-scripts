@ REM Invoke PowerShell commands below : POWERSHELL_COMMANDS.
@ REM NOTE: This script must be encoded with UTF8 without BOM.
@ SETLOCAL ENABLEEXTENSIONS
@ SET "PSCMDPATH=%~f0"
@ SET "PT=SET /P <NUL:" & SET "NL=ECHO="
@ SET "ERRORLEVEL=" & (
    %PT%="$PSCmdCommandPath = $env:PSCMDPATH"&%NL%
    %PT%="$PSCmdScriptRoot = $(Split-Path $PSCmdCommandPath -Parent)"&%NL%
    %PT%="$PSDefaultParameterValues['*:Encoding'] = 'UTF8'"&%NL%
    %PT%="$OutputEncoding = [System.Text.UTF8Encoding]::new($false)"&%NL%
    %PT%="[System.Console]::InputEncoding = $OutputEncoding"&%NL%
    %PT%="[System.Console]::OutputEncoding = $OutputEncoding"&%NL%
    %PT%="$PSCmdContent = $(Get-Content -LiteralPath $PSCmdCommandPath)"&%NL%
    %PT%="$PSCmdIndex = $PSCmdContent.IndexOf(': POWERSHELL_COMMANDS')"&%NL%
    %PT%="$PSCmdNoLabel = 'Label : POWERSHELL_COMMANDS not found.'"&%NL%
    %PT%="if ($PSCmdIndex -lt 0) { Write-Error $PSCmdNoLabel; exit 1 }"&%NL%
    %PT%="$PSCmdRange = $($PSCmdIndex + 1)..$($PSCmdContent.Length)"&%NL%
    %PT%="$PSCmdContent = $($PSCmdContent[$PSCmdRange] | Out-String)"&%NL%
    %PT%="& $([scriptblock]::Create($PSCmdContent)) "&ECHO=%*
) | PowerShell -Command -
@ EXIT /B %ERRORLEVEL%

@ REM Write PowerShell commands below : POWERSHELL_COMMANDS.
@ REM Use $PSCmdCommandPath & $PSCmdScriptRoot to refer the script path,
@ REM     as $PSCommandPath & $PSScriptRoot are not overridable.
: POWERSHELL_COMMANDS

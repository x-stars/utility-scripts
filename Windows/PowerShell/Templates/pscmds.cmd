@ REM Invoke PowerShell commands below ": POWERSHELL_COMMANDS".
@ REM Set PSCMDSTDIN to any value to pass input by stdin stream.
@ REM NOTE: This script MUST be encoded with UTF-8 without BOM.
@ SETLOCAL ENABLEEXTENSIONS
@ SET "ERRORLEVEL=" & SET "PSCMDARGS=%*"
@ SET "PSCMDNAME=%~nx0" & SET "PSCMDPATH=%~f0"
@ SET "PSCMDOPTS=-NoProfile" & SET "PSCMDSTDIN="
@ SET "PSCMDHELP=" & IF "%1"=="-?" @ SET "PSCMDHELP=%2"
@ IF DEFINED PSCMDARGS @ SET "PSCMDARGS=%PSCMDARGS:"=\"%"
@ SET "#1=$PSCmdCommandPath = $env:PSCMDPATH;"
@ SET "#2=$PSCmdScriptRoot = Split-Path $PSCmdCommandPath -Parent;"
@ SET "#3=$PSDefaultParameterValues['*:Encoding'] = 'UTF8';"
@ SET "#4=$OutputEncoding = [System.Text.UTF8Encoding]::new($false);"
@ SET "#5=[System.Console]::InputEncoding = $OutputEncoding;"
@ SET "#6=[System.Console]::OutputEncoding = $OutputEncoding;"
@ SET "#7=$PSCmdContent = Get-Content -LiteralPath $PSCmdCommandPath;"
@ SET "#8=$PSCmdIndex = $PSCmdContent.IndexOf(': POWERSHELL_COMMANDS');"
@ SET "#9=$PSCmdNoLabel = 'Label \": POWERSHELL_COMMANDS\" not found.';"
@ SET "#10=if ($PSCmdIndex -lt 0) { Write-Warning $PSCmdNoLabel; exit 1 };"
@ SET "#11=$PSCmdRange = ($PSCmdIndex + 1)..($PSCmdContent.Length);"
@ SET "#12=$PSCmdContent = $PSCmdContent[$PSCmdRange] | Out-String;"
@ SET "#13=$PSCmdDefPath = Join-Path Function: $env:PSCMDNAME;"
@ SET "#14=Set-Content -LiteralPath $PSCmdDefPath $PSCmdContent;"
@ SET "#15=if ($env:PSCMDHELP) { Get-Help $env:PSCMDNAME %PSCMDHELP% }"
@ SET "#16=else { $PSCmdInvoke = { & $env:PSCMDNAME %PSCMDARGS% };"
@ SET "#17=if ([System.Console]::IsInputRedirected -and !$env:PSCMDSTDIN)"
@ SET "#18={ $input | & $PSCmdInvoke } else { & $PSCmdInvoke } }"
@ FOR /L %%L IN (1, 1, 18) DO @ CALL SET "#0=%%#0%% %%#%%L%%"
@ FOR /L %%L IN (1, 1, 18) DO @ CALL SET "#%%L="
@ SET "PSCMDLINE=%#0:~1%" & SET "#0="
@ PowerShell %PSCMDOPTS% -Command "%PSCMDLINE%"
@ EXIT /B %ERRORLEVEL%

@ REM Write PowerShell commands below ": POWERSHELL_COMMANDS".
@ REM Use $PSCmdCommandPath & $PSCmdScriptRoot to refer the script path,
@ REM     as $PSCommandPath & $PSScriptRoot are not overridable.
: POWERSHELL_COMMANDS

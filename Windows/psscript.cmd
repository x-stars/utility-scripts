@ REM Run PowerShell commands after `@ EXIT`.
@ SET CMD_FILE=%~f0
@ SET PS1_FILE=%~dp0%~n0.ps1
@ FOR /F "skip=9 delims=" %%L IN (
    '@ TYPE "%CMD_FILE%"'
) DO @ ECHO:%%L >> "%PS1_FILE%"
@ PowerShell.exe -File "%PS1_FILE%" %*
@ DEL "%PS1_FILE%"
@ EXIT /B %ERRORLEVEL%
# Write PowerShell commands below.

@ REM Run WSL app with the same name.
@ SETLOCAL ENABLEEXTENSIONS
@ SET PROG=%~n0
@ FOR /F "delims=" %%A IN (
    '@ WSLPath.cmd %*'
) DO @ SET ARGS=%%A
@ wsl.exe -- %PROG% %ARGS%
@ ENDLOCAL

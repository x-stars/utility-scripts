@ REM Run WSL app with the same name.
@ SETLOCAL ENABLEDELAYEDEXPANSION
@ SET PROG=%~n0
@ FOR /F "delims=" %%A IN (
    '@ wslpath.cmd %*'
) DO @ SET ARGS=%%A
@ wsl.exe -- %PROG% %ARGS%
@ ENDLOCAL

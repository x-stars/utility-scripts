@ REM Run WSL app with the same name.
@ SETLOCAL ENABLEEXTENSIONS
@ SET ERRORLEVEL=
@ SET PROG=%~n0
@ FOR /F "delims=" %%A IN (
    '@ CALL WSLPath %*'
) DO @ SET ARGS=%%A
@ wsl --exec %PROG% %ARGS%
@ EXIT /B %ERRORLEVEL%

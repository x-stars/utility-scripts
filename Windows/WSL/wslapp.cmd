@ REM Run the WSL app with the same name.
@ SET PROG=%~n0
@ FOR /F "delims=" %%A IN (
    '@ wslpath.cmd %*'
) DO @ SET ARGS=%%A
@ wsl.exe -- %PROG% %ARGS%

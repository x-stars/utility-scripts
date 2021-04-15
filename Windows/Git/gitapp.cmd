@ REM Run Git Bash app with the same name.
@ FOR %%N IN (git.exe
) DO @ SET GIT_HOME=%%~dp$PATH:N..
@ SET BASH=%GIT_HOME%\bin\bash.exe
@ SET PROG=%~n0
@ FOR /F "delims=" %%A IN (
    '@ mingwpath.cmd %*'
) DO @ SET ARGS=%%A
@ IF NOT DEFINED ARGS @ (
    @ "%BASH%" -c "%PROG%"
) ELSE @ (
    @ "%BASH%" -c "%PROG% %ARGS:"=\"%"
)

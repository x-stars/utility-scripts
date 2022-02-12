@ REM Run Git Bash app with the same name.
@ SETLOCAL ENABLEEXTENSIONS
@ SET ERRORLEVEL=
@ FOR %%N IN (git.exe
) DO @ SET GIT_HOME=%%~dp$PATH:N..
@ SET BASH=%GIT_HOME%\bin\bash.exe
@ SET "PROG=%~n0" & SET "ARGS=%*"
@ IF DEFINED ARGS @ SET "ARGS=%ARGS:\=\\\\%"
@ IF DEFINED ARGS @ SET "ARGS=%ARGS:"=\"%"
@ "%BASH%" -c "%PROG% %ARGS:"=\"%"
@ EXIT /B %ERRORLEVEL%

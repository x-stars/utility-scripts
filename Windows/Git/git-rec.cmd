@ REM Run Git command recursively.
@ SETLOCAL ENABLEEXTENSIONS
@ SET ERRORLEVEL=
@ CALL:MAIN %* 
@ EXIT /B %ERRORLEVEL%
@ ENDLOCAL

: MAIN
@ SET CD=
@ SET ROOT=%CD%
@ FOR /R %%P IN (.) DO @ (
    @ IF EXIST "%%~fP\.git" @ (
        @ CHDIR %%~fP
        @ SET REPO=%%~fP
        @ CALL:HEADER
        @ git %*
        @ ECHO=
        @ CHDIR %ROOT%
    )
)
@ EXIT /B %ERRORLEVEL%

: HEADER
@ SET HEAD=^^^>^^^>^^^> [35m
@ SET TAIL=[0m ^^^<^^^<^^^<
@ SETLOCAL ENABLEDELAYEDEXPANSION
@ SET REPO=!REPO:%ROOT%=.!
@ SET REPO=!REPO:\=/!
@ SET REPO=!REPO:./=!
@ ECHO %HEAD%!REPO!%TAIL%
@ ENDLOCAL
@ EXIT /B %ERRORLEVEL%

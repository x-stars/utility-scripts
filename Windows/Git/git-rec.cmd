@ REM Run Git command recursively.
@ SETLOCAL ENABLEDELAYEDEXPANSION
@ SET CD=& SET ROOT=!CD!
@ SET HEAD=^^^>^^^>^^^> [35m
@ SET TAIL=[0m ^^^<^^^<^^^<
@ FOR /R %%P IN (.) DO @ (
    @ IF EXIST "%%~fP\.git" @ (
        @ CHDIR %%~fP
        @ SET REPO=%%~fP
        @ SET REPO=!REPO:%CD%=.!
        @ SET REPO=!REPO:.\=!
        @ ECHO %HEAD%!REPO!%HEAD%
        @ git %* & ECHO=
        @ CHDIR %ROOT%
    )
)
@ ENDLOCAL

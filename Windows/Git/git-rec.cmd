@ REM Run Git command recursively.
@ SETLOCAL ENABLEEXTENSIONS
@ CALL:MAIN %* 
@ ENDLOCAL
@ EXIT /B

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
@ EXIT /B

: HEADER
@ SET HEAD=^^^>^^^>^^^> [35m
@ SET TAIL=[0m ^^^<^^^<^^^<
@ CALL SET REPO=%%REPO:%ROOT%=.%%
@ SET REPO=%REPO:\=/%
@ SET REPO=%REPO:./=%
@ ECHO %HEAD%%REPO%%TAIL%

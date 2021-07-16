@ REM Run Git command recursively.
@ SETLOCAL ENABLEDELAYEDEXPANSION
@ SET CD=& SET HEAD=.git\HEAD
@ FOR /R %%P IN (.) DO @ (
    @ IF EXIST "%%~fP\.git" @ (
        @ SET REPO=%%~fP
        @ SET REPO=!REPO:%CD%=.!
        @ SET REPO=!REPO:.\=!
        @ PUSHD !REPO!
        @ ECHO [35m!REPO![0m
        @ git %*
        @ ECHO=
        @ POPD
    )
)
@ ENDLOCAL

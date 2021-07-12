@ REM Run Git command recursively.
@ FOR /R %%P IN (.) DO @ (
    @ IF EXIST "%%~fP\.git" @ (
        @ PUSHD %%~fP
        @ ECHO [35m%%~fP[0m
        @ git %*
        @ ECHO=
        @ POPD
    )
)

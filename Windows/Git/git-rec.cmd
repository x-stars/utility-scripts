@ REM Run Git command recursively.
@ FOR /R %%P IN (.) DO @ (
    @ PUSHD %%~fP
    @ IF EXIST .git\ @ (
        @ ECHO=
        @ ECHO %%~fP
        @ ECHO=
        @ git %*
        @ ECHO=
    )
    @ POPD
)

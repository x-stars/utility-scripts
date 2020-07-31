@ REM Convert Windows paths in arguments to WSL paths.
@ SETLOCAL ENABLEDELAYEDEXPANSION
@ SET ARGS=
@ FOR %%A IN (%*) DO @ (
    @ SET ARG=%%A
    @ ECHO !ARG! | @ FINDSTR "\\" > NUL
    @ IF "!ERRORLEVEL!"=="0" @ (
        @ SET ARG=!ARG:\=\\!
        @ FOR /F "delims=" %%P IN (
            '@ wsl.exe -- wslpath -- !ARG!'
        ) DO @ SET ARG="%%P"
    )
    @ IF "!ARGS!"=="" @ (
        @ SET ARGS=!ARG!
    ) ELSE @ (
        @ SET ARGS=!ARGS! !ARG!
    )
)
@ IF NOT "!ARGS!"=="" @ ECHO !ARGS!

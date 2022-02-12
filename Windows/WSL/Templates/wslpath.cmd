@ REM Convert Windows paths to WSL paths.
@ SETLOCAL ENABLEEXTENSIONS
@ SET ERRORLEVEL=
@ CALL:MAIN %*
@ EXIT /B %ERRORLEVEL%

: MAIN
@ SET ARGS=
@ SET PT=SET /P ^<NUL:
: LOOP_ARGS
@ SET ARG=%1
@ IF NOT DEFINED ARG @ GOTO ENDLOOP_ARGS
@ IF EXIST "%ARG%" @ (
    @ SET "ARG=%~1"
    @ CALL:CONVERT
)
@ IF NOT DEFINED ARGS @ (
    @ SET ARGS=%ARG%
) ELSE @ (
    @ SET ARGS=%ARGS% %ARG%
)
@ SHIFT /1
@ GOTO LOOP_ARGS
: ENDLOOP_ARGS
@ IF DEFINED ARGS @ ECHO:%ARGS%
@ EXIT /B %ERRORLEVEL%

: CONVERT
@ %PT%="%ARG%" | FINDSTR "^[\\]" 1>NUL:
@ IF NOT ERRORLEVEL 1 @ (
    @ FOR /F "delims=" %%P IN (
        '@ CHDIR'
    ) DO @ SET ARG=%%~dP%ARG%
)
@ %PT%="%ARG%" | FINDSTR "^[a-zA-Z]:" 1>NUL:
@ IF NOT ERRORLEVEL 1 @ (
    @ CALL:CAPITAL
)
@ SET "ARG=%ARG:\=/%"
@ SET "ARG=%ARG:`=\`%"
@ SET "ARG=%ARG:$=\$%"
@ SET  ARG="%ARG%"
@ EXIT /B %ERRORLEVEL%

: CAPITAL
@ SET "DRV=%ARG:~0,1%"
@ FOR %%C IN (
    a b c d e f g h i j k l m
    n o p q r s t u v w x y z
) DO @ CALL SET DRV=%%DRV:%%C=%%C%%
@ SET "ARG=/mnt/%DRV%%ARG:~2%"
@ EXIT /B %ERRORLEVEL%

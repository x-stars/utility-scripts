@ REM List arguments.
@ SETLOCAL ENABLEEXTENSIONS
@ SET ERRORLEVEL=
@ SET PT=SET /P ^<NUL:
: LOOP_ARGS
@ SET ARG=%1
@ IF NOT DEFINED ARG @ (
    @ GOTO ENDLOOP_ARGS
)
@ %PT%="%~1" & ECHO=
@ SHIFT /1
@ GOTO LOOP_ARGS
: ENDLOOP_ARGS
@ EXIT /B %ERRORLEVEL%

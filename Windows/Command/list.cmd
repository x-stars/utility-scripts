@ REM List arguments.
: LOOP_ARGS
@ SET ARG=%1
@ IF NOT DEFINED ARG @ (
    @ GOTO ENDLOOP_ARGS
)
@ ECHO:%~1
@ SHIFT /1
@ GOTO LOOP_ARGS
: ENDLOOP_ARGS
@ EXIT /B 0

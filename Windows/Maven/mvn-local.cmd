@ REM Run Maven command with local settings.
@ SETLOCAL ENABLEDELAYEDEXPANSION
@ SET WORK_DIR=%CD%
@ SET LOCAL_NAME=settings.xml
: LOOP_FINDLOCAL
@ CHDIR ..
@ SET LOCAL_FILE=!CD!\!LOCAL_NAME!
@ IF NOT EXIST "!LOCAL_FILE!" @ (
    @ IF NOT "!CD:~-1!"=="\" @ (
        @ GOTO LOOP_FINDLOCAL
    )
)
: ENDLOOP_FINDLOCAL
@ CHDIR %WORK_DIR%
@ IF EXIST "%LOCAL_FILE%" @ (
    mvn -s "%LOCAL_FILE%" %*
) ELSE @ (
    mvn %*
)

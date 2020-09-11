@ REM Run Maven command with local settings.
@ SETLOCAL ENABLEDELAYEDEXPANSION
@ SET WORK_DIR=%CD%
@ SET LOCAL_NAME=maven-settings.xml
: LOOP_FINDLOCAL
@ CHDIR ..
@ SET LOCAL_DIR=!CD!
@ SET LOCAL_FILE=!LOCAL_DIR!\!LOCAL_NAME!
@ IF NOT EXIST "!LOCAL_FILE!" @ (
    @ IF NOT "!LOCAL_DIR:~-1!"=="\" @ (
        @ GOTO LOOP_FINDLOCAL
    )
)
: ENDLOOP_FINDLOCAL
@ CHDIR %WORK_DIR%
@ SET ARGS=%*
@ IF EXIST "%LOCAL_FILE%" @ (
    mvn --settings "%LOCAL_FILE%" %*
) ELSE @ (
    mvn %*
)

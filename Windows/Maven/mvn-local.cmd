@ REM Run Maven command with local settings.
@ SETLOCAL ENABLEEXTENSIONS
@ SET ERRORLEVEL=
@ CALL:MAIN %*
@ EXIT /B %ERRORLEVEL%
@ ENDLOCAL

: MAIN
@ SET CD=
@ CALL:LOCAL
@ IF EXIST "%LOCAL_FILE%" @ (
    @ mvn -s "%LOCAL_FILE%" %*
) ELSE @ (
    @ mvn %*
)
@ EXIT /B %ERRORLEVEL%

: LOCAL
@ SET "WORK_DIR=%CD%"
@ SET "LOCAL_NAME=settings.xml"
: LOOP_FINDLOCAL
@ SET "LOCAL_FILE=%CD%\%LOCAL_NAME%"
@ IF NOT EXIST "%LOCAL_FILE%" @ (
    @ IF NOT "%CD:~-1%" == "\" @ (
        @ CHDIR ..
        @ GOTO LOOP_FINDLOCAL
    )
)
: ENDLOOP_FINDLOCAL
@ CHDIR "%WORK_DIR%"
@ EXIT /B %ERRORLEVEL%

@ REM Run Git command recursively.
@ SETLOCAL ENABLEEXTENSIONS
@ SET ERRORLEVEL=
@ CALL:MAIN %* 
@ EXIT /B %ERRORLEVEL%
@ ENDLOCAL

: MAIN
@ SET CD=
@ CALL:LENGTH
@ SET PT=SET /P ^<NUL
@ FOR /R %%P IN (.) DO @ (
    @ IF EXIST "%%~fP\.git" @ (
        @ PUSHD %%~fP
        @ CALL:HEADER
        @ git %*
        @ ECHO=
        @ POPD
    )
)
@ EXIT /B %ERRORLEVEL%

: LENGTH
@ SET  RLEN=0
@ SET "REST=%CD%"
: LOOP_CUT
@ IF NOT DEFINED REST @ (
    @ GOTO ENDLOOP_CUT
)
@ SET "REST=%REST:~1%"
@ SET /A RLEN += 1
@ GOTO LOOP_CUT
: ENDLOOP_CUT
@ EXIT /B %ERRORLEVEL%

: HEADER
@ SET REPO=.%%CD:~%RLEN%%%
@ CALL SET "REPO=%REPO%"
@ SET "REPO=%REPO:\=/%"
@ SET "REPO=%REPO:./=%"
@ %PT%=">>> "& %PT%>CON=[35m
@ SET /P <NUL="%REPO%"
@ %PT%>CON=[0m& ECHO= ^<^<^<
@ EXIT /B %ERRORLEVEL%

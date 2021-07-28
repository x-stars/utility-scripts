@ REM Run Git command recursively.
@ SETLOCAL ENABLEEXTENSIONS
@ SET ERRORLEVEL=
@ CALL:MAIN %* 
@ EXIT /B %ERRORLEVEL%

: MAIN
@ SET CD=
@ CALL:LENGTH
@ SET TOTALERROR=0
@ SET PT=SET /P ^<NUL:
@ FOR /R %%P IN (.) DO @ (
    @ IF EXIST "%%~fP\.git" @ (
        @ PUSHD %%~fP
        @ CALL:HEADER
        @ git %*
        @ CALL:STATUS
        @ ECHO=
        @ POPD
    )
)
@ EXIT /B %TOTALERROR%

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
@ SET  REPO=.%%CD:~%RLEN%%%
@ CALL SET  "REPO=%REPO%"
@ SET "REPO=%REPO:*.\=%"
@ SET "REPO=%REPO:\=/%"
@ %PT%=">>> "& %PT%>CON:=[35m
@ SET /P <NUL:="%REPO%"
@ %PT%>CON:=[0m& ECHO= ^<^<^<
@ EXIT /B %ERRORLEVEL%

: STATUS
@ SET EXITCODE=%ERRORLEVEL%
@ SET /A TOTALERROR += %EXITCODE%
@ IF %EXITCODE% == 0 @ EXIT /B 0
@ %PT%>&2=!!! & %PT%>CON:=[33m
@ %PT%>&2=exit with code %EXITCODE%
@ %PT%>CON:=[0m& ECHO>&2= !!!
@ EXIT /B %ERRORLEVEL%

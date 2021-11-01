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
        @ CALL git %*
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
@ CALL SET  "REPO=.%%CD:~%RLEN%%%"
@ SET "REPO=%REPO:*.\=%"
@ SET "REPO=%REPO:\=/%"
@ FOR /F "tokens=1,*" %%M IN (
    '@ CALL git branch'
) DO @ IF "%%M"=="*" SET "BRANCH=%%N"
@ %PT%>CON:=[00m& %PT%=">>> "
@ %PT%>CON:=[35m& %PT%="%REPO% "
@ %PT%>CON:=[36m& %PT%="(%BRANCH%)"
@ %PT%>CON:=[00m& ECHO= ^<^<^<
@ EXIT /B %ERRORLEVEL%

: STATUS
@ SET EXITCODE=%ERRORLEVEL%
@ IF %EXITCODE% == 0 @ EXIT /B 0
@ SET /A TOTALERROR += 1
@ SET EXITMSG=exit with code
@ %PT%>CON:=[00m& %PT%>&2="!!! "
@ %PT%>CON:=[33m& %PT%>&2="%EXITMSG% "
@ %PT%>CON:=[31m& %PT%>&2="%EXITCODE%"
@ %PT%>CON:=[00m& ECHO>&2= !!!
@ EXIT /B %ERRORLEVEL%

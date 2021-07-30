@ REM Set variable as command output.
@ SETLOCAL ENABLEEXTENSIONS
@ SET ERRORLEVEL=& SET RANDOM=
@ SET "VARNAME=%~1" & SET "COMMAND=%~2" & SET REMAINS=%3
@ IF "%VARNAME%" == "/?" @ CALL:HELPINFO & EXIT /B 0
@ IF NOT DEFINED VARNAME @ CALL:INVLDSYN & EXIT /B 1
@ IF NOT DEFINED COMMAND @ CALL:INVLDSYN & EXIT /B 1
@ IF     DEFINED REMAINS @ CALL:INVLDSYN & EXIT /B 1
@ IF DEFINED SETASERR (GOTO TEMPFILE) ELSE (GOTO PIPELINE)

: PIPELINE
@ REM Output to pipeline without exit code.
@ ENDLOCAL & SET "%VARNAME%=" & SET "%VARNAME%#0=0" & (
    @ FOR /F "usebackq tokens=1,* delims=:" %%L IN (
        `" (%COMMAND%) | FINDSTR /N .* "`
    ) DO @ SET "%VARNAME%#0=%%L" & SET "%VARNAME%#%%L=%%M"
) & ( CALL SET "%VARNAME%=%%%VARNAME%#1%%" ) ^
& EXIT /B %ERRORLEVEL%

: TEMPFILE
@ REM Output to temporary file with exit code.
@ SET OUTFILE=%TEMP%\SETAS-%VARNAME%#%RANDOM%.txt
@ (%COMMAND%)>"%OUTFILE%" & CALL SET EXITCODE=%%ERRORLEVEL%%
@ ENDLOCAL & SET "%VARNAME%=" & SET "%VARNAME%#0=0" & (
    @ FOR /F "usebackq tokens=1,* delims=:" %%L IN (
        `@ FINDSTR /N .* "%OUTFILE%"`
    ) DO @ SET "%VARNAME%#0=%%L" & SET "%VARNAME%#%%L=%%M"
) & ( CALL SET "%VARNAME%=%%%VARNAME%#1%%" ) ^
& DEL "%OUTFILE%" & EXIT /B %EXITCODE%

: INVLDSYN
@ ECHO>&2=The syntax of the command is incorrect.
@ EXIT /B %ERRORLEVEL%

: HELPINFO
@ SET CMDNAME=%~n0& FOR %%L IN (
    A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
) DO @ CALL SET CMDNAME=%%CMDNAME:%%L=%%L%%
@ ECHO=Sets a variable value as output of a command.
@ ECHO=& ECHO=%CMDNAME% variable="command"& ECHO=
@ ECHO=  variable  Specifies the variable name to set.
@ ECHO=  command   Specifies the command to execute.
@ ECHO=& ECHO=If variable %%SETASERR%% is set to any value,
@ ECHO=%CMDNAME% will set the ERRORLEVEL of the command.
@ ECHO=& ECHO=These variables will also set:& ECHO=
@ ECHO=  variable#0  Represents the lines of output.
@ ECHO=  variable#n  Represents the n-th line of output.
@ EXIT /B %ERRORLEVEL%

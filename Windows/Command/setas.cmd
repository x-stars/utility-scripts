@ REM Set variable as command output.
@ SETLOCAL ENABLEEXTENSIONS & SET ERRORLEVEL=
@ SET "VARNAME=%~1" & SET "COMMAND=%~2" & SET REMAINS=%3
@ IF "%VARNAME%" == "/?" @ CALL:HELPINFO & EXIT /B 0
@ IF NOT DEFINED VARNAME @ CALL:INVLDSYN & EXIT /B 1
@ IF NOT DEFINED COMMAND @ CALL:INVLDSYN & EXIT /B 1
@ IF     DEFINED REMAINS @ CALL:INVLDSYN & EXIT /B 1
@ ENDLOCAL & SET "%VARNAME%=" & SET "%VARNAME%#0=0" & (
    @ FOR /F "usebackq tokens=1,* delims=:" %%L IN (
        `" (%COMMAND%) | FINDSTR /N .* "`
    ) DO @ SET "%VARNAME%#0=%%L" & SET "%VARNAME%#%%L=%%M"
) & ( CALL SET "%VARNAME%=%%%VARNAME%#1%%" ) ^
& EXIT /B %ERRORLEVEL%

: INVLDSYN
@ ECHO=The syntax of the command is incorrect.
@ EXIT /B %ERRORLEVEL%

: HELPINFO
@ SET CMDNAME=%~n0& FOR %%L IN (
    A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
) DO @ CALL SET CMDNAME=%%CMDNAME:%%L=%%L%%
@ ECHO=Sets a variable value as output of a command.
@ ECHO=& ECHO=%CMDNAME% variable="command"& ECHO=
@ ECHO=  variable  Specifies the variable name to set.
@ ECHO=  command   Specifies the command to execute.
@ ECHO=& ECHO=These variables will also set:& ECHO=
@ ECHO=  variable#0  Represents the lines of output.
@ ECHO=  variable#n  Represents the n-th line of output.
@ EXIT /B %ERRORLEVEL%

@ REM Set variable as command output.
@ SETLOCAL ENABLEEXTENSIONS
@ SET "VARNAME=%~1" & SET "COMMAND=%~2" & SET REMAINS=%3
@ SET ERRORLEVEL=& SET OUTFILE=%TEMP%\SETAS-%VARNAME%.txt
@ IF NOT DEFINED VARNAME @ CALL:HELPINFO & EXIT /B 255
@ IF NOT DEFINED COMMAND @ CALL:HELPINFO & EXIT /B 255
@ IF     DEFINED REMAINS @ CALL:HELPINFO & EXIT /B 255
@ %COMMAND% > "%OUTFILE%" & CALL SET EXITCODE=%%ERRORLEVEL%%
@ SET /P RESULT=< "%OUTFILE%" & DEL "%OUTFILE%"
@ ENDLOCAL & SET "%VARNAME%=%RESULT%" & EXIT /B %EXITCODE%

: HELPINFO
@ SET CMDNAME=%~n0& FOR %%L IN (
    A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
) DO @ CALL SET CMDNAME=%%CMDNAME:%%L=%%L%%
@ ECHO>&2=Sets a variable value as output of a command.
@ ECHO>&2=& ECHO>&2=%CMDNAME% variable="command"& ECHO>&2=
@ ECHO>&2=  variable  Specifies the variable name to set.
@ ECHO>&2=  command   Specifies the command to execute.
@ EXIT /B %ERRORLEVEL%

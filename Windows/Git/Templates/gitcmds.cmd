@ REM Invoke Git Bash commands below ": GITBASH_COMMANDS".
@ REM NOTE: This script MUST be encoded with UTF-8 without BOM.
@ SETLOCAL ENABLEEXTENSIONS
@ SET "ERRORLEVEL=" & CHCP 65001 1>NUL:
@ SET "SHCMDNAME=%~n0" & SET "SHCMDARGS=%*"
@ IF DEFINED SHCMDARGS @ SET "SHCMDARGS=%SHCMDARGS:\=\\\\%"
@ IF DEFINED SHCMDARGS @ SET "SHCMDARGS=%SHCMDARGS:"=\"%"
@ SET "SHCMDPATH=%~f0" & SET "SHCMDINDEX="
@ FOR /F "usebackq tokens=1,* delims=:" %%L IN (
    `@ FINDSTR /LNX /C:": GITBASH_COMMANDS" "%SHCMDPATH%"`
) DO @ SET /A SHCMDINDEX = %%L + 1 & GOTO BREAK_FINDLABEL
: BREAK_FINDLABEL
@ SET "SHCMDNOLABEL=Label ": GITBASH_COMMANDS" not found."
@ IF NOT DEFINED SHCMDINDEX @ ECHO>&2 %SHCMDNOLABEL%& EXIT /B 1
@ SET "SHELL=/bin/sh"
@ FOR /F "usebackq tokens=1,* delims=:#!" %%L IN (
    `@ FINDSTR /BN /C:"#!" "%SHCMDPATH%"`
) DO @ IF %SHCMDINDEX% == %%L @ SET "SHELL=%%M" & GOTO BREAK_FINDSHELL
: BREAK_FINDSHELL
@ FOR %%N IN (git.exe) DO @ SET GIT_HOME=%%~dp$PATH:N..
@ SET "#1=export SHCMDPATH='%SHCMDPATH:'='\''%'"
@ SET "#2=SHCMDTEMP='/tmp/%SHCMDNAME:'='\''%.'$$'.shcmd'"
@ SET "#3=tail -n+%SHCMDINDEX% \"$SHCMDPATH\""
@ SET "#4=sed 's/\r$//' > \"$SHCMDTEMP\""
@ SET "#5=%SHELL% \"$SHCMDTEMP\" %SHCMDARGS%"
@ SET "#6=EXITCODE=$?; rm \"$SHCMDTEMP\"; exit $EXITCODE"
@ SET "SHCMDLINE=%#1%; %#2%; %#3% | %#4%; %#5%; %#6%"
@ SET #1=& SET #2=& SET #3=& SET #4=& SET #5=& SET #6=
@ "%GIT_HOME%\bin\bash.exe" -c "%SHCMDLINE%"
@ EXIT /B %ERRORLEVEL%

@ REM Write Git Bash commands below ": GITBASH_COMMANDS".
@ REM Use $SHCMDPATH to refer the script path,
@ REM     as $0 is a temp script and not overridable.
: GITBASH_COMMANDS

@ REM Invoke WSL shell commands below : WSLSHELL_COMMANDS.
@ REM NOTE: This script must be encoded with UTF8 without BOM.
@ SETLOCAL ENABLEEXTENSIONS
@ SET "ERRORLEVEL=" & CHCP 65001 1>NUL:
@ SET "WSLCMDNAME=%~n0" & SET "WSLCMDARGS=%*"
@ IF DEFINED WSLCMDARGS @ SET "WSLCMDARGS=%WSLCMDARGS:\=\\%"
@ IF DEFINED WSLCMDARGS @ SET "WSLCMDARGS=%WSLCMDARGS:"=\"%"
@ SET "WSLCMDPATH=%~f0" & SET "WSLCMDINDEX="
@ FOR /F "usebackq tokens=1,* delims=:" %%L IN (
    `@ FINDSTR /LNX /C:": WSLSHELL_COMMANDS" "%WSLCMDPATH%"`
) DO @ SET /A WSLCMDINDEX = %%L + 1 & GOTO BREAK_FINDLABEL
: BREAK_FINDLABEL
@ SET "WSLCMDNOLABEL=Label : WSLSHELL_COMMANDS not found."
@ IF NOT DEFINED WSLCMDINDEX @ ECHO>&2 %WSLCMDNOLABEL%& EXIT /B 1
@ SET "SHELL=/bin/sh"
@ FOR /F "usebackq tokens=1,* delims=:#!" %%L IN (
    `@ FINDSTR /BN /C:"#!" "%WSLCMDPATH%"`
) DO @ IF %WSLCMDINDEX% == %%L @ SET "SHELL=%%M" & GOTO BREAK_FINDSHELL
: BREAK_FINDSHELL
@ SET "#1=export WSLCMDPATH=`wslpath '%WSLCMDPATH:'='\''%'`"
@ SET "#2=WSLCMDTEMP='/tmp/%WSLCMDNAME:'='\''%.'$$'.shcmd'"
@ SET "#3=tail -n+%WSLCMDINDEX% \"$WSLCMDPATH\""
@ SET "#4=sed 's/\r$//' > \"$WSLCMDTEMP\""
@ SET "#5=%SHELL% \"$WSLCMDTEMP\" %WSLCMDARGS%"
@ SET "#6=EXITCODE=$?; rm \"$WSLCMDTEMP\"; exit $EXITCODE"
@ SET "WSLCMDLINE=%#1%; %#2%; %#3% | %#4%; %#5%; %#6%"
@ SET #1=& SET #2=& SET #3=& SET #4=& SET #5=& SET #6=
@ wsl.exe --exec /bin/sh -c "%WSLCMDLINE%"
@ EXIT /B %ERRORLEVEL%

@ REM Write WSL shell commands below : WSLSHELL_COMMANDS.
@ REM Use $WSLCMDPATH to refer the script path,
@ REM     as $0 is a temp script and not overridable.
: WSLSHELL_COMMANDS

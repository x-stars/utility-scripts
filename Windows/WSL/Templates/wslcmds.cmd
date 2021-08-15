@ REM Invoke WSL shell commands below : WSLSHELL_COMMANDS.
@ REM NOTE: This script must be encoded with UTF8 without BOM.
@ SETLOCAL ENABLEEXTENSIONS
@ SET "ERRORLEVEL=" & CHCP 65001 1>NUL:
@ SET "WSLCMDARGS=%*"
@ IF DEFINED WSLCMDARGS @ SET "WSLCMDARGS=%WSLCMDARGS:\=\\%"
@ IF DEFINED WSLCMDARGS @ SET "WSLCMDARGS=%WSLCMDARGS:"=\"%"
@ SET "WSLCMDPATH=%~f0" & SET "WSLCMDINDEX="
@ FOR /F "tokens=1,* delims=:" %%L IN (
    '@ FINDSTR /LNX /C:": WSLSHELL_COMMANDS" "%WSLCMDPATH%"'
) DO @ SET /A WSLCMDINDEX = %%L + 1 & GOTO BREAK_FINDLABEL
: BREAK_FINDLABEL
@ SET "WSLCMDNOLABEL=Label : WSLSHELL_COMMANDS not found."
@ IF NOT DEFINED WSLCMDINDEX @ ECHO>&2 %WSLCMDNOLABEL%& EXIT /B 1
@ SET "SHELL=/bin/sh"
@ FOR /F "tokens=1,* delims=:#!" %%L IN (
    '@ FINDSTR /BN /C:"#!" "%WSLCMDPATH%"'
) DO @ IF %WSLCMDINDEX% == %%L (SET "SHELL=%%M") & GOTO BREAK_FINDSHELL
: BREAK_FINDSHELL
@ SET "WSLCMDLINE=export WSLCMDPATH=`wslpath '%WSLCMDPATH:'='\''%'`"
@ SET "WSLCMDLINE=%WSLCMDLINE% ; wslpath '%WSLCMDPATH:'='\''%'"
@ SET "WSLCMDLINE=%WSLCMDLINE% | xargs tail -n+%WSLCMDINDEX%"
@ SET "WSLCMDLINE=%WSLCMDLINE% | sed 's/\r$//'" & REM dos2unix
@ SET "WSLCMDLINE=%WSLCMDLINE% > /tmp/wslcmds.$$.sh"
@ SET "WSLCMDLINE=%WSLCMDLINE% ; %SHELL% /tmp/wslcmds.$$.sh %WSLCMDARGS%"
@ SET "WSLCMDLINE=%WSLCMDLINE% ; rm /tmp/wslcmds.$$.sh"
@ wsl.exe --exec /bin/sh -c "%WSLCMDLINE%"
@ EXIT /B %ERRORLEVEL%

@ REM Write WSL shell commands below : WSLSHELL_COMMANDS.
@ REM Use $WSLCMDPATH to refer the script path,
@ REM     as $0 is a temp script and not overridable.
: WSLSHELL_COMMANDS

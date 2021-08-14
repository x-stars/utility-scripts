@ REM Invoke WSL shell commands below : WSLSHELL_COMMANDS.
@ REM NOTE: This script must be encoded with UTF8 without BOM.
@ SETLOCAL ENABLEEXTENSIONS
@ SET "WSLCMDARGS=%*"
@ IF DEFINED WSLCMDARGS (
    @ CALL SET "WSLCMDARGS=%WSLCMDARGS:\=\\%"
    @ CALL SET "WSLCMDARGS=%WSLCMDARGS:"=\"%"
)
@ SET "WSLCMDPATH=%~f0" & SET "WSLCMDINDEX="
@ SET "ERRORLEVEL=" & CHCP 65001 1>NUL:
@ FOR /F "tokens=1,* delims=:" %%L IN (
    '@ FINDSTR /LNX /C:": WSLSHELL_COMMANDS" "%WSLCMDPATH%"'
) DO @ SET /A WSLCMDINDEX = %%L + 1
@ SET "WSLCMDNOLABEL=Label : WSLSHELL_COMMANDS not found."
@ IF NOT DEFINED WSLCMDINDEX @ ECHO>&2 %WSLCMDNOLABEL%& EXIT /B 1
@ SET "WSLCMDLINE=export WSLCMDPATH=`wslpath '%WSLCMDPATH:'='\''%'`"
@ SET "WSLCMDLINE=%WSLCMDLINE% ; wslpath '%WSLCMDPATH:'='\''%'"
@ SET "WSLCMDLINE=%WSLCMDLINE% | xargs tail -n+%WSLCMDINDEX%"
@ SET "WSLCMDLINE=%WSLCMDLINE% | sed 's/\r$//'" & REM dos2unix
@ SET "WSLCMDLINE=%WSLCMDLINE% | $SHELL /dev/stdin %WSLCMDARGS%"
@ wsl.exe --exec /bin/sh -c "%WSLCMDLINE%"
@ EXIT /B %ERRORLEVEL%

@ REM Write WSL shell commands below : WSLSHELL_COMMANDS.
@ REM Use $WSLCMDPATH to refer the script path,
@ REM     as $0 is not overridable and always /dev/stdin.
: WSLSHELL_COMMANDS

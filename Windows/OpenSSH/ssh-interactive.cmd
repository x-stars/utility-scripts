@ REM Create SSH connection interactively.
@ SETLOCAL ENABLEEXTENSIONS
@ SET ERRORLEVEL=
@ SET SSH_HOME=%USERPROFILE%\.ssh
@ IF NOT EXIST "%SSH_HOME%" @ MKDIR "%SSH_HOME%"
@ SET KNOWN_DESTS=%SSH_HOME%\known_destinations
@ ECHO Known destinations:& TYPE "%KNOWN_DESTS%" 2>NUL
@ SET SSH_CMDLINE=%*
@ IF DEFINED SSH_OPTIONS @ ECHO SSH options: %SSH_OPTIONS%
@ IF DEFINED SSH_CMDLINE @ ECHO Command line: %SSH_CMDLINE%
@ SET /P DESTINATION="Destination: "
@ IF NOT DEFINED DESTINATION @ EXIT /B 255
@ FINDSTR /LX /C:"%DESTINATION%" "%KNOWN_DESTS%" 1>NUL 2>NUL
@ IF ERRORLEVEL 1 @ ECHO:%DESTINATION%>>"%KNOWN_DESTS%"
@ ssh %SSH_OPTIONS% %DESTINATION% %SSH_CMDLINE%
@ EXIT /B %ERRORLEVEL%
@ ENDLOCAL

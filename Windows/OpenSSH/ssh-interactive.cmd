@ REM Create SSH connection interactively.
@ SETLOCAL ENABLEEXTENSIONS
@ SET SSH_HOME=%UserProfile%\.ssh
@ IF NOT EXIST "%SSH_HOME%" @ MKDIR "%SSH_HOME%"
@ SET KNOWN_DESTS=%SSH_HOME%\known_destinations
@ ECHO Known destinations:& TYPE "%KNOWN_DESTS%" 2>NUL
@ SET /P DESTINATION="Destination: "
@ IF NOT DEFINED DESTINATION @ EXIT /B 255
@ FINDSTR /LX /C:"%DESTINATION%" "%KNOWN_DESTS%" 1>NUL 2>NUL
@ IF ERRORLEVEL 1 @ ECHO:%DESTINATION%>>"%KNOWN_DESTS%"
@ ssh %DESTINATION% %*
@ ENDLOCAL

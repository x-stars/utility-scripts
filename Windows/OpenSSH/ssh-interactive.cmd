@ REM Create SSH connection interactively.
@ SET KNOWN_DESTS="%UserProfile%\.ssh\known_destinations"
@ ECHO Known destinations:
@ TYPE %KNOWN_DESTS% 2>NUL
@ SET /P DESTINATION="Destination: "
@ IF NOT DEFINED DESTINATION @ EXIT /B 255
@ FINDSTR /B /E /L /C:"%DESTINATION%" %KNOWN_DESTS% 1>NUL 2>NUL
@ IF NOT %ERRORLEVEL%==0 @ ECHO:%DESTINATION%>>%KNOWN_DESTS%
@ ssh %DESTINATION% %*
@ EXIT /B %ERRORLEVEL%

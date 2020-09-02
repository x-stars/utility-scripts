@ REM Run program as Administrator.
@ SET ARGS=%*
@ IF DEFINED ARGS @ SET ARGS=%ARGS:'=''%
@ PowerShell.exe -Command Start-Process conhost.exe '%ARGS%' -Verb RunAs

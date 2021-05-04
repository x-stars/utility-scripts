@ REM Run program as Administrator.
@ SET ARGS=%*
@ IF DEFINED ARGS @ SET ARGS=%ARGS:'=''%
@ PowerShell -NoProfile -Command ^
    Start-Process -Verb RunAs ^
    conhost.exe '%ARGS%'

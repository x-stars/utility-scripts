@ REM Install 7-Zip CLI on Windows NanoServer x64.
@ SETLOCAL ENABLEEXTENSIONS
@ SET ERRORLEVEL=

@ REM Initialize %Path% variable.
@ SET SysEnvKey=HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
@ FOR /F "tokens=1,2,*" %%A IN (
    '@ REG QUERY "%SysEnvKey%" /V "Path" ^| FINDSTR "Path"'
) DO @ SET "SysPath=%%C"
@ IF "%SysPath:~-1%" == ";" @ SET "SysPath=%SysPath:~0,-1%"

@ REM Download and install 7-Zip CLI for Windows x64.
@ SET Z7Link=https://raw.githubusercontent.com/develar/7zip-bin/master/win/x64/7za.exe
@ SET Z7File=%TEMP%\7za.exe
@ curl -L "%Z7Link%" -o "%Z7File%"
@ SET "Z7Path=%ProgramFiles%\7-Zip"
@ MKDIR "%Z7Path%"
@ COPY "%Z7File%" "%Z7Path%"
@ SET "SysPath=%SysPath%;%Z7Path%"
@ SETX Path "%SysPath%" /M
@ DEL "%Z7File%"

@ REM Verify 7-Zip CLI executable file.
@ DIR "%Z7Path%\7za.exe" 1>NUL:
@ EXIT /B %ERRORLEVEL%
@ ENDLOCAL

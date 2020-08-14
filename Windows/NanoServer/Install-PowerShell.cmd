@ REM Install PowerShell Core on Windows NanoServer x64.

@ REM Initialize %Path% variable.
@ SET SysEnvKey=HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
@ FOR /F "tokens=1,2,*" %%A IN (
    '@ REG QUERY "%SysEnvKey%" /V "Path" ^| @ FINDSTR "Path"') DO @ SET SysPath=%%C
@ IF "%SysPath:~-1%"==";" @ SET SysPath=%SysPath:~0,-1%

@ REM Download 7-Zip CLI for Windows x64.
@ SET Z7Link=https://raw.githubusercontent.com/develar/7zip-bin/master/win/x64/7za.exe
@ SET Z7File=%TEMP%\7za.exe
@ curl -L "%Z7Link%" -o "%Z7File%"

@ REM Get version info of PowerShell Core.
@ SET PSVer=%1
@ SET PSVerLink=https://raw.githubusercontent.com/PowerShell/PowerShell/master/tools/metadata.json
@ IF NOT DEFINED PSVer @ FOR /F "tokens=2 delims=:, " %%A IN (
    '@ curl -L "%PSVerLink%" ^| @ FINDSTR "StableReleaseTag"') DO @ SET PSVer=%%~A
@ IF DEFINED PSVer @ SET PSVer=%PSVer:v=%

@ REM Download and install PowerShell Core for Windows x64.
@ SET PSName=PowerShell-%PSVer%-win-x64.zip
@ SET PSLink=https://github.com/PowerShell/PowerShell/releases/download/v%PSVer%/%PSName%
@ SET PSFile=%TEMP%\%PSName%
@ curl -L "%PSLink%" -o "%PSFile%"
@ SET PSPath=^%ProgramFiles^%\PowerShell
@ "%Z7File%" x "%PSFile%" -o"%PSPath%" -y
@ SET SysPath=%SysPath%;%PSPath%
@ SETX Path "%SysPath%" /M
@ DEL "%PSFile%"

@ REM Delete 7-Zip CLI for Windows x64.
@ DEL "%Z7File%"

@ REM Verify PowerShell Core executable file.
@ DIR "%PSPath%\pwsh.exe" 1>NUL

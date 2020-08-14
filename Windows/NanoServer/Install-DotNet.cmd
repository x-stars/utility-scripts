@ REM Install .NET Core on Windows NanoServer x64.

@ REM Initialize %Path% variable.
@ SET SysEnvKey=HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
@ FOR /F "tokens=1,2,*" %%A IN (
    '@ REG QUERY "%SysEnvKey%" /V "Path" ^| @ FINDSTR "Path"') DO @ SET SysPath=%%C
@ IF "%SysPath:~-1%"==";" @ SET SysPath=%SysPath:~0,-1%

@ REM Download 7-Zip CLI for Windows x64.
@ SET Z7Link=https://raw.githubusercontent.com/develar/7zip-bin/master/win/x64/7za.exe
@ SET Z7File=%TEMP%\7za.exe
@ curl -L "%Z7Link%" -o "%Z7File%"

@ REM Get version info of .NET Core SDK.
@ SET NETVer=%1
@ SET NETVerLink=https://dotnetcli.azureedge.net/dotnet/Sdk/LTS/latest.version
@ IF NOT DEFINED NETVer @ FOR /F "skip=1" %%A IN ('@ curl -L "%NETVerLink%"') DO @ SET NETVer=%%A

@ REM Download and install .NET Core SDK for Windows x64.
@ SET NETName=dotnet-sdk-%NETVer%-win-x64.zip
@ SET NETLink=https://dotnetcli.azureedge.net/dotnet/Sdk/%NETVer%/%NETName%
@ SET NETFile=%TEMP%\%NETName%
@ curl -L "%NETLink%" -o "%NETFile%"
@ SET NETPath=^%ProgramFiles^%\dotnet
@ "%Z7File%" x "%NETFile%" -o"%NETPath%" -y
@ SET SysPath=%SysPath%;%NETPath%
@ SETX Path "%SysPath%" /M
@ DEL "%NETFile%"

@ REM Delete 7-Zip CLI for Windows x64.
@ DEL "%Z7File%"

@ REM Verify .NET Core SDK executable file.
@ DIR "%NETPath%\dotnet.exe" 1>NUL

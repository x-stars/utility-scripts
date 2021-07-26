@ REM Install .NET Core on Windows NanoServer x64.
@ SETLOCAL ENABLEEXTENSIONS
@ SET ERRORLEVEL=

@ REM Initialize %Path% variable.
@ SET SysEnvKey=HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
@ FOR /F "tokens=1,2,*" %%A IN (
    '@ REG QUERY "%SysEnvKey%" /V "Path" ^| FINDSTR "Path"'
) DO @ SET "SysPath=%%C"
@ IF "%SysPath:~-1%" == ";" @ SET "SysPath=%SysPath:~0,-1%"

@ REM Get version info of .NET Core SDK.
@ SET NETVer=%1
@ SET NETVerLink=https://dotnetcli.azureedge.net/dotnet/Sdk/LTS/latest.version
@ IF NOT DEFINED NETVer @ FOR /F "skip=1" %%A IN (
    '@ curl -L "%NETVerLink%"') DO @ SET NETVer=%%A

@ REM Download and install .NET Core SDK for Windows x64.
@ SET NETName=dotnet-sdk-%NETVer%-win-x64.zip
@ SET NETLink=https://dotnetcli.azureedge.net/dotnet/Sdk/%NETVer%/%NETName%
@ SET NETFile=%TEMP%\%NETName%
@ curl -L "%NETLink%" -o "%NETFile%"
@ SET "NETPath=%ProgramFiles%\dotnet"
@ MKDIR "%NETPath%"
@ tar -xz -f "%NETFile%" -C "%NETPath%"
@ SET "SysPath=%SysPath%;%NETPath%"
@ SETX Path "%SysPath%" /M
@ DEL "%NETFile%"

@ REM Verify .NET Core SDK executable file.
@ DIR "%NETPath%\dotnet.exe" 1>NUL
@ EXIT /B %ERRORLEVEL%
@ ENDLOCAL

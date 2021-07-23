@ REM Install PowerShell Core on Windows NanoServer x64.
@ SETLOCAL ENABLEEXTENSIONS

@ REM Initialize %Path% variable.
@ SET SysEnvKey=HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
@ FOR /F "tokens=1,2,*" %%A IN (
    '@ REG QUERY "%SysEnvKey%" /V "Path" ^| @ FINDSTR "Path"'
) DO @ SET SysPath=%%C
@ IF "%SysPath:~-1%" == ";" @ SET SysPath=%SysPath:~0,-1%

@ REM Get version info of PowerShell Core.
@ SET PSVer=%1
@ SET PSVerLink=https://raw.githubusercontent.com/PowerShell/PowerShell/master/tools/metadata.json
@ IF NOT DEFINED PSVer @ FOR /F "tokens=2 delims=:, " %%A IN (
    '@ curl -L "%PSVerLink%" ^| @ FINDSTR "StableReleaseTag"'
) DO @ SET PSVer=%%~A
@ IF DEFINED PSVer @ SET PSVer=%PSVer:v=%

@ REM Download and install PowerShell Core for Windows x64.
@ SET PSName=PowerShell-%PSVer%-win-x64.zip
@ SET PSLink=https://github.com/PowerShell/PowerShell/releases/download/v%PSVer%/%PSName%
@ SET PSFile=%TEMP%\%PSName%
@ curl -L "%PSLink%" -o "%PSFile%"
@ SET PSPath=%ProgramFiles%\PowerShell
@ MKDIR "%PSPath%"
@ tar -xz -f "%PSFile%" -C "%PSPath%"
@ SET SysPath=%SysPath%;%PSPath%
@ SETX Path "%SysPath%" /M
@ DEL "%PSFile%"

@ REM Verify PowerShell Core executable file.
@ DIR "%PSPath%\pwsh.exe" 1>NUL
@ ENDLOCAL

@ REM Run F# compiler of the latest .NET SDK.
@ SETLOCAL ENABLEEXTENSIONS
@ SET ERRORLEVEL=
@ CALL:MAIN %*
@ EXIT /B %ERRORLEVEL%

: MAIN
@ CALL:FIND_SDK
@ SET BIN_FILE=FSharp\fsc.dll
@ SET BIN_PATH=%SDK_PATH%\%BIN_FILE%
@ SET LIB_PATH=%SDK_PATH%\ref\netstandard.dll
@ dotnet "%BIN_PATH%" -r:"%LIB_PATH%" %*
@ EXIT /B %ERRORLEVEL%

: FIND_SDK
@ FOR /F "tokens=1,*" %%V IN (
    '@ dotnet --list-sdks'
) DO @ (
    @ SET SDK_VER=%%V
    @ SET SDK_DIR=%%W
)
@ SET SDK_DIR=%SDK_DIR:~1,-1%
@ SET SDK_PATH=%SDK_DIR%\%SDK_VER%
@ EXIT /B %ERRORLEVEL%

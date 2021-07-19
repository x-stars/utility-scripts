@ REM Copy public key of local host to remote host.
@ SETLOCAL ENABLEDELAYEDEXPANSION
@ SET ARGS=%*
@ IF NOT DEFINED ARGS @ (
    @ ECHO>&2 usage: %~n0 [-i identity_file] [user@]hostname
    @ EXIT /B 255
)
@ SET DEFAULT_KEY=%USERPROFILE%\.ssh\id_rsa
@ IF "%~1" == "-i" @ (
    @ SET LOCAL_KEY=%~2
    @ SET REMOTE_HOST=%~3
) ELSE @ (
    @ SET LOCAL_KEY=%DEFAULT_KEY%.pub
    @ SET REMOTE_HOST=%~1
)
@ IF NOT EXIST "%LOCAL_KEY%" @ (
    @ IF NOT "%~1" == "-i" @ (
        @ ssh-keygen -t rsa -P "" -f "%DEFAULT_KEY%"
    )
)
@ IF NOT EXIST "%LOCAL_KEY%" @ (
    @ ECHO>&2 error: no identity file in "%LOCAL_KEY%"
    @ EXIT /B 255
)
@ SET REMOTE_KEYS=.ssh/authorized_keys
@ FOR /F "delims=" %%L IN ('@ TYPE "%LOCAL_KEY%"') DO @ (
    @ ssh %REMOTE_HOST% "echo>>%REMOTE_KEYS% %%L"
)
@ ENDLOCAL

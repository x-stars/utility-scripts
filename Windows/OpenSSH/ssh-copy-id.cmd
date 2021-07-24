@ REM Copy public key of local host to remote host.
@ SETLOCAL ENABLEEXTENSIONS
@ CALL:MAIN %*
@ ENDLOCAL
@ EXIT /B

: MAIN
@ CALL:PARSE %*
@ IF ERRORLEVEL 1 @ CALL:USAGE & EXIT /B 255
@ IF NOT EXIST "%ID_FILE%" @ (
    @ ECHO>&2 error: no identity file in %ID_FILE%
    @ ECHO>&2        use ssh-keygen to generate one
    @ EXIT /B 255
)
@ SET OPTIONS=%PORT_OPT% %SSH_OPTS%
@ SET KEYS_FILE=.ssh/authorized_keys
@ SET COPYMSG=public key %ID_FILE% copy to %DESTINATION%
@ FOR /F "delims=" %%K IN ('@ TYPE "%ID_FILE%"') DO @ SET KEY=%%K
@ ssh %OPTIONS% %DESTINATION% echo^>^>%KEYS_FILE% %KEY%
@ IF ERRORLEVEL 1 (@ ECHO>&2 error: %COPYMSG% failed) ^
  ELSE            (@ ECHO>&2 info: %COPYMSG% succeed)
@ EXIT /B

: PARSE
@ SET DEFAULT_ID=%USERPROFILE%\.ssh\id_rsa
@ SET ID_FILE=& SET SSH_OPTS=& SET PORT_OPT=
: LOOP_ARGS
@ SET OPT=& SET VAL=& SET ARG=%~1
@ IF NOT DEFINED ARG @ GOTO ENDLOOP_ARGS
@ IF "%ARG:~0,1%" == "-" @ SET OPT=%~1
@ IF NOT DEFINED OPT @ GOTO ENDLOOP_ARGS
@ IF "%OPT%" == "--" @ SHIFT /1 & GOTO ENDLOOP_ARGS
@ IF "%OPT%" == "-i" @ IF DEFINED ID_FILE @ EXIT /B 255
@ IF "%OPT%" == "-i" @ SET VAL=%~1& SET ID_FILE=%~2
@ IF "%OPT%" == "-i" @ IF NOT DEFINED ID_FILE @ EXIT /B 255
@ IF "%OPT%" == "-p" @ IF DEFINED PORT @ EXIT /B 255
@ IF "%OPT%" == "-p" @ SET VAL=%~1& SET PORT=%~2
@ IF "%OPT%" == "-p" @ IF NOT DEFINED PORT @ EXIT /B 255
@ IF "%OPT%" == "-p" @ SET PORT_OPT=-p "%PORT%"
@ IF "%OPT%" == "-o" @ SET VAL=%~1& SET SSH_OPT=%~2
@ IF "%OPT%" == "-o" @ IF NOT DEFINED SSH_OPT @ EXIT /B 255
@ IF "%OPT%" == "-o" @ SET SSH_OPTS=%SSH_OPTS% -o "%SSH_OPT%"
@ IF NOT DEFINED VAL @ EXIT /B 255
@ IF DEFINED OPT @ SHIFT /1
@ SHIFT /1 & GOTO LOOP_ARGS
: ENDLOOP_ARGS
@ IF NOT DEFINED ID_FILE @ SET ID_FILE=%DEFAULT_ID%
@ IF NOT "%ID_FILE:~-4%" == ".pub" @ SET ID_FILE=%ID_FILE%.pub
@ IF DEFINED SSH_OPTS @ SET SSH_OPTS=%SSH_OPTS:~1%
@ IF "%~1" == "" @ EXIT /B 255
@ IF NOT "%~2" == "" @ EXIT /B 255
@ SET DESTINATION=%~1
@ EXIT /B

: USAGE
@ IF DEFINED OPT @ ECHO>&2 error: invalid options at %OPT%
@ IF NOT DEFINED OPT @ ECHO>&2 error: invalid destination
@ SET OPTMSG=[-i identity_file] [-p port] [-o ssh_options]...
@ ECHO>&2 usage: %~n0 %OPTMSG% [user@]hostname
@ EXIT /B

@ REM Convert Windows paths in arguments to WSL paths.
@ SETLOCAL ENABLEDELAYEDEXPANSION
@ SET ARGS=
: LOOP ARGS
    @ IF '%1'=='' @ GOTO ENDLOOP ARGS
    @ SET ARG=%1
    @ ECHO !ARG! | @ FINDSTR /V "[\\][\\]" | @ FINDSTR "[\\]" > NUL
    @ IF !ERRORLEVEL!==0 @ (
        @ SET ARG=%~1
        @ ECHO !ARG! | @ FINDSTR "^[\\]" > NUL
        @ IF !ERRORLEVEL!==0 @ (
            @ FOR /F "delims=" %%P IN (
                '@ ECHO %CD%'
            ) DO @ SET ARG=%%~dP!ARG!
        )
        @ ECHO !ARG! | @ FINDSTR "^[a-zA-Z]:" > NUL
        @ IF !ERRORLEVEL!==0 @ (
            @ SET DRV=!ARG:~0,1!
            @ FOR %%C IN (
                a b c d e f g h i j k l m
                n o p q r s t u v w x y z
            ) DO @ SET DRV=!DRV:%%C=%%C!
            @ SET ARG=/mnt/!DRV!!ARG:~2!
        )
        @ SET ARG=!ARG:\=/!
        @ SET ARG=!ARG:`=\`!
        @ SET ARG="!ARG!"
    )
    @ IF '!ARGS!'=='' @ (
        @ SET ARGS=!ARG!
    ) ELSE @ (
        @ SET ARGS=!ARGS! !ARG!
    )
    @ SHIFT
    @ GOTO LOOP ARGS
: ENDLOOP ARGS
@ IF NOT '!ARGS!'=='' @ ECHO !ARGS!

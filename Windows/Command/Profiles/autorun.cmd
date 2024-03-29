@ REM Command Prompt startup commands.
@ SETLOCAL ENABLEEXTENSIONS & SET CMDCMDLINE=
@ ECHO "%CMDCMDLINE:"=%" | FINDSTR /LI /C:"/C" 1>NUL:
@ IF NOT ERRORLEVEL 1 @ EXIT /B 0
@ ENDLOCAL ENABLEEXTENSIONS

@ REM Set command macros.
@ SET AUTORUN=%~f0
@ DOSKEY ?=ECHO %%ERRORLEVEL%%
@ DOSKEY AUTORUN=CALL "%%AUTORUN%%"
@ DOSKEY BELL=SET /P ^<NUL:^>CON:=
@ DOSKEY CD=IF "$1"=="" (CD) ELSE CD /D $*
@ DOSKEY CD~=CD /D %%USERPROFILE%%
@ DOSKEY CHDIR=IF "$1"=="" (CHDIR) ELSE CHDIR /D $*
@ DOSKEY CHDIR~=CHDIR /D %%USERPROFILE%%
@ DOSKEY DOSKEY=IF "$1"=="" (DOSKEY /MACROS) ELSE DOSKEY $*
@ DOSKEY ECHON=SET /P ^<NUL:=$*
@ DOSKEY ERROR=ECHO^>^&2=$*
@ DOSKEY HISTORY=DOSKEY /HISTORY
@ DOSKEY MKFILE=FOR %%F IN ($*) DO @ TYPE NUL:^> %%F

@ REM Set command prompt.
@ IF NOT DEFINED SSH_TTY @ TITLE Command Prompt
@ IF DEFINED SSH_TTY @ TITLE OpenSSH - Command Prompt
@ IF DEFINED SSH_TTY (SET ENTRY=SSH) ELSE (SET ENTRY=CMD)
@ SET PROMPT_TIME=$e[0m$e[31m(*%ENTRY%)$e[0m[$T$H$H$H$H$H$H]
@ SET PROMPT_USER=$e[0m$e[32m%USERNAME%$e[0m@$e[35m%COMPUTERNAME%
@ SET PROMPT_PATH=$e[0m$e[34m$e[1m$P$e[0m$_$e[1m$G$e[0m$S
@ PROMPT %PROMPT_TIME% %PROMPT_USER% %PROMPT_PATH%
@ SET ENTRY=& SET PROMPT_TIME=& SET PROMPT_USER=& SET PROMPT_PATH=

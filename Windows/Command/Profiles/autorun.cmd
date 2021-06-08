@ REM Command Prompt startup commands.

@ REM Set command macros.
@ SET AUTORUN=%~f0
@ DOSKEY ?=ECHO %%ERRORLEVEL%%
@ DOSKEY AUTORUN=CALL "%%AUTORUN%%"
@ DOSKEY CDD=CD /D $*
@ DOSKEY CD~=CD /D %%USERPROFILE%%
@ DOSKEY CHDIRD=CHDIR /D $*
@ DOSKEY CHDIR~=CHDIR /D %%USERPROFILE%%
@ DOSKEY ECHON=SET /P ^<NUL=$*
@ DOSKEY ERROR=ECHO^>^&2:$*
@ DOSKEY HISTORY=DOSKEY /HISTORY
@ DOSKEY MACROS=DOSKEY /MACROS

@ REM Set command prompt.
@ IF DEFINED SSH_TTY (@ SET ENTRY=SSH) ELSE (@ SET ENTRY=CMD)
@ SET PROMPT_TIME=$e[0m$e[31m(%ENTRY%)$e[0m[$T$H$H$H$H$H$H]
@ SET PROMPT_USER=$e[0m$e[92m%USERNAME%$e[0m@$e[95m%COMPUTERNAME%
@ SET PROMPT_PATH=$e[0m$e[34m$e[1m$P$e[0m$_$e[1m$G$e[0m$S
@ PROMPT %PROMPT_TIME% %PROMPT_USER% %PROMPT_PATH%
@ SET ENTRY=& SET PROMPT_TIME=& SET PROMPT_USER=& SET PROMPT_PATH=

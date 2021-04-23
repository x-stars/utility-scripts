@ REM Command Prompt startup commands.

@ REM Set command macros.
@ SET AUTORUN=%~f0
@ DOSKEY CDD=CD /D $*
@ DOSKEY CHDIRD=CHDIR /D $*
@ DOSKEY ?=ECHO %%ERRORLEVEL%%
@ DOSKEY MACROS=DOSKEY /MACROS
@ DOSKEY HISTORY=DOSKEY /HISTORY
@ DOSKEY AUTORUN=CALL "%%AUTORUN%%"

@ REM Set command prompt.
@ IF DEFINED SSH_TTY @ (
    @ SET PROMPT_TIME=$e[0m$e[31m$CSSH$F$e[0m[$T$H$H$H$H$H$H]
) ELSE @ (
    @ SET PROMPT_TIME=$e[0m$e[31m$CCMD$F$e[0m[$T$H$H$H$H$H$H]
)
@ SET PROMPT_USER=$e[0m$e[1;32m%USERNAME%$e[0m@$e[1;35m%COMPUTERNAME%
@ SET PROMPT_PATH=$e[0m$e[1;34m$P$e[0;1m$_$G$S$e[0m
@ PROMPT %PROMPT_TIME% %PROMPT_USER% %PROMPT_PATH%

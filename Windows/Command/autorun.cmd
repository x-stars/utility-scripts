@ REM Command Prompt startup commands.

@ REM Set command prompt.
@ IF DEFINED SSH_TTY @ (
    @ SET PROMPT_STATE=$e[0m$e[31m$CSSH$F$e[0m[$T$H$H$H$H$H$H]
) ELSE @ (
    @ SET PROMPT_STATE=$e[0m$e[31m$CCMD$F$e[0m[$T$H$H$H$H$H$H]
)
@ SET PROMPT_USER=$e[0m$e[1;32m%USERNAME%$e[0m@$e[1;35m%COMPUTERNAME%
@ SET PROMPT_LOCATION=$e[0m$e[1;34m$P$e[0;1m$_$G$S$e[0m
@ PROMPT %PROMPT_STATE% %PROMPT_USER% %PROMPT_LOCATION%

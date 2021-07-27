@ REM Show console color palette.
@ SETLOCAL ENABLEDELAYEDEXPANSION
@ ECHO [1;4m8-Color         ^^[[?m           [0m
@ FOR %%T IN (3 4) DO @ (
    @ FOR /L %%I IN (0, 1, 7) DO @ (
        @ SET /A NUM = %%T * 10 + %%I
        @ IF !NUM! LSS 100 (SET SPACE=  ) ELSE (SET SPACE= )
        @ SET /P <NUL:=[!NUM!m!SPACE!!NUM![0m
    )
    @ ECHO=
)
@ ECHO [1;4m16-Color        ^^[[?m           [0m
@ FOR %%T IN (3 4 9 10) DO @ (
    @ FOR /L %%I IN (0, 1, 7) DO @ (
        @ SET /A NUM = %%T * 10 + %%I
        @ IF !NUM! LSS 100 (SET SPACE=  ) ELSE (SET SPACE= )
        @ SET /P <NUL:=[!NUM!m!SPACE!!NUM![0m
    )
    @ ECHO=
)
@ FOR %%T IN (3 4) DO @ (
    @ ECHO [1;4m256-Color       ^^[[%%T8;5;?m      [0m    
    @ FOR %%R IN (0 1) DO @ (
        @ FOR /L %%C IN (0, 1, 7) DO @ (
            @ SET /A NUM = %%R * 8 + %%C
            @ IF !NUM! LSS 10 (SET SPACE=   ) ELSE (SET SPACE=  )
            @ SET /P <NUL:=[%%T8;5;!NUM!m!SPACE!!NUM![0m
        )
        @ ECHO=
    )
    @ FOR %%O IN (16 88 160) DO @ (
        @ FOR /L %%R IN (0, 1, 5) DO @ (
            @ FOR %%S IN (0 36) DO @ (
                @ FOR /L %%C IN (0, 1, 5) DO @ (
                    @ SET /A NUM = %%O + %%R * 6 + %%S + %%C
                    @ IF !NUM! LSS 100 (SET SPACE=  ) ELSE (SET SPACE= )
                    @ SET /P <NUL:=[%%T8;5;!NUM!m!SPACE!!NUM![0m
                )
            )
            @ ECHO=
        )
    )
    @ FOR %%R IN (0 1) DO @ (
        @ FOR /L %%C IN (0, 1, 11) DO @ (
            @ SET /A NUM = 232 + %%R * 12 + %%C
            @ IF !NUM! LSS 100 (SET SPACE=  ) ELSE (SET SPACE= )
            @ SET /P <NUL:=[%%T8;5;!NUM!m!SPACE!!NUM![0m
        )
        @ ECHO=
    )
)
@ ENDLOCAL

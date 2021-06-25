@ REM Test expression.
@ IF %* @ (
    @ ECHO>&2 1
    @ EXIT /B 0
) ELSE @ (
    @ ECHO>&2 0
    @ EXIT /B 1
)

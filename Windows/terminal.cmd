@ SET ARGS=%*
@ IF "%ARGS%"=="" @ SET ARGS=-d .
@ conhost.exe wt.exe %ARGS%

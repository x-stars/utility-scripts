@ SET ARGS=%*
@ IF NOT DEFINED ARGS @ SET ARGS=-d .
@ conhost.exe wt.exe %ARGS%

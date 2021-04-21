@ SET PROXY=%1
: SET_PROXY
@ IF NOT DEFINED PROXY @ (
    @ SET /P "PROXY=Proxy host:port = "
    @ GOTO SET_PROXY
)
@ git config --global http.proxy "http://%PROXY%"
@ git config --global https.proxy "https://%PROXY%"

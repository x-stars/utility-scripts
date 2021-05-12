# 脚本文件的绝对路径

## CMD

``` Batch
REM Script file:
%~f0
REM Script directory:
%~dp0
REM Script name:
%~nx0
```

## PowerShell

``` PowerShell
# Script file:
$PSCommandPath
# Script directory:
$PSScriptRoot # or:
$(Split-Path $PSCommandPath -Parent)
# Script name:
$(Split-Path $PSCommandPath -Leaf)
```

## Unix Shell

``` Shell
# Script file:
$(cd $(dirname $0) ; pwd)/$(basename $0)
# Script directory:
$(cd $(dirname $0) ; pwd)
# Script name:
$(basename $0)
```

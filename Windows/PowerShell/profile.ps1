<#
.SYNOPSIS
当前用户的 PowerShell 配置文件。
#>

# 设定自定义全局变量。
New-Variable EOL $([System.Environment]::NewLine) -Option Constant
New-Variable PATHSEP $([System.IO.Path]::PathSeparator) -Option Constant

# 设定自定义命令别名。
New-Alias eval Invoke-Expression
New-Alias new New-Object
New-Alias out Out-File

# 导入脚本文件目录。
$env:Path = "$env:Path$PATHSEP$(Join-Path $(Split-Path $PROFILE -Parent) Scripts)"

# 导入当前目录的配置文件。
if (Test-Path ".profile.ps1" -PathType Leaf) { . ".profile.ps1" }

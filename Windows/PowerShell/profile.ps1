<#
.SYNOPSIS
当前用户的 PowerShell 配置文件。
#>

# 设定自定义全局变量。
Set-Variable NewLine $([System.Environment]::NewLine) -Option ReadOnly -Force
Set-Variable DirSep $([System.IO.Path]::DirectorySeparatorChar) -Option ReadOnly -Force
Set-Variable PathSep $([System.IO.Path]::PathSeparator) -Option ReadOnly -Force

# 设定自定义命令别名。
Set-Alias eval Invoke-Expression -Force
Set-Alias new New-Object -Force
Set-Alias out Out-File -Force

# 定义重新加载配置文件的命令。
function Update-Profile
{
    $PROFILE.PSObject.Properties |
    Where-Object Name -NE 'Length' |
    ForEach-Object { $_.Value } |
    Where-Object { Test-Path $_ -PathType Leaf } |
    ForEach-Object { . $_ }
}

# 加载命令提示配置。
$PromptProfile = $(Join-Path $(Split-Path $PROFILE -Parent) 'prompt.ps1')
if (Test-Path $PromptProfile -PathType Leaf) { . $PromptProfile }

# 导入脚本文件目录。
$env:Path = "$env:Path$PathSep$(Join-Path $(Split-Path $PROFILE -Parent) 'Scripts')"
# 导入当前用户模块。
Import-Module $(Get-ChildItem $(Join-Path $(Split-Path $PROFILE -Parent) 'Modules'))

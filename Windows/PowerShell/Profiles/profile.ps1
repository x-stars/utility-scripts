﻿<#
.SYNOPSIS
当前用户的 PowerShell 配置文件。
#>

# 设定自定义全局变量。
Set-Variable -Option ReadOnly -Force `
    NewLine $([System.Environment]::NewLine)
Set-Variable -Option ReadOnly -Force `
    DirSep $([System.IO.Path]::DirectorySeparatorChar)
Set-Variable -Option ReadOnly -Force `
    PathSep $([System.IO.Path]::PathSeparator)

# 设定自定义命令别名。
Set-Alias -Force eval Invoke-Expression
Set-Alias -Force new New-Object
Set-Alias -Force out Out-File

# 设定自定义简单命令。
function bell { Write-Host "`a" -NoNewline }
function mklink { cmd.exe /c mklink @args }

# 定义命令提示的配置。
function Write-PromptStatus { }
function prompt
{
    $Status = $?
    [System.Environment]::CurrentDirectory = $PWD.Path
    $StatusText = if ($Status) { '(○PS)' } else { '(×PS)' }
    $StatusColor = if ($Status) { 'Green' } else { 'Red' }
    [System.Console]::ResetColor()
    Write-Host $StatusText -ForegroundColor $StatusColor -NoNewline
    Write-Host "[$(Get-Date -UFormat %R)]" -NoNewline
    Write-Host ' ' -NoNewline
    Write-Host $env:USERNAME -ForegroundColor Cyan -NoNewline
    Write-Host '@' -NoNewline
    Write-Host $env:COMPUTERNAME -ForegroundColor Magenta -NoNewline
    Write-Host ' ' -NoNewline
    Write-Host $PWD.Path -ForegroundColor Yellow -NoNewline
    [System.Console]::ResetColor()
    Write-Host $($(Write-PromptStatus) -join ' ')
    [System.Console]::ResetColor()
    Write-Output '> '
}
Set-PSReadLineOption -PromptText '> '

# 设定内置变量配置。
Set-Variable OutputEncoding $([System.Text.Encoding]::UTF8)

# 导入脚本文件目录。
if (Test-Path $(Join-Path $(Split-Path $PROFILE -Parent) 'Scripts'))
{
    $env:Path += $PathSep + $(Join-Path $(Split-Path $PROFILE -Parent) 'Scripts')
}

# 导入当前用户模块。
if (Test-Path $(Join-Path $(Split-Path $PROFILE -Parent) 'Modules'))
{
    Get-ChildItem $(Join-Path $(Split-Path $PROFILE -Parent) 'Modules') -Directory |
    ForEach-Object Name | Import-Module -ErrorAction SilentlyContinue
}

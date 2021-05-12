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

# 定义命令提示的配置。
function prompt
{
    $Status = $?
    $StatusText = if ($Status) { '(○)' } else { '(×)' }
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
    Write-Host
    [System.Console]::ResetColor()
    Write-Output '> '
}

# 导入脚本文件目录。
$env:Path += $PathSep + $(Join-Path $(Split-Path $PROFILE -Parent) 'Scripts')
# 导入当前用户模块。
Get-ChildItem $(Join-Path $(Split-Path $PROFILE -Parent) 'Modules') -Directory |
ForEach-Object Name | Import-Module -ErrorAction SilentlyContinue
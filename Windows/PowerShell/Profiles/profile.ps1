<#
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

# 设定内置变量配置项。
Set-Variable OutputEncoding $([System.Text.Encoding]::UTF8)

# 定义命令提示符配置。
function Write-PromptStatus { }
function prompt
{
    $Status = $?                 #0x25CB          #0x00D7
    $StatusText = if ($Status) { '(○PS)' } else { '(×PS)' }
    $StatusColor = if ($Status) { 'Green' } else { 'Red' }
    $CurrentDirectory = $PWD.Path
    if ($PWD.Provider.Name -eq 'FileSystem') {
        [System.Environment]::CurrentDirectory =
            $CurrentDirectory = $PWD.ProviderPath }
    [System.Console]::ResetColor()
    Write-Host $StatusText -ForegroundColor $StatusColor -NoNewline
    Write-Host "[$(Get-Date -Format HH:mm)]" -NoNewline
    Write-Host ' ' -NoNewline
    Write-Host $env:USERNAME -ForegroundColor Cyan -NoNewline
    Write-Host '@' -NoNewline
    Write-Host $env:COMPUTERNAME -ForegroundColor Magenta -NoNewline
    Write-Host ' ' -NoNewline
    Write-Host $CurrentDirectory -ForegroundColor Yellow -NoNewline
    Write-Host $($(Write-PromptStatus) -join ' ')
    [System.Console]::ResetColor()
    Write-Output '> '
}
Set-PSReadLineOption -PromptText '> '

# 导入用户脚本目录。
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

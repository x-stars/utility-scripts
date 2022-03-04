#.SYNOPSIS
# 当前用户的 PowerShell 配置文件。

# 仅交互模式下配置。
$PSCmdLineArgs = [System.Environment]::GetCommandLineArgs()
if (($PSCmdLineArgs[0] -inotlike '*PowerShell_ISE*') -and
    ($PSCmdLineArgs -inotcontains '-NoProfile') -and
    ($PSCmdLineArgs -imatch '^(-Command|-File|.*\.ps1)$') -and
    ($PSCmdLineArgs -inotcontains '-NoExit')) { exit }

# 设定内置配置变量。
$PSDefaultParameterValues['*:Encoding'] = 'UTF8'
$OutputEncoding = [System.Text.UTF8Encoding]::new($false)
try { [System.Console]::InputEncoding = $OutputEncoding } catch { }
try { [System.Console]::OutputEncoding = $OutputEncoding } catch { }

# 定义内置命令别名。
Set-Alias -Force error Write-Error
Set-Alias -Force eval Invoke-Expression
Set-Alias -Force guid New-Guid
Set-Alias -Force hash Get-FileHash
Set-Alias -Force new New-Object
Set-Alias -Force out Out-File
Set-Alias -Force read Read-Host

# 定义简单用户命令。
function bell { Write-Host "`a" -NoNewline }
function mklink { cmd.exe /c mklink @args }
function string {
    begin   { foreach ($_ in $args)  { [string]$_ } }
    process { foreach ($_ in $input) { [string]$_ } } }
function time { $cmd = [scriptblock]::Create($args);
    $time = [datetime]::Now; & $cmd; [datetime]::Now - $time }

# 定义命令提示配置。
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
    Write-Output $(Get-PSReadLineOption).PromptText
}
function Write-PromptStatus { }
Set-PSReadLineOption -PromptText '> '

# 导入用户脚本目录。
if (Test-Path $(Join-Path $(Split-Path $PROFILE -Parent) 'Scripts'))
{
    $env:Path += [System.IO.Path]::PathSeparator +
        $(Join-Path $(Split-Path $PROFILE -Parent) 'Scripts')
}

# 导入当前用户模块。
if (Test-Path $(Join-Path $(Split-Path $PROFILE -Parent) 'Modules'))
{
    Join-Path $(Split-Path $PROFILE -Parent) 'Modules' |
    Get-ChildItem -Directory | ForEach-Object Name |
    Import-Module -ErrorAction SilentlyContinue
}

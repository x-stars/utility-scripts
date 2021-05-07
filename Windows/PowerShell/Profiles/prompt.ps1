<#
.SYNOPSIS
当前用户的 PowerShell 命令提示配置。
#>

function Prompt
{
    $State = $?
    $StateText = if ($State) { '(○)' } else { '(×)' }
    $StateColor = if ($State) { 'Green' } else { 'Red' }
    Write-Host $StateText -ForegroundColor $StateColor -NoNewline
    Write-Host "[$($(Get-Date).ToString('HH:mm'))]" -NoNewline
    Write-Host ' ' -NoNewline
    Write-Host $env:USERNAME -ForegroundColor Cyan -NoNewline
    Write-Host '@' -NoNewline
    Write-Host $env:COMPUTERNAME -ForegroundColor Magenta -NoNewline
    Write-Host ' ' -NoNewline
    Write-Host $PWD.Path -ForegroundColor Yellow -NoNewline
    Write-Host
    Write-Output '> '
}

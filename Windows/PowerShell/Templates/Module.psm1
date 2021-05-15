<#
.SYNOPSIS
提供以脚本文件为基础的 PowerShell 模块定义的模板。
#>

Get-Item $(Join-Path $PSScriptRoot '*.ps1') |
Where-Object { Test-Path $_.FullName -PathType Leaf } |
ForEach-Object `
{
    $ScriptPath = $_.FullName
    Set-Alias $_.Name $_.FullName
    Set-Alias $_.BaseName $_.FullName
    $Content = Get-Content $_.FullName
    $Content | Where-Object { $_ -imatch "^\[Alias\('.+'\)\]$" } |
    ForEach-Object { Set-Alias $_.Substring(8, $_.Length - 11) $ScriptPath }
    $Content | Where-Object { $_ -imatch '^\[Alias\(".+"\)\]$' } |
    ForEach-Object { Set-Alias $_.Substring(8, $_.Length - 11) $ScriptPath }
}

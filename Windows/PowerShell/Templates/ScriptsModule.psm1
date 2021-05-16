<#
.SYNOPSIS
提供以脚本文件为基础的 PowerShell 模块定义的模板。
#>

Get-Item $(Join-Path $PSScriptRoot '*.ps1') |
Where-Object { Test-Path $_.FullName -PathType Leaf } |
ForEach-Object { Set-Item Function:\$($_.BaseName) $(Get-Content $_.FullName -Raw) }

<#
.SYNOPSIS
隐藏以 "." 开头的项目。
#>

Get-ChildItem @args | Where-Object { $_.Name -like '.*' } |
ForEach-Object { $_.Attributes = $_.Attributes -bor 'Hidden' }

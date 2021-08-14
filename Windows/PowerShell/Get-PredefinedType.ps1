#.SYNOPSIS
# 获取 PowerShell 预定义类型及其对应框架类型的名称。

[System.AppDomain]::CurrentDomain.GetAssemblies() |
Where-Object { -not $_.IsDynamic } |
ForEach-Object { $_.GetExportedTypes() } |
Where-Object { -not $_.IsGenericType } |
Where-Object { [string]$_ -ne $_.FullName } |
Where-Object { [string]$_ -notlike '*.*' } |
ForEach-Object { [PSCustomObject]@{
    Name = [string]$_; FullName = $_.FullName } }

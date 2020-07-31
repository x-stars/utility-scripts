<#
.SYNOPSIS
清除 Docker 中所有非中间层匿名镜像。
#>

[CmdletBinding()]
[OutputType([void])]
param ()

try
{
    docker container prune --force
    docker image rm $(
        $(docker image ls) -match '<none>' |
        ForEach-Object { $(-split $_)[2] })
}
catch { }

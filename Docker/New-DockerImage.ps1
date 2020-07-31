<#
.SYNOPSIS
从指定 Dockerfile 开始构建新的 Docker 镜像。

.DESCRIPTION
从指定 Dockerfile 开始构建新的 Docker 镜像。
构建完成后会在 Dockerfile 同目录下生成 run.cmd/.sh 和 run-it.cmd/.sh 脚本文件，便于启动生成的镜像。

.PARAMETER Path
Docker 构建镜像所用的上下文目录的路径，也即 Dockerfile 所在的路径。可从管道接收值。

.PARAMETER Name
Docker 构建镜像所用的标签，也即镜像的名称和版本。
默认以 Dockerfile 所在目录为版本，Dockerfile 所在目录的上级目录为名称构建标签。

.INPUTS
从管道接收的 Docker 构建镜像所用的上下文目录的路径。

.OUTPUTS
构建完成的 Docker 镜像的标签。

.EXAMPLE
New-DockerImage.ps1 .\nanoserver-dotnet\1809-2.1\
#>

[CmdletBinding()]
[OutputType([string[]])]
param
(
    [Parameter(
        Position = 0,
        Mandatory = $true,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript(
        { Test-Path -LiteralPath $_ -PathType Container })]
    [string[]]$Path
    ,
    [Parameter(
        Mandatory = $false,
        ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [string[]]$Name
)

process
{
    for ($i = 0; $i -lt $Path.Length; $i++)
    {
        $dockerDir = $(Get-Item -LiteralPath $Path[$i])
        $dockerTag = if ($Name -and $Name[$i]) { $Name[$i] }
        else { "$($dockerDir.Parent.Name):$($dockerDir.Name)" }

        docker build -t $dockerTag $dockerDir

        if ($?)
        {
            "docker run $dockerTag @args" |
            Out-File $(Join-Path $dockerDir 'run.ps1') -Encoding Default
            "docker run -d $dockerTag @args" |
            Out-File $(Join-Path $dockerDir 'run-d.ps1') -Encoding Default
            "docker run -it $dockerTag @args" |
            Out-File $(Join-Path $dockerDir 'run-it.ps1') -Encoding Default
            "docker run -dit $dockerTag @args" |
            Out-File $(Join-Path $dockerDir 'run-dit.ps1') -Encoding Default
    
            $dockerTag
        }
    }
}

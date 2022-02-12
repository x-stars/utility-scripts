<#
.SYNOPSIS
    获取指定的网络内容，并将其保存为文件。
.DESCRIPTION
    获取指定的网络内容，并将其保存为文件。
    Invoke-WebRequest 命令下载文件的简化实现，不能执行其他 Web 命令。
.PARAMETER Uri
    要获取的网络内容的 URI。可从管道接收值。
.PARAMETER OutFile
    要保存到文件的路径。可带上参数名从管道接收值。
    默认为当前目录下与 URI 内容同名的文件。
.PARAMETER MaximumRetryCount
    指定网络请求失败后最大重试次数。默认为 0，-1 表示无限重试。
.PARAMETER Proxy
    指定网络请求所用的代理服务器地址。
.PARAMETER ProxyCredential
    指定访问代理服务器所用的认证信息。
.INPUTS
    System.Uri[]
    要获取的网络内容的 URI。
.OUTPUTS
    System.IO.FileInfo[]
    从网络获取到的内容保存的文件。
.NOTES
    作者：天南十字星 https://github.com/x-stars
.EXAMPLE
    Get-WebItem.ps1 http://example.link/README.txt
.LINK
    Invoke-WebRequest
#>

[Alias('gwi')]
[CmdletBinding()]
[OutputType([System.IO.FileInfo[]])]
param
(
    [Parameter(
        Position = 0,
        Mandatory = $true,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [uri[]]$Uri
    ,
    [Parameter(
        Position = 1,
        Mandatory = $false,
        ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript(
        { Test-Path -LiteralPath $_ -IsValid })]
    [string[]]$OutFile
    ,
    [Parameter(
        Mandatory = $false)]
    [ValidateRange(-1, [int]::MaxValue)]
    [int]$MaximumRetryCount = 0
    ,
    [Parameter(
        Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [uri]$Proxy
    ,
    [Parameter(
        Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [pscredential]$ProxyCredential
)

begin
{
    $MaxRetry = $MaximumRetryCount
    $RequestParam = @{ UseBasicParsing = [switch]$true }
    if ($Proxy) { $RequestParam['Proxy'] = $Proxy }
    if ($ProxyCredential) { $RequestParam['ProxyCredential'] = $ProxyCredential }
}

process
{
    for ($index = 0; $index -lt $Uri.Length; $index++)
    {
        $link = $Uri[$index]
        $file = if ($OutFile -and $OutFile[$index]) { $OutFile[$index] }
                else { Split-Path $link.LocalPath -Leaf }
        [System.IO.Path]::GetInvalidFileNameChars() |
            ForEach-Object { $file = $file.Replace($_, '_') }
        for ($retry = 0; ($retry -le $MaxRetry) -or ($MaxRetry -lt 0); $retry++)
        {
            try
            {
                Invoke-WebRequest $link -OutFile $file @RequestParam
                break
            }
            catch { Write-Warning $_ }
        }
        Get-Item -LiteralPath $file -Force
    }
}

end
{
}

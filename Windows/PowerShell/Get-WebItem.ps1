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
.INPUTS
    System.Uri[]
    要获取的网络内容的 URI。
.OUTPUTS
    System.IO.FileInfo[]
    从网络获取到的内容保存的文件。
.NOTES
    作者：天南十字星 https://github.com/x-stars
.EXAMPLE
    Get-WebItem.ps1 "http://example.link/README.txt"
.LINK
    Invoke-WebRequest
#>

[CmdletBinding()]
[Alias('gwi')]
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
)

process
{
    for ($index = 0; $index -lt $Uri.Length; $index++)
    {
        $link = $Uri[$index]
        $file = if ($OutFile -and $OutFile[$index]) { $OutFile[$index] }
        else { Split-Path $link.LocalPath -Leaf }
        for ($success, $try = $false, 0; -not $success -and $try -lt 3; $try++)
        {
            try
            {
                Invoke-WebRequest $link -OutFile $file -UseBasicParsing
                $success = $true
            }
            catch { Write-Warning $_ }
        }
        Get-Item -LiteralPath $file
    }
}

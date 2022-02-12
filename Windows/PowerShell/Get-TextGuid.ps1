<#
.SYNOPSIS
    获取输入文本的 GUID 形式。
.DESCRIPTION
    获取输入文本的 GUID 形式。
    生成的 GUID 由输入文本编码的哈希值得到。
.PARAMETER Text
    要获取 GUID 的文本。可从管道接收值。
.INPUTS
    System.String[]
    要获取 GUID 的文本。
.OUTPUTS
    System.Guid[]
    输入文本的 GUID 形式。
.NOTES
    作者：天南十字星 https://github.com/x-stars
.LINK
    New-Guid
#>

[Alias('gtguid')]
[CmdletBinding()]
[OutputType([guid[]])]
param
(
    [Parameter(
        Position = 0,
        Mandatory = $true,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true)]
    [AllowEmptyString()]
    [string[]]$Text
)

begin
{
    $Encoding = [System.Text.Encoding]::UTF8
    $Hashing = [System.Security.Cryptography.SHA256]::Create()
}

process
{
    foreach ($string in $Text)
    {
        $binary = $Encoding.GetBytes($string)
        $hashBytes = $Hashing.ComputeHash($binary)
        $guidBytes = [byte[]]$(foreach ($index in 0..15)
        {
            $hashBytes[$index] -bxor $hashBytes[$index + 16]
        })
        [guid]::new($guidBytes)
    }
}

end
{
    $Hashing.Dispose()
}

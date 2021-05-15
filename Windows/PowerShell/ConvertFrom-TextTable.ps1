<#
.SYNOPSIS
将对齐布局的文本表格转换为自定义对象。

.DESCRIPTION
将对齐布局的文本表格转换为自定义对象。
功能类似于 ConvertFrom-Csv，但不同于 CSV 采用固定分隔符（一般为半角逗号 ","）指定单元格，
此命令仅分析表格对齐布局，并寻找在每一行中均为空的列作为分隔。

.PARAMETER InputObject
要转换为自定义对象的文本表格的字符串。可从管道接收值。

.PARAMETER Header
自定义表头内容。

.INPUTS
从管道接收的要转换为自定义对象的文本表格的字符串。

.OUTPUTS
由对齐布局的文本表格转换得到的自定义对象。

.NOTES
作者：天南十字星 https://github.com/x-stars

.EXAMPLE
wsl.exe -- ps -aux | ConvertFrom-TextTable.ps1

.LINK
ConvertFrom-Csv
ConvertFrom-String
#>

[CmdletBinding()]
[Alias('cft')]
[OutputType([psobject[]])]
param
(
    [Parameter(
        Position = 0,
        Mandatory = $true,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true)]
    [psobject[]]$InputObject
    ,
    [Parameter(
        Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string[]]$Header
)

begin
{
    # 管道输入的文本。
    $lines = @()
}

process
{
    # 将管道输入的文本按行分隔。
    foreach ($object in $InputObject)
    {
        $lines += $object -split "`n"
    }
}

end
{
    # 去除首尾空行。
    for ($s = 0; ($s -lt $lines.Length) -and [string]::IsNullOrWhiteSpace($lines[$s]); $s++) { }
    for ($e = $lines.Length - 1; ($e -ge $s) -and [string]::IsNullOrWhiteSpace($lines[$e]); $e--) { }
    if ((-not $Header) -and ($s -eq $e)) { return }

    # 获取在每一行均为空格的索引。
    $spaces = [System.Collections.ArrayList]::new()
    $line = $lines[$s]
    for ($i = 0; $i -lt $line.Length; $i++)
    {
        if ($line[$i] -eq [char]' ')
        {
            $spaces.Add($i) > $null
        }
    }
    for ($l = $s + 1; $l -le $e; $l++)
    {
        $line = $lines[$l]
        for ($i = 0; $i -lt $line.Length; $i++)
        {
            if (($line[$i] -ne [char]' ') -and ($i -in $spaces))
            {
                $spaces.Remove($i) > $null
            }
        }
    }
    # 根据空格索引生成分隔索引。
    $splits = @()
    foreach ($space in $spaces)
    {
        if (($space - 1) -notin $splits)
        {
            $splits += $space
        }
    }

    if ($Header)
    {
        # 自定义表头。
        $names = $Header
    }
    else
    {
        # 首行表头。
        $head = $lines[$s]
        $lines = $lines[$($s + 1)..$e]
        # 分隔表头，获取属性名称。
        $names = @()
        if ($splits.Length -eq 0)
        {
            $names += $head.Trim()
        }
        else
        {
            for ($i = 0; $i -lt $splits.Length; $i++)
            {
                $start = if ($i -eq 0) { 0 } else { $splits[$i - 1] + 1 }
                $end = $splits[$i]
                $names += $head.Substring($start, $($end + 1) - $start).Trim()
            }
            $names += $head.Substring($end + 1, $head.Length - ($end + 1)).Trim()
        }
    }

    # 分隔内容，获取属性的值。
    foreach ($line in $lines)
    {
        $values = @()
        if ($splits.Length -eq 0)
        {
            $values += $line
        }
        else
        {
            for ($i = 0; $i -lt $splits.Length; $i++)
            {
                $start = if ($i -eq 0) { 0 } else { $splits[$i - 1] + 1 }
                $end = $splits[$i]
                $values += $line.Substring($start, $($end + 1) - $start)
            }
            $values += $line.Substring($end + 1, $line.Length - ($end + 1))
        }
        # 将键值对转换为自定义对象。
        $object = [PSCustomObject]@{ }
        for ($i = 0; $i -lt $names.Length; $i++)
        {
            if ($names[$i] -ne '')
            {
                $object | Add-Member $names[$i] $values[$i]
            }
            elseif (($i -gt 0) -and ($names[$i - 1] -ne ''))
            {
                $object.$($names[$i - 1]) = $object.$($names[$i - 1]) + $values[$i]
            }
        }
        # 去除首尾空格。
        foreach ($name in $object.PSObject.Properties.Name)
        {
            $object.$name = $object.$name.Trim()
        }
        # 返回转换得到的自定义对象。
        $object
    }
}
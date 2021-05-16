<#
.SYNOPSIS
提供以脚本文件为基础的 PowerShell 模块定义的模板。
#>

Get-ChildItem $PSScriptRoot '*.ps1' -File | ForEach-Object `
{
    $FunctionName = $_.BaseName
    $NewLine = [System.Environment]::NewLine
    $ScriptContent = Get-Content $_.FullName
    $RawScriptContent = $ScriptContent -join $NewLine
    $SynopsisPattern = @('<#', '\.SYNOPSIS', '(.|', ')*', '#>') -join $NewLine
    $SynopsisRegex = [regex]::new($SynopsisPattern, 'IgnoreCase, Multiline')
    $Synopsis = $SynopsisRegex.Match($RawScriptContent).Value
    $ScriptAst = [scriptblock]::Create($RawScriptContent).Ast
    $Usings = $ScriptAst.UsingStatements -join $NewLine
    $Attributes = $ScriptAst.ParamBlock.Attributes -join $NewLine
    $FunctionHead = @($Synopsis, '', $Usings) -join $NewLine
    $Parameters = @($Attributes, $ScriptAst.ParamBlock) -join $NewLine
    $FunctionBody = @('process', '{', "    & ""$($_.FullName)"" @args", '}') -join $NewLine
    $FunctionContent = @($FunctionHead, '', $Parameters, '', $FunctionBody) -join $NewLine
    Set-Item Function:\$FunctionName $FunctionContent
    $ScriptContent | Where-Object { $_ -imatch '^\[Alias\([''"].+[''"]\)\]$' } |
    ForEach-Object { Set-Alias $_.Substring(8, $_.Length - 11) $FunctionName }
}

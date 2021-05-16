<#
.SYNOPSIS
提供以脚本文件为基础的 PowerShell 模块定义的模板。
#>

Get-ChildItem $PSScriptRoot '*.ps1' -File | ForEach-Object `
{
    $Content = Get-Content $_.FullName
    $NewLine = [System.Environment]::NewLine
    $RawContent = $Content -join $NewLine
    $SynopsisPattern = @('<#', '\.SYNOPSIS', '(.|', ')*', '#>') -join $NewLine
    $SynopsisRegex = [regex]::new($SynopsisPattern, 'IgnoreCase, Multiline')
    $Synopsis = $SynopsisRegex.Match($RawContent).Value
    $ScriptAst = [scriptblock]::Create($RawContent).Ast
    $UsingContent = $ScriptAst.UsingStatements -join $NewLine
    $FunctionHead = @($Synopsis, '', $UsingContent) -join $NewLine
    $AttrsContent = $ScriptAst.ParamBlock.Attributes -join $NewLine
    $FunctionParam = @($AttrsContent, $ScriptAst.ParamBlock) -join $NewLine
    $FunctionBody = @('process', '{', "    & ""$($_.FullName)"" @args", '}') -join $NewLine
    $FunctionContent = @($FunctionHead, '', $FunctionParam, '', $FunctionBody) -join $NewLine
    $FunctionName = $_.BaseName
    Set-Item Function:\$FunctionName $FunctionContent
    $Content | Where-Object { $_ -imatch '^\[Alias\([''"].+[''"]\)\]$' } |
    ForEach-Object { Set-Alias $_.Substring(8, $_.Length - 11) $FunctionName }
}

#.SYNOPSIS
# 提供以脚本文件为基础的 PowerShell 模块定义的模板。

Get-ChildItem $PSScriptRoot '*.ps1' -File | ForEach-Object `
{
    $NewLine = [System.Environment]::NewLine
    $ScriptContent = $(Get-Content $_.FullName)
    $RawScriptContent = $ScriptContent -join $NewLine
    $HelpForward = ".FORWARDHELPTARGETNAME $($_.FullName)"
    $CommentHelp = @('<#', $HelpForward, '#>') -join $NewLine
    $ScriptAst = [scriptblock]::Create($RawScriptContent).Ast
    $UsingStatements = $ScriptAst.UsingStatements -join $NewLine
    $FunctionHead = @($CommentHelp, '', $UsingStatements) -join $NewLine
    $Attributes = $ScriptAst.ParamBlock.Attributes -join $NewLine
    $ParamBlock = @($Attributes, $ScriptAst.ParamBlock) -join $NewLine
    $EscapedPath = $_.FullName.Replace("'", "''")
    $CallStatement = "& '$EscapedPath' @PSBoundParameters"
    $ProcessBlock = @('process', '{', "    $CallStatement", '}') -join $NewLine
    $FunctionBody = @($ParamBlock, '', $ProcessBlock) -join $NewLine
    $FunctionContent = @($FunctionHead, '', $FunctionBody) -join $NewLine
    $FunctionName = $_.BaseName
    Set-Item Function:\$FunctionName $FunctionContent
    $ScriptAst.ParamBlock.Attributes |
    Where-Object { [string]$_.TypeName -ieq 'Alias' } |
    ForEach-Object { $_.PositionalArguments.Value } |
    ForEach-Object { Set-Alias $_ $FunctionName }
}

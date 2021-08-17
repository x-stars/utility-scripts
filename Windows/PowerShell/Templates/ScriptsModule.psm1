#.SYNOPSIS
# 定义以 PowerShell 脚本文件组成的 PowerShell 模块。

Get-ChildItem $PSScriptRoot '*.ps1' -File | ForEach-Object `
{
    $FunctionName = $_.BaseName
    $FunctionPath = $(Join-Path Function: $FunctionName)
    $ScriptContent = $(Get-Content -LiteralPath $_.FullName -Raw)
    $HelpForward = ".FORWARDHELPTARGETNAME $($_.FullName)"
    $CommentHelp = @('<#', $HelpForward, '#>')
    $ScriptAst = [scriptblock]::Create($ScriptContent).Ast
    $UsingStatements = [string[]]$ScriptAst.UsingStatements
    $FunctionHead = $CommentHelp + @('') + $UsingStatements
    $Attributes = [string[]]$ScriptAst.ParamBlock.Attributes
    $ParamBlock = $Attributes + [string[]]$ScriptAst.ParamBlock
    $EscapedPath = $_.FullName.Replace("'", "''")
    $CallStatement = "& '$EscapedPath' @PSBoundParameters @args"
    $ProcessBlock = @('process', '{', "    $CallStatement", '}')
    $FunctionBody = $ParamBlock + @('') + $ProcessBlock
    $FunctionContent = $FunctionHead + @('') + $FunctionBody
    $FunctionContent = $($FunctionContent | Out-String)
    Set-Content -LiteralPath $FunctionPath $FunctionContent
    $ScriptAst.ParamBlock.Attributes |
    Where-Object { [string]$_.TypeName -ieq 'Alias' } |
    ForEach-Object { $_.PositionalArguments.Value } |
    ForEach-Object { Set-Alias $_ $FunctionName }
}

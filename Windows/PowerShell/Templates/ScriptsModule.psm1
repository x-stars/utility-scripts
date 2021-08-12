#.SYNOPSIS
# 提供以脚本文件为基础的 PowerShell 模块定义的模板。

Get-ChildItem $PSScriptRoot '*.ps1' -File | ForEach-Object `
{
    $FunctionName = $_.BaseName
    $ScriptContent = $(Get-Content $_.FullName -Raw)
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
    Set-Content Function:\$FunctionName $FunctionContent
    $ScriptAst.ParamBlock.Attributes |
    Where-Object { [string]$_.TypeName -ieq 'Alias' } |
    ForEach-Object { $_.PositionalArguments.Value } |
    ForEach-Object { Set-Alias $_ $FunctionName }
}

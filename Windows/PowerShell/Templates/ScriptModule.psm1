#.SYNOPSIS
# 定义以脚本组成的 PowerShell 模块。

Get-ChildItem $PSScriptRoot *.ps1 -File | ForEach-Object `
{
    $FunctionName, $ScriptPath = $_.BaseName, $_.FullName
    $FunctionPath = Join-Path Function: $FunctionName
    $HelpForward = ".FORWARDHELPTARGETNAME $ScriptPath"
    $HelpCategory = ".FORWARDHELPCATEGORY ExternalScript"
    $CommentHelp = @('<#', $HelpForward, $HelpCategory, '#>')
    $ScriptContent = Get-Content -LiteralPath $ScriptPath -Raw
    $ScriptAst = [scriptblock]::Create($ScriptContent).Ast
    $UsingStatements = [string[]]$ScriptAst.UsingStatements
    $Attributes = [string[]]$ScriptAst.ParamBlock.Attributes
    $ParamBlock = $Attributes + [string]$ScriptAst.ParamBlock
    if ($UsingStatements -and $ParamBlock) { $UsingStatements += @('') }
    $FunctionHead = $UsingStatements + $ParamBlock
    if ($FunctionHead) { $FunctionHead = @('') + $FunctionHead + @('') }
    $QuotedScriptPath = "'$($ScriptPath.Replace("'", "''"))'"
    $ScriptDefine = '    $Script = ' + $QuotedScriptPath
    $CommandDefine = '    $Command = { & $Script @PSBoundParameters @args }'
    $PipelineDefine = '    $Pipeline = $Command.GetSteppablePipeline()'
    $DefineStatements = @($ScriptDefine, $CommandDefine, $PipelineDefine)
    $InputDefine = '    $CmdInput = if ($PSCmdlet) { $PSCmdlet } else { $true }'
    $BeginCallStatement = '    $Pipeline.Begin($CmdInput)'
    $BeginStatements = $DefineStatements + $InputDefine + $BeginCallStatement
    $BeginBlock = @('begin', '{') + $BeginStatements + @('}')
    $ProcessBlock = @('process', '{', '    $Pipeline.Process($_)', '}')
    $EndBlock = @('end', '{', '    $Pipeline.End()', '}')
    $FunctionBody = $BeginBlock + @('') + $ProcessBlock + @('') + $EndBlock
    $FunctionContent = $CommentHelp + $FunctionHead + $FunctionBody
    Set-Content -LiteralPath $FunctionPath ($FunctionContent | Out-String)
    $ScriptAst.ParamBlock.Attributes |
    Where-Object { [string]$_.TypeName -ieq 'Alias' } |
    ForEach-Object { $_.PositionalArguments.Value } |
    ForEach-Object { Set-Alias $_ $FunctionName }
}

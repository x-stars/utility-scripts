<#
.SYNOPSIS
恢复 Visual Studio Code 的原始指针样式，保持资源文件的完整性。
#>

[CmdletBinding()]
[OutputType([void])]
[System.Diagnostics.CodeAnalysis.SuppressMessage(
    'PSUseApprovedVerbs', '', Scope='Function', Target='Combine-Path')]
param
(
)

# 定义支持多个参数的路径拼接方法。
function Combine-Path
{
    [System.IO.Path]::Combine([string[]]$args)
}

# 定义恢复指定源码文件的方法。
function Restore-VSCodeSource([string]$Path)
{
    $BackupPath = "$Path.org"
    if (Test-Path $BackupPath)
    {
        Remove-Item $Path
        Move-Item $BackupPath $Path
    }
}

# 初始化 Visual Studio Code 相关路径。
$CodeBinPath = $(Split-Path $(Get-Command code).Source -Parent)
$VSCodeHome = $(Get-Item $(Join-Path $CodeBinPath ..)).FullName
$VSAppResDir = Combine-Path resources app out vs
$SandBoxResDir = Combine-Path code electron-sandbox

# 初始化主要工作台的 CSS 文件的路径。
$MainCssName = Combine-Path workbench workbench.desktop.main.css
$MainCssPath = Combine-Path $VSCodeHome $VSAppResDir $MainCssName
# 恢复主要工作台的 CSS 文件。
Restore-VSCodeSource $MainCssPath

# 初始化主要工作台的 JS 文件的路径。
$MainJsName = Combine-Path workbench workbench.desktop.main.js
$MainJsPath = Combine-Path $VSCodeHome $VSAppResDir $MainJsName
# 恢复主要工作台的 JS 文件。
Restore-VSCodeSource $MainJsPath

# 初始化报告问题窗口的 CSS 文件的路径。
$ReportCssName = Combine-Path $SandBoxResDir issue issueReporterMain.css
$ReportCssPath = Combine-Path $VSCodeHome $VSAppResDir $ReportCssName
# 恢复报告问题窗口的 CSS 文件。
Restore-VSCodeSource $ReportCssPath

# 初始化进程查看窗口的 CSS 文件的路径。
$ProcessCssName = Combine-Path $SandBoxResDir processExplorer processExplorerMain.css
$ProcessCssPath = Combine-Path $VSCodeHome $VSAppResDir $ProcessCssName
# 恢复进程查看窗口的 CSS 文件。
Restore-VSCodeSource $ProcessCssPath

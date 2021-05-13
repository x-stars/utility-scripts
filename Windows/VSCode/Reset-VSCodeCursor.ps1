<#
.SYNOPSIS
恢复 Visual Studio Code 的原始指针样式，保持资源文件的完整性。
#>

# 定义支持多个参数的路径拼接方法。
function Combine-Path { [System.IO.Path]::Combine([string[]]$args) }

# 初始化 Visual Studio Code 相关路径。
$CodeBinPath = $(Split-Path $(Get-Command code).Source -Parent)
$VSCodeHome = $(Get-Item $(Join-Path $CodeBinPath ..)).FullName
$VSAppResDir = Combine-Path resources app out vs
$SandBoxResDir = Combine-Path code electron-sandbox

# 初始化主要工作台的 CSS 文件的路径。
$MainCssName = Combine-Path workbench workbench.desktop.main.css
$MainCssPath = Combine-Path $VSCodeHome $VSAppResDir $MainCssName
$MainCssBackupPath = "$MainCssPath.org"
# 恢复主要工作台的 CSS 文件。
if (Test-Path $MainCssBackupPath)
{
    Remove-Item $MainCssPath
    Move-Item $MainCssBackupPath $MainCssPath
}

# 初始化报告问题窗口的 CSS 文件的路径。
$ReportCssName = Combine-Path $SandBoxResDir issue issueReporterMain.css
$ReportCssPath = Combine-Path $VSCodeHome $VSAppResDir $ReportCssName
$ReportCssBackupPath = "$ReportCssPath.org"
# 恢复报告问题窗口的 CSS 文件。
if (Test-Path $ReportCssBackupPath)
{
    Remove-Item $ReportCssPath
    Move-Item $ReportCssBackupPath $ReportCssPath
}

# 初始化进程查看窗口的 CSS 文件的路径。
$ProcessCssName = Combine-Path $SandBoxResDir processExplorer processExplorerMain.css
$ProcessCssPath = Combine-Path $VSCodeHome $VSAppResDir $ProcessCssName
$ProcessCssBackupPath = "$ProcessCssPath.org"
# 恢复进程查看窗口的 CSS 文件。
if (Test-Path $ProcessCssBackupPath)
{
    Remove-Item $ProcessCssPath
    Move-Item $ProcessCssBackupPath $ProcessCssPath
}

<#
.SYNOPSIS
设置 Visual Studio Code 的指针样式，使其符合原生应用的样式。
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

# 定义更新并备份指定源码文件的方法。
function Update-VSCodeSource([string]$Path, [string]$Content)
{
    $Encoding = [System.Text.UTF8Encoding]::new($false)
    $BackupPath = "$Path.org"
    if (-not $(Test-Path $BackupPath))
    {
        Move-Item $Path $BackupPath
    }
    [System.IO.File]::WriteAllText($Path, $Content, $Encoding)
}

# 初始化 Visual Studio Code 相关路径。
$CodeBinPath = $(Split-Path $(Get-Command code).Source -Parent)
$VSCodeHome = $(Get-Item $(Join-Path $CodeBinPath ..)).FullName
$VSAppResDir = Combine-Path resources app out vs
$SandBoxResDir = Combine-Path code electron-sandbox

# 初始化主要工作台的 CSS 文件的路径。
$MainCssName = Combine-Path workbench workbench.desktop.main.css
$MainCssPath = Combine-Path $VSCodeHome $VSAppResDir $MainCssName
# 修改并输出主要工作台的 CSS 文件。
$MainCssText = [System.IO.File]::ReadAllText($MainCssPath)
$MainCssText = $MainCssText.Replace('cursor:pointer', 'cursor:default').
    Replace('.title{cursor:grab}', '.title{cursor:default}').
    Replace('.pointer{cursor:default}', '.pointer{cursor:pointer}').
    Replace('.action-menu-item{height:1.8em}',
            '.action-menu-item{height:1.8em;cursor:default}').
    Replace('.detected-link-active{cursor:default}',
            '.detected-link-active{cursor:pointer}').
    Replace('.button-link:hover{background:transparent}',
            '.button-link:hover{background:transparent;cursor:pointer}').
    Replace('.codelens-decoration>a:hover{cursor:default}',
            '.codelens-decoration>a:hover{cursor:pointer}').
    Replace('.goto-definition-link{text-decoration:underline;cursor:default}',
            '.goto-definition-link{text-decoration:underline;cursor:pointer}').
    Replace('.button-link{padding:0;background:transparent;margin:2px;cursor:default;',
            '.button-link{padding:0;background:transparent;margin:2px;cursor:pointer;')
Update-VSCodeSource $MainCssPath $MainCssText

# 初始化主要工作台的 JS 文件的路径。
$MainJsName = Combine-Path workbench workbench.desktop.main.js
$MainJsPath = Combine-Path $VSCodeHome $VSAppResDir $MainJsName
# 修改并输出主要工作台的 JS 文件。
$MainJsText = [System.IO.File]::ReadAllText($MainJsPath)
$MainJsText = $MainJsText.
    Replace(".action-menu-item {`n`tflex: 1 1 auto;",
            ".action-menu-item {`n`tcursor:default;`n`tflex: 1 1 auto;")
Update-VSCodeSource $MainJsPath $MainJsText

# 初始化报告问题窗口的 CSS 文件的路径。
$ReportCssName = Combine-Path $SandBoxResDir issue issueReporterMain.css
$ReportCssPath = Combine-Path $VSCodeHome $VSAppResDir $ReportCssName
# 修改并输出报告问题窗口的 CSS 文件。
$ReportCssText = [System.IO.File]::ReadAllText($ReportCssPath)
$ReportCssText = $ReportCssText.Replace('cursor:pointer', 'cursor:default')
Update-VSCodeSource $ReportCssPath $ReportCssText

# 初始化进程查看窗口的 CSS 文件的路径。
$ProcessCssName = Combine-Path $SandBoxResDir processExplorer processExplorerMain.css
$ProcessCssPath = Combine-Path $VSCodeHome $VSAppResDir $ProcessCssName
# 修改并输出进程查看窗口的 CSS 文件。
$ProcessCssText = [System.IO.File]::ReadAllText($ProcessCssPath)
$ProcessCssText = $ProcessCssText.Replace('cursor:pointer', 'cursor:default')
Update-VSCodeSource $ProcessCssPath $ProcessCssText

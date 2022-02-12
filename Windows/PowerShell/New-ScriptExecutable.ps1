<#
.SYNOPSIS
    创建一个能运行输入的 PowerShell 脚本的可执行文件。
.DESCRIPTION
    创建一个能运行输入的 PowerShell 脚本的可执行文件。除脚本文件之外，还允许输入脚本文件所依赖的其他引用文件。
    输入的脚本文件和其他引用文件将会嵌入生成的可执行文件中，并在运行时输出为临时文件由 PowerShell 执行。
    当需要获取生成的可执行文件的路径时，应从环境变量 $env:PSEXEPATH 获取，$PSCommandPath 将指向临时文件。
    在调用引用文件时，应使用 $(Join-Path $PSScriptRoot '(ReferenceName)') 命令来获取引用文件的路径。
.PARAMETER Path
    可执行文件的路径。可带上参数名从管道接收值。
    默认为当前目录下与脚本文件同名的 *.exe 文件。
.PARAMETER Script
    脚本文件的路径。可从管道接收值。
.PARAMETER Win32Icon
    可执行文件使用的图标文件的路径。
.PARAMETER Reference
    脚本文件引用的其他文件的路径。
.PARAMETER NoExit
    指定创建的可执行文件在脚本文件执行完毕后不退出。
.PARAMETER NoProfile
    指定创建的可执行文件在运行时不加载 PowerShell 配置。
.PARAMETER NoWindow
    指定创建的可执行文件在运行时不显示 PowerShell 窗口。
.INPUTS
    System.String[]
    脚本文件的路径。
.OUTPUTS
    System.IO.FileInfo[]
    创建的可执行文件。
.NOTES
    需要在脚本目录下存在 PowerShellScriptWrapper.cs 文件。
    作者：天南十字星 https://github.com/x-stars
    参考来源：https://www.pstips.net/convert-ps1toexe.html
.EXAMPLE
    New-ScriptExecutable.ps1 GetSomething.exe -Script Get-Something.ps1
.EXAMPLE
    Get-Item *.ps1 | New-ScriptExecutable.ps1 -Reference $(Get-ChildItem SomeModule)
.LINK
    https://www.pstips.net/convert-ps1toexe.html
#>

[Alias('nse')]
[CmdletBinding()]
[OutputType([System.IO.FileInfo[]])]
param
(
    [Parameter(
        Position = 0,
        Mandatory = $false,
        ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript(
        { Test-Path -LiteralPath $_ -PathType Leaf -IsValid })]
    [string[]]$Path
    ,
    [Parameter(
        Mandatory = $true,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript(
        { Test-Path -LiteralPath $_ -PathType Leaf })]
    [string[]]$Script
    ,
    [Parameter(
        Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript(
        { Test-Path -LiteralPath $_ -PathType Leaf })]
    [string[]]$Reference
    ,
    [Parameter(
        Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript(
        { Test-Path -LiteralPath $_ -PathType Leaf })]
    [string]$Win32Icon
    ,
    [Parameter()]
    [switch]$NoExit
    ,
    [Parameter()]
    [switch]$NoProfile
    ,
    [Parameter()]
    [switch]$NoWindow
)

begin
{
    $compilerPattern = [System.IO.Path]::Combine(
        $env:SystemRoot, 'Microsoft.NET', '*', '*', 'csc.exe')
    $compilerPath = $(Get-Item -Path $compilerPattern)[-1].FullName

    $wrapperDefines = @('TRACE')
    if ($NoExit) { $wrapperDefines += 'NOEXIT' }
    if ($NoProfile) { $wrapperDefines += 'NOPROFILE' }
    if ($NoWindow) { $scriptWrapperCode += 'NOWINDOW' }
    if ($PSEdition -eq 'Core') { $wrapperDefines += 'PSCORE' }

    $wrapperCodeEncoding = [System.Text.Encoding]::UTF8
    $wrapperCodePath = Join-Path $PSScriptRoot 'PowerShellScriptWrapper.cs'
    Get-Item -LiteralPath $wrapperCodePath -Force -ErrorAction Stop > $null
    $win32IconFile = if ($Win32Icon) { Get-Item -LiteralPath $Win32Icon -Force }
    $referenceFiles = if ($Reference) { Get-Item -LiteralPath $Reference -Force }
}

process
{
    for ($index = 0; $index -lt $Script.Length; $index++)
    {
        $scriptFile = Get-Item -LiteralPath $Script[$index] -Force
        $executablePath = if ($Path -and $Path[$index])
            { $Path[$index] } else { "$($scriptFile.BaseName).exe" }
        $executableFile = if (Test-Path -LiteralPath $executablePath)
            { Get-Item -LiteralPath $executablePath -Force } else
            { New-Item -Path $executablePath -ItemType File
              Remove-Item -LiteralPath $executablePath }

        $compilerArgs = @('/nologo', '/optimize')
        $compilerArgs += '/target:exe'
        $compilerArgs += "/out:$($executableFile.FullName)"
        $compilerArgs += '/reference:System.dll'
        if ($win32IconFile)
        {
            $compilerArgs += "/win32icon:$($win32IconFile.FullName)"
        }
        $compilerArgs += "/resource:$($scriptFile.FullName)"
        Write-Verbose "  * $($scriptFile.Name)"
        foreach ($referenceFile in $referenceFiles)
        {
            $compilerArgs += "/resource:$($referenceFile.FullName)"
            Write-Verbose "    $($referenceFile.Name)"
        }
        $compilerArgs += "/define:$($wrapperDefines -join ',')"
        $compilerArgs += "/codepage:$($wrapperCodeEncoding.CodePage)"
        if ([System.Console]::OutputEncoding.WebName -eq 'utf-8')
        {
            $compilerArgs += '/utf8output'
        }

        $compilerArgs += $wrapperCodePath
        $compileResult = & $compilerPath @compilerArgs 2>&1
        $compileErrors = $compileResult |
            Where-Object { $_ -like '*error *: *'}
        if ($compileErrors)
        {
            $compileErrors | Write-Error -Category FromStdErr
        }
        else
        {
            Get-Item -LiteralPath $executablePath -Force
        }
    }
}

end
{
}

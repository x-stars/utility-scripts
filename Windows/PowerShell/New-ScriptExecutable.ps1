<#
.SYNOPSIS
创建一个能运行输入的 PowerShell 脚本的可执行文件。

.DESCRIPTION
创建一个能运行输入的 PowerShell 脚本的可执行文件。除脚本文件之外，还允许输入脚本文件所依赖的其他引用文件。
输入的脚本文件和其他引用文件将会嵌入生成的可执行文件中，并在运行时输出为临时文件由 PowerShell 执行。
在调用引用文件时，应使用 $(Join-Path $PSScriptRoot '(ReferenceName)') 命令来获取引用文件的路径。

.PARAMETER Path
可执行文件的路径。可带上参数名从管道接收值。
默认为当前目录下与脚本文件同名的 *.exe 文件。

.PARAMETER Script
脚本文件的路径。可从管道接收值。

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
作者：天南十字星 https://github.com/x-stars
原作者：Mooser Lee https://www.pstips.net/
参考来源：https://www.pstips.net/convert-ps1toexe.html

.EXAMPLE
New-ScriptExecutable.ps1 .\GetSomething.exe -Script .\Get-Something.ps1

.EXAMPLE
Get-ChildItem *.ps1 | New-ScriptExecutable.ps1

.EXAMPLE
Get-ChildItem *.ps1 | New-ScriptExecutable.ps1 -Reference $(Get-ChildItem .\SomeModule\*)

.LINK
https://www.pstips.net/convert-ps1toexe.html
#>

using namespace System
using namespace System.CodeDom.Compiler
using namespace System.Diagnostics
using namespace System.IO
using namespace System.Management.Automation
using namespace Microsoft.CSharp

[CmdletBinding()]
[Alias('nse')]
[OutputType([FileInfo[]])]
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
    # PowerShell 脚本宿主的 C# 源代码。
    $scriptHostCode = <#lang=csharp#>@'
using System;
using System.Diagnostics;
using System.IO;
using System.Reflection;

[assembly: CLSCompliant(true)]
[assembly: AssemblyCompany("XstarS")]
[assembly: AssemblyTitle("PowerShell Script Host")]
[assembly: AssemblyProduct("XstarS.PowerShell.ScriptHost")]
[assembly: AssemblyCopyright("Copyright © XstarS 2020")]
[assembly: AssemblyVersion("1.0.0.0")]
[assembly: AssemblyFileVersion("1.0.0.0")]
[assembly: AssemblyInformationalVersion("1.0.0")]

namespace XstarS.PowerShell.ScriptHost
{
    /// <summary>
    /// PowerShell 内嵌脚本宿主程序。
    /// </summary>
    public static class Program
    {
        /// <summary>
        /// PowerShell 内嵌脚本宿主程序入口点。
        /// </summary>
        /// <param name="args">程序启动参数。</param>
        public static void Main(string[] args)
        {
            // 设定临时文件的输出路径。
            var thisAsm = Assembly.GetExecutingAssembly();
            var tempDir = Path.Combine(Path.GetTempPath(),
                "PowerShellScriptHost." + thisAsm.GetName().Name);
            var resNames = thisAsm.GetManifestResourceNames();
            var tempFiles = new string[resNames.Length];
            for (int index = 0; index < resNames.Length; index++)
            {
                tempFiles[index] = Path.Combine(tempDir, resNames[index]);
            }

            // 获取临时脚本文件的路径，并将程序启动参数传递到此脚本文件。
            var scriptFile = "\"" + tempFiles[0] + "\"";
            var exeCmdLine = Environment.CommandLine;
            var exeFile = Environment.GetCommandLineArgs()[0];
            var exeLength = exeCmdLine.StartsWith("\"") ?
                exeFile.Length + 2 : exeFile.Length;
            var scriptCmdLine = scriptFile + exeCmdLine.Substring(exeLength);

            try
            {
                // 将内嵌资源文件输出到临时文件夹。
                if (!Directory.Exists(tempDir))
                {
                    Directory.CreateDirectory(tempDir);
                }
                for (int index = 0; index < resNames.Length; index++)
                {
                    using (var res = thisAsm.GetManifestResourceStream(resNames[index]))
                    {
                        using (var file = File.OpenWrite(tempFiles[index]))
                        {
                            res.CopyTo(file);
                        }
                    }
                    File.SetAttributes(tempFiles[index], FileAttributes.Temporary);
                }

                // 启动 PowerShell，执行临时脚本文件。
                var powershell =
                    Process.Start(new ProcessStartInfo()
                    {
                        FileName = "PowerShell.exe",
                        Arguments =
                            "-NoLogo " +
#if NOPROFILE
                            "-NoProfile " +
#endif
#if NOWINDOW
                            "-WindowStyle Hidden " +
#endif
                            "-ExecutionPolicy RemoteSigned " +
                            "-File " + scriptCmdLine,
                        UseShellExecute = false,
                    });
                powershell.WaitForExit();
                Environment.ExitCode = powershell.ExitCode;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
            finally
            {
                try
                {
                    // 删除临时文件。
                    foreach (var tempPath in tempFiles)
                    {
                        if (File.Exists(tempPath))
                        {
                            File.Delete(tempPath);
                        }
                    }
                    // 删除临时文件所在的文件夹。
                    if (Directory.Exists(tempDir) &&
                        Directory.GetFileSystemEntries(tempDir).Length == 0)
                    {
                        Directory.Delete(tempDir);
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex);
                }
                finally
                {
#if NOEXIT
                    Console.ReadKey();
#endif
                }
            }
        }
    }
}
'@
    # 定义编译器常量。
    $scriptHostDefines = @('TRACE')
    if ($NoExit) { $scriptHostDefines += 'NOEXIT' }
    if ($NoProfile) { $scriptHostDefines += 'NOPROFILE' }
    if ($NoWindow) { $scriptHostCode += 'NOWINDOW' }
    $scriptHostDefines = $($scriptHostDefines -join ',')

    # 获取引用文件。
    if ($Reference)
    {
        $referenceFiles = $(Get-Item -LiteralPath $Reference)
    }
}

process
{
    for ($index = 0; $index -lt $Script.Length; $index++)
    {
        # 根据路径获取脚本文件。
        $scriptFile = $(Get-Item -LiteralPath $Script[$index])
        # 设定创建可执行文件的路径。
        if ($Path -and $Path[$index])
        {
            $executableFile = [FileInfo]::new($Path[$index])
        }
        else
        {
            $executableFile = [FileInfo]::new(
                $(Join-Path $(Get-Location) "$($scriptFile.BaseName).exe"))
        }

        # 设定 C# 编译器的参数。
        $compilerParam = [CompilerParameters]::new()
        $compilerParam.GenerateExecutable = $true
        $compilerParam.CompilerOptions = "/optimize /define:$scriptHostDefines"
        # 设定编译器输出可执行文件的路径。
        $compilerParam.OutputAssembly = $executableFile.FullName
        Write-Verbose "$($executableFile.FullName)"
        # 将输入的脚本文件和引用文件嵌入到可执行文件。
        $compilerParam.EmbeddedResources.Add($scriptFile.FullName) > $null
        Write-Verbose "    $($scriptFile.Name) *"
        foreach ($referenceFile in $referenceFiles)
        {
            $compilerParam.EmbeddedResources.Add($referenceFile.FullName) > $null
            Write-Verbose "    $($referenceFile.Name)"
        }
        # 添加对 System 程序集的引用。
        $compilerParam.ReferencedAssemblies.Add([Process].Assembly.Location) > $null

        # 编译程序集，输出为可执行文件。
        $codeCompiler = [CSharpCodeProvider]::new()
        $compileResult = $codeCompiler.CompileAssemblyFromSource($compilerParam, $scriptHostCode)
        if ($compileResult.Errors.HasErrors)
        {
            # 输出编译器错误。
            Write-Warning "$($executableFile.FullName)"
            $compileResult.Errors | ForEach-Object {
                Write-Warning "$($_.ErrorNumber), [$($_.Line), $($_.Column)], $($_.ErrorText)" }
        }
        else
        {
            # 返回创建的可执行文件。
            $executableFile
        }
    }
}

end
{
}

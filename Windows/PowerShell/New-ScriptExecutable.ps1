<#
.SYNOPSIS
创建一个能运行输入的 PowerShell 脚本的可执行文件。

.DESCRIPTION
创建一个能运行输入的 PowerShell 脚本的可执行文件。除脚本文件之外，还允许输入脚本文件所依赖的其他引用文件。
输入的脚本文件和其他引用文件将会嵌入生成的可执行文件中，并在运行时输出为临时文件由 PowerShell 执行。
在调用引用文件时，应使用 $(Join-Path $PSScriptRoot '(ReferenceName)') 命令来获取引用文件的路径。

.PARAMETER Path
创建可执行文件的路径。可带上参数名从管道接收值。
默认为当前目录下与脚本文件同名的 *.exe 文件。

.PARAMETER Script
脚本文件的路径。可从管道接收值。

.PARAMETER Reference
脚本文件引用的其他文件的路径。

.PARAMETER NoExit
指定创建的可执行文件在脚本文件执行完毕后不退出。

.PARAMETER NoWindow
指定创建的可执行文件在运行时不显示 PowerShell 窗口。

.INPUTS
从管道接收的脚本文件或模块文件夹的路径。

.OUTPUTS
创建的能运行输入的 PowerShell 脚本的可执行文件。

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
            var tempDirPath = Path.Combine(Path.GetTempPath(),
                "PowerShellScriptHost." + thisAsm.GetName().Name);
            var resNames = thisAsm.GetManifestResourceNames();
            var tempPaths = new string[resNames.Length];
            for (int i = 0; i < resNames.Length; i++)
            {
                tempPaths[i] = Path.Combine(tempDirPath, resNames[i]);
            }

            // 获取临时脚本文件的路径，并将程序启动参数传递到此脚本文件。
            var scriptPath = "\"" + tempPaths[0] + "\"" + " ";
            var scriptArgs = string.Empty;
            foreach (var arg in args)
            {
                scriptArgs += !(arg.Contains(" ") || arg.Contains("\t")) ? arg :
                    !arg.Contains("\"") ? ("\"" + arg + "\"") : ("'" + arg + "'");
                scriptArgs += " ";
            }

            try
            {
                // 将内嵌资源文件输出到临时文件夹。
                if (!Directory.Exists(tempDirPath))
                {
                    Directory.CreateDirectory(tempDirPath);
                }
                for (int i = 0; i < resNames.Length; i++)
                {
                    using (var res = thisAsm.GetManifestResourceStream(resNames[i]))
                    {
                        using (var file = File.OpenWrite(tempPaths[i]))
                        {
                            res.CopyTo(file);
                        }
                        File.SetAttributes(tempPaths[i], FileAttributes.Temporary);
                    }
                }

                // 启动 PowerShell，执行临时脚本文件。
                var powershell = Process.Start(new ProcessStartInfo()
                {
                    FileName = "powershell.exe",
                    Arguments =
                        "-NoLogo " +
                        "-ExecutionPolicy Unrestricted " +
#if NOWINDOW
                        "-WindowStyle Hidden " +
#endif
                        "-File " + scriptPath + scriptArgs,
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
                    foreach (var tempPath in tempPaths)
                    {
                        if (File.Exists(tempPath))
                        {
                            File.Delete(tempPath);
                        }
                    }
                    // 删除临时文件所在的文件夹。
                    if (Directory.Exists(tempDirPath) &&
                        Directory.GetFileSystemEntries(tempDirPath).Length == 0)
                    {
                        Directory.Delete(tempDirPath);
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
    if ($NoExit)
    {
        $scriptHostCode = "#define NOEXIT$([Environment]::NewLine)$scriptHostCode"
    }
    if ($NoWindow)
    {
        $scriptHostCode = "#define NOWINDOW$([Environment]::NewLine)$scriptHostCode"
    }

    # 获取引用文件。
    if ($Reference)
    {
        $referenceFiles = $(Get-Item -LiteralPath $Reference)
    }
}

process
{
    for ($i = 0; $i -lt $Script.Length; $i++)
    {
        # 根据路径获取脚本文件。
        $scriptFile = $(Get-Item -LiteralPath $Script[$i])
        # 设定创建可执行文件的路径。
        if ($Path -and $Path[$i])
        {
            $executableFile = [FileInfo]::new($Path[$i])
        }
        else
        {
            $executableFile = [FileInfo]::new(
                $(Join-Path $(Get-Location) "$($scriptFile.BaseName).exe"))
        }

        # 设定 C# 编译器的参数。
        $compilerParam = [CompilerParameters]::new()
        $compilerParam.GenerateExecutable = $true
        $compilerParam.CompilerOptions = '/optimize '
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

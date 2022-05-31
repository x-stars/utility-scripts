using System;
using System.Diagnostics;
using System.IO;
using System.Reflection;

[assembly: CLSCompliant(true)]
[assembly: AssemblyCompany("XstarS")]
[assembly: AssemblyTitle("PowerShell Script Wrapper")]
[assembly: AssemblyProduct("PowerShell Script Wrapper")]
[assembly: AssemblyCopyright("Copyright © XstarS 2020")]
[assembly: AssemblyVersion("1.0.0.0")]
[assembly: AssemblyFileVersion("1.0.0.0")]
[assembly: AssemblyInformationalVersion("1.0.0")]

namespace XstarS.PowerShell.ScriptWrapper
{
    public static class Program
    {
        internal static void Main()
        {
            try
            {
                var cmdLine = Environment.CommandLine;
                var cmdFile = Environment.GetCommandLineArgs()[0];
                var cmdLength = cmdLine.StartsWith("\"") ?
                    cmdFile.Length + 2 : cmdFile.Length;
                var arguments = cmdLine.Substring(cmdLength);
                Environment.ExitCode = Program.Run(arguments);
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine(ex.ToString());
                Environment.ExitCode = (ushort)ex.HResult;
            }
#if NOEXIT
            Console.Write("Press any key to continue . . . ");
            Console.ReadKey();
#endif
        }

        public static int Run(string arguments)
        {
            var thisAsm = Assembly.GetExecutingAssembly();
            Environment.SetEnvironmentVariable("PSEXEPATH", thisAsm.Location);
            var tempDir = Path.Combine(Path.GetTempPath(),
                "PowerShellScriptWrapper." + thisAsm.GetName().Name +
                    "." + Process.GetCurrentProcess().Id.ToString());
            var tempFiles = Array.Empty<string>();
            try
            {
                tempFiles = Program.PrepareFiles(tempDir);
                var scriptFile = (tempFiles.Length == 0) ?
                    string.Empty : ("\"" + tempFiles[0] + "\"");
                var scriptArgs = arguments ?? string.Empty;
                return Program.ExecuteScript(scriptFile, scriptArgs);
            }
            finally
            {
                Program.CleanupFiles(tempDir, tempFiles);
            }
        }

        private static string[] PrepareFiles(string tempDir)
        {
            var thisAsm = Assembly.GetExecutingAssembly();
            var resNames = thisAsm.GetManifestResourceNames();
            var tempFiles = new string[resNames.Length];
            for (int index = 0; index < resNames.Length; index++)
            {
                tempFiles[index] = Path.Combine(tempDir, resNames[index]);
            }
            if (!Directory.Exists(tempDir))
            {
                Directory.CreateDirectory(tempDir);
            }
            for (int index = 0; index < resNames.Length; index++)
            {
                using (var res = thisAsm.GetManifestResourceStream(resNames[index]))
                using (var file = File.OpenWrite(tempFiles[index]))
                {
                    res.CopyTo(file);
                }
                File.SetAttributes(tempFiles[index], FileAttributes.Temporary);
            }
            return tempFiles;
        }

        private static int ExecuteScript(string scriptFile, string scriptArgs)
        {
            var executionMethod = "-File ";
            if (scriptArgs.TrimStart().StartsWith("-?"))
            {
                executionMethod = "-Command Get-Help ";
                scriptArgs = scriptArgs.TrimStart().Substring(2);
            }
            var scriptCmdLine = (scriptArgs.Length == 0) ?
                scriptFile : (scriptFile + " " + scriptArgs);
            var powershell = Process.Start(new ProcessStartInfo()
            {
#if PSCORE
                FileName = "pwsh.exe",
#else
                FileName = "PowerShell.exe",
#endif
                Arguments = "-NoLogo " +
#if NOPROFILE
                    "-NoProfile " +
#endif
#if NOWINDOW
                    "-WindowStyle Hidden " +
#endif
                    "-ExecutionPolicy RemoteSigned " +
                    executionMethod + scriptCmdLine,
                UseShellExecute = false,
            });
            powershell.WaitForExit();
            return powershell.ExitCode;
        }

        private static void CleanupFiles(string tempDir, string[] tempFiles)
        {
            foreach (var tempFile in tempFiles)
            {
                if (File.Exists(tempFile))
                {
                    File.Delete(tempFile);
                }
            }
            if (Directory.Exists(tempDir) &&
                Directory.GetFileSystemEntries(tempDir).Length == 0)
            {
                Directory.Delete(tempDir);
            }
        }
    }
}

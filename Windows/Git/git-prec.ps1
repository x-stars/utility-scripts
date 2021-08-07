# Invoke Git command recursively in parallel jobs.
$GitArguments = $args
$RootDirectory = $(Get-Location).Path
Get-ChildItem -Directory -Force -Recurse |
Where-Object Name -EQ .git | ForEach-Object `
{
    $RepositoryPath = $(Split-Path $_.FullName -Parent)
    Start-Job -ArgumentList @($RootDirectory, $RepositoryPath, $GitArguments) `
    {
        $RootDirectory, $RepositoryPath, $GitArguments = $args
        $DirectorySeparator = [System.IO.Path]::DirectorySeparatorChar
        $Repository = '.' + $RepositoryPath.Substring($RootDirectory.Length)
        $Repository = $Repository.Replace($DirectorySeparator, [char]'/')
        $Repository = $([regex]'^\./').Replace($Repository, '')
        Set-Location -LiteralPath $RepositoryPath
        $GitError = $($($GitOutput = $(git $GitArguments)) 2>&1)
        [PSCustomObject]@{
            Repository = $Repository; GitOutput = [string[]]$GitOutput
            GitError = [string[]]$GitError; ExitCode = $LASTEXITCODE
        }
    }
} |
Receive-Job -Wait -AutoRemoveJob | ForEach-Object `
{
    [System.Console]::ForegroundColor = 'Magenta'
    Write-Output "REPO: $($_.Repository)"
    [System.Console]::ResetColor()
    $_.GitOutput | ForEach-Object { Write-Output $_ }
    $_.GitError | ForEach-Object { Write-Warning $_ }
    $ExitMessage = 'exit with code {0}' -f $_.ExitCode
    if ($_.ExitCode) { Write-Warning $ExitMessage }
    Write-Output ''
}

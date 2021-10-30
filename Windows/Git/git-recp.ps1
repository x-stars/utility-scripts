#.SYNOPSIS
# Invoke Git command recursively in parallel jobs.

$InformationPreference = 'Continue'
$TotalErrors = 0; $GitArguments = $args
$RootDirectory = $(Get-Location).ProviderPath
Get-ChildItem . -Recurse '.git' -Directory -Force | ForEach-Object `
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
        $GitBranch = $(git branch | Where-Object { $_ -like '`* *' }).Substring(2)
        $GitError = $($($GitOutput = $(git $GitArguments)) 2>&1)
        [PSCustomObject]@{
            Repository = $Repository; Branch = $GitBranch; ExitCode = $LASTEXITCODE
            GitOutput = [string[]]$GitOutput; GitError = [string[]]$GitError
        }#[PSCustomObject]
    }
} |
Receive-Job -Wait -AutoRemoveJob | ForEach-Object `
{
    [System.Console]::ForegroundColor = 'Magenta'
    Write-Output "REPO: $($_.Repository) ($($_.Branch))"
    [System.Console]::ResetColor()
    foreach ($Line in $_.GitError) { Write-Information $Line }
    foreach ($Line in $_.GitOutput) { Write-Output $Line }
    $ExitMessage = 'exit with code {0}' -f $_.ExitCode
    if ($_.ExitCode -ne 0) { Write-Warning $ExitMessage }
    Write-Output ''
}
exit $TotalErrors

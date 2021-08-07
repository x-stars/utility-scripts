# Invoke Git command recursively in parallel jobs.
$GitArguments = $args
$RootDirectory = $(Get-Location).Path
Receive-Job -Wait -AutoRemoveJob `
@(
    Get-ChildItem .git -Directory -Force -Recurse | ForEach-Object `
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
            Write-Output ">>> $Repository <<<"
            git $GitArguments; Write-Output ''
        }
    }
)

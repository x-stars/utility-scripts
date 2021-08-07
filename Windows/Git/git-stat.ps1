# Get Git commit statistics grouped by authors.
git log --format=%aN | Sort-Object -Unique | ForEach-Object `
{
    $Add = 0; $Remove = 0
    git log --author=$_ --pretty=tformat: --numstat | ForEach-Object `
    {
        $ThisAdd = 0; $ThisRemove = 0
        [int]::TryParse($(-split $_)[0], $ThisAdd) > $null
        [int]::TryParse($(-split $_)[1], $ThisAdd) > $null
        $Add += $ThisAdd; $Remove += $ThisRemove
    }
    $Total= $Add - $Remove
    [PSCustomObject]@{
        Author = $_; Add = $Add; Remove = $Remove; Total = $Total
    }
}

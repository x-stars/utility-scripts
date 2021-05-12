# PowerShell 表达式

表达式 (Expression) 可以简单理解为有返回值的语句，不同于命令 (Command)，有值是其重要特征。

虽然与 C#、VB 一样同为命令式编程语言，PowerShell 却因其采用了管道 (Pipeline) 技术，
并没有使语句表现为命令（命令式编程），而是表现为表达式（函数式编程）。
若 PowerShell 中一个语句没有返回值，则其作为表达式的返回值为 `$null`。

## 表达式值的传递

在将语句视为命令的语言中，一个语句若存在返回值，却没有被任何变量接收，一般会直接丢弃这个值；
而在将语句视为表达式的语言中，一个语句若存在返回值，却没有被任何变量接收，则会逐层向外传递，直至有变量接收或作为函数返回值返回。

而在 PowerShell 中，任意一个表达式的值若没有赋给一个变量、输出到文件流或是传递给管道中的下一个命令，
也会开始逐层向外传递直至被接收；若在当前函数中没有被接收，则会作为函数的返回值输出到管道；
若此值在函数外最终也没有被接收，则会以特定格式会输出到终端。

与其他函数式编程语言不同的是，一般的函数式编程语言仅允许一个返回值，即函数中每个分支的最后一个表达式的值；
而 PowerShell 采用的管道技术，使得每一个没有被接收的表达式都会向外传递并作为函数的返回值，
实际表现类似于 C# 中的集合惰性求值返回语句 `yield return`。

``` PowerShell
# 值输出到终端。
Get-ChildItem . -File
# 值赋给变量。
$files = $(Get-ChildItem . -File)
# 值输出到文件流。
Get-ChildItem . -File > .\files.txt
# 值传递到管道的下一个命令。
Get-ChildItem . -File | Out-String
# 值传递到 if else 分支外层，并被命令的参数接收。
Get-ChildItem $(if ($Path) { $Path } else { . }) -File
# 多个值作为函数返回值传递至管道。
function Get-File
{
    Get-ChildItem \ -File
    Get-ChildItem . -File
}
# 值传递到 if else 分支外层，并作为函数返回值传递至管道。
function Get-File
{
    param ([string[]]$Path)

    if ($Path) { Get-ChildItem $Path -File }
    else { Get-ChildItem . -File }
}
```

## 表达式返回和 `return` 语句返回

PowerShell 虽然存在 `return` 语句可用于在函数中返回值，
但 `return` 语句也会立即终止函数的执行，这不利于向管道逐个传递值。
因此，在 PowerShell 中，函数向管道逐个返回值时，应使用表达式传递，而非 `return` 语句。

``` PowerShell
# 应该使用表达式逐个返回值至管道。
foreach ($thisPath in $Path)
{
    $files = $(Get-ChildItem $thisPath -File)
    $files
}
# 不应该执行完所有操作再使用 return 语句返回所有值至管道。
$allFiles = @()
foreach ($thisPath in $Path)
{
    $files = $(Get-ChildItem $thisPath -File)
    $allFiles += $files
}
return $allFiles
```

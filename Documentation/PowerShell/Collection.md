# PowerShell 集合类型

PowerShell 基于 .NET 框架，因此 .NET 中所有集合类型都可用于 PowerShell。
但 PowerShell 因其动态语言的特点和管道技术，存在两种特殊地位的集合类型——数组和哈希表。

## 数组 `System.Object[]`

数组是 PowerShell 中管道的基础，支持管道传递的参数和任何函数的返回值都应声明为数组类型。

> 实际上，当函数没有返回任何值时，返回值为 `$null`；仅返回一个值时，返回值为此值本身；多个返回值时才会返回数组。

### 数组创建表达式

``` PowerShell
@($item1, $item2, ...)
# 或更简洁的版本（但无法创建空数组）。
$item1, $item2, ...
# 或带有类型声明。
[int[]]@(1, 2, 3, ...)
```

> 当创建的数组中没有元素时，此数组实际为 `$null`；否则在没有类型声明时均为 `System.Object[]` 类型。

### 数组的动态扩展

数组支持 `+` 和 `+=` 操作符，可动态扩展数组的大小。

## 哈希表 `System.Collections.Hashtable`

哈希表是 PowerShell 中动态对象的基础，动态对象 `System.Management.Automation.PSObject` 一般由哈希表创建。

### 哈希表创建表达式

``` PowerShell
@{ Name1 = $value1; Name2 = $value2; ... }
```

### 转换到 `PSObject` 动态对象

``` PowerShell
[PSCustomObject]@{ Name1 = $value1; Name2 = $value2; ... }
```

### 使用哈希表进行参数包装

在向 PowerShell 命令传递参数时，可使用将所有参数包装为一个 `Hashtable` 对象：

``` PowerShell
$parameters = @{ Path = '.'; Recurse = $true; File = $true }
```

而后使用参数展开运算符 `@` 将其传递到命令：

``` PowerShell
Get-ChildItem @parameter
```

等价于：

``` PowerShell
Get-ChildItem -Path . -Recurse -File
```

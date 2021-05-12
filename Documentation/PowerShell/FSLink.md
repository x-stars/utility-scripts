# PowerShell 创建文件系统链接

## 调用 CMD

``` PowerShell
cmd.exe /C MKLINK (|-D|-H|-J) Link Target
```

> 无参数：文件符号链接；-D：目录符号链接；-H：文件硬链接；-J：目录联接。

## `New-Item` 命令

> 仅可用于 PowerShell 5.0 以上版本。

``` PowerShell
New-Item -Path Link -Value Target -ItemType (SymbolicLink|HardLink|Junction)
```

> SymbolicLink：符号链接；HardLink：文件硬链接；Junction：目录联接。

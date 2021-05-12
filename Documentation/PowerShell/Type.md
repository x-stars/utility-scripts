# PowerShell 类型

PowerShell 基于 .NET 框架，其类型系统显然也基于 .NET 框架，并可使用 .NET 框架中的绝大部分类型。

## 类型系统

PowerShell 的类型系统的为动态强类型系统，类型以一对中括号 `[]` 包括类型名进行引用。

PowerShell 允许类型标注，但不执行静态类型检查。其类型标注同时也是强制类型转换运算符。
PowerShell 为了 Shell 的易用性，预定义了大量 .NET 中并没有的强制类型转换。

## 命名空间

PowerShell 中默认引入 `System` 和 `System.Management.Automation` 两个命名空间。

在 PowerShell 5.0 前，PowerShell 不允许用户自行引入命名空间。
但从 5.0 版本开始，用户可使用 `using namespace` 语句自行引入命名空间。

## 预定义类型

预定义类型可在不引入其命名空间的情况下直接引用。

PowerShell 中的预定义类型的**不完全**统计见下表：

| PowerShell 预定义类型 | .NET 类型                                      |
| --------------------- | ---------------------------------------------- |
| `bool`                | `System.Boolean`                               |
| `sbyte`               | `System.SByte`                                 |
| `byte`                | `System.Byte`                                  |
| `int16`               | `System.Int16`                                 |
| `uint16`              | `System.UInt16`                                |
| `int`                 | `System.Int32`                                 |
| `uint`                | `System.UInt32`                                |
| `long`                | `System.Int64`                                 |
| `ulong`               | `System.UInt64`                                |
| `float`               | `System.Single`                                |
| `double`              | `System.Double`                                |
| `string`              | `System.String`                                |
| `void`                | `System.Void`                                  |
| `decimal`             | `System.Decimal`                               |
| `datetime`            | `System.DateTime`                              |
| `array`               | `System.Array`                                 |
| `hashtable`           | `System.Collections.Hashtable`                 |
| `psobject`            | `System.Management.Automation.PSObject`        |
| `switch`              | `System.Management.Automation.SwitchParameter` |
| `powershell`          | `System.Management.Automation.PowerShell`      |

## 用户自定义类型

在 PowerShell 5.0 前，PowerShell 不允许用户自定义类型。
但从 5.0 版本开始，用户可使用 `class` 关键字自行定义类型。

`class` 关键字定义的类型的特性包括：

* 使用与类型同名的方法定义构造函数。
* 使用 `static` 关键字定义静态字段和方法。
* 使用 `hidden` 关键字定义私有字段和方法。
* 使用 `$this` 预定义变量引用当前实例。
* 使用 `:` 运算符进行类型继承和接口声明。

# PowerShell 动态类型 `PSObject`

## `PSObject` 对象的创建

### `PSCustomObject` 运算符转换 `Hashtable`

``` PowerShell
$object = [PSCustomObject]@{ Name = 'Name'; Value = 'Value' }
```

### `New-Object` 命令从 `Hashtable` 创建

``` PowerShell
$object = $(New-Object psobject -Property @{ Name = 'Name'; Value = 'Value' })
```

### 使用 JSON 作为中继从 `Hashtable` 转换

``` PowerShell
$object = $(@{ Name = 'Name'; Value = 'Value' } | ConvertFrom-Json | ConvertTo-Json)
```

## 任意对象对应的 `PSObject` 元数据对象

``` PowerShell
$object = $item.PSObject
```

## `PSObject` 对象属性的遍历

``` PowerShell
foreach ($property in $item.PSObject.Properties)
{
    $propertyName = $property.Name
    $propertyValue = $property.Value
}
# 或者：
foreach ($propertyName in $item.PSObject.Properties.Name)
{
    $propertyValue = $item.$propertyName
}
```

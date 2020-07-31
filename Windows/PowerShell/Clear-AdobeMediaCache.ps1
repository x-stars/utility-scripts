<#
.SYNOPSIS
清空 Adobe 创意套件产生的媒体缓存。
#>

using namespace System
using namespace System.Management.Automation

[CmdletBinding()]
[OutputType([void])]
param
(
)

$AdobeCommonPath = "$env:APPDATA\Adobe\Common"
Get-ChildItem "$AdobeCommonPath\Media Cache" -Recurse |
Remove-Item -Verbose
Get-ChildItem "$AdobeCommonPath\Media Cache Files" -Recurse |
Remove-Item -Verbose

# OZORegistryKeyValue Class
This class is part of the [OZORegistry PowerShell Module](../README.md). Calling the `Get-OZORegistryKey` function returns an object of this class.

## Associations
```
+ $Name:String = $null
+ $Type:String = $null
```
---
```
<<Dynamic>>
+ $Data:Byte[]
+ $Data:Int32
+ $Data:String
+ $Data:String[]
+ $Data:Int64
```
## Operations
```
+ OZORegistryKeyValue($Value:String,$Data:Byte[]):Void
+ OZORegistryKeyValue($Value:String,$Data:Int32):Void
+ OZORegistryKeyValue($Value:String,$Data:String):Void
+ OZORegistryKeyValue($Value:String,$Data:String[]):Void
+ OZORegistryKeyValue($Value:String,$Data:Int64[]):Void
```

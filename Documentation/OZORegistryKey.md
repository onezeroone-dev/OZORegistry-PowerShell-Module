# OZORegistryKey Class
This class is part of the [OZORegistry PowerShell Module](../README.md). Calling the `Get-OZORegistryKey` function returns an object of this class.

## Associations
```
+ $keyExists:Boolean     = $true
+ $keyValid:Boolean      = $true
+ $valuesRead:Boolean    = $true
+ $keyPath:String        = $null
+ $Key:PSCustomObject    = $null
+ $Logger:PSCustomObject = $null
+ $Values:System.Collections.Generic.List[PSCustomObject] = @()
```
## Operations
```
+ OZORegistryKey($KeyPath:String):Void
- ValidateKeyPath($KeyPath:String):Boolean
- ReadKey():Boolean
- ReadKeyValues():Boolean
+ DisplayKeyValues():Void
+ ReturnKeyValueData($Name:String):Object
+ ReturnKeyValueType($Name:String):String
+ AddKeyValue($Value:String,$Data):Void
+ RemoveKeyValue($Value:String):Void
+ UpdateKeyValue($Value:String,$Data):Void
+ ProcessChanges():Boolean
```

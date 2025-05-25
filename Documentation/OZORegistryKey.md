# OZORegistryKey Class
This class is part of the [OZORegistry PowerShell Module](../README.md). Calling the `Get-OZORegistryKey` function returns an object of this class.

## Associations
```
+ $keyExists:Boolean  = $true
+ $keyValid:Boolean   = $true
+ $valuesRead:Boolean = $true
+ $keyPath:String     = $null
+ $Key:PSCustomObject = $null
+ $Values:System.Collections.Generic.List[PSCustomObject] = @()
```
## Operations
```
+ OZORegistryKey($KeyPath:String):Void
- ValidateKeyPath($KeyPath:String):Boolean
- ReadKey():Boolean
- ReadKeyValues():Boolean
+ AddValue($Value:String,$Data):Void
+ RemoveValue($Value:String):Void
+ UpdateValue($Value:String,$Data):Void
+ ProcessChanges():Boolean
```

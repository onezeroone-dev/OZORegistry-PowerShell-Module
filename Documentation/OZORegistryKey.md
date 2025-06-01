# OZORegistryKey Class
This class is part of the [OZORegistry PowerShell Module](../README.md).

## Usage
Return an object of this class with the [`Get-OZORegistryKey`](Get-OZORegistryKey.md) function.

## Public Methods

|Method|Inputs|Return Type|Description|
|------|-----------|-----------|
|SetDisplay|`Boolean`|Void|Determines whether or not console messages are displayed in a user-interactive session. Requires `$true` or `$false` and sets the `$Display` boolean accordingly.|
|DisplayKeyValues|None|Void|Displays the contents of the `$Values` array that represents `$Key`. Only displays when `$Display` is `$true`. Use `SetDisplay()` to set `$Display`.|
|ReturnKeyValueData|`String`|Returns the 


## Definition
### Associations
```
+ $Display:Boolean       = $false
+ $keyExists:Boolean     = $true
+ $keyValid:Boolean      = $true
+ $valuesRead:Boolean    = $true
+ $keyPath:String        = $null
+ $Key:PSCustomObject    = $null
+ $Logger:PSCustomObject = $null
+ $Values:System.Collections.Generic.List[PSCustomObject] = @()
```
### Operations
```
+ OZORegistryKey($KeyPath:String,$Display:Boolean):Void
- ValidateKeyPath($KeyPath:String):Boolean
- ReadKey():Boolean
- ReadKeyValues():Boolean
+ SetDisplay($DisplayBool:Boolean):Void
+ DisplayKeyValues():Void
+ ReturnKeyValueData($Name:String):Object
+ ReturnKeyValueType($Name:String):String
+ AddKeyValue($Value:String,$Data):Void
+ RemoveKeyValue($Value:String):Void
+ UpdateKeyValue($Value:String,$Data):Void
+ ProcessChanges():Boolean
```

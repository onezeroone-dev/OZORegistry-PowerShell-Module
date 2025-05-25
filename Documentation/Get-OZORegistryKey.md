# Get-OZORegistryKey
This function is part of the [OZORegistry PowerShell Module](../README.md).

## Description
Returns an OZORegistryKey object. When `Key` is provided, an object representing a registry key is returned. When `Value` is provided, an object representing a specific registry key value is returned. The key and/or value may or may not exist.

## Syntax
```
Convert-OZORegistryKey
    -Key     <String>
    [-Value] <String>
```

## Parameters
|Parameter|Description|
|---------|-----------|
|`Key`|The registry key.|
|`Value`|The registry value.|

## Examples
### Example 1
Create an object that represents a registry key:
```powershell
$ozoRegistryKey = (Get-OZORegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\One Zero One")
```
### Example 2
```powershell

```

## Notes
For more information, please see the [`OZORegistryKey`](OZORegistryKey.md) and [`OZORegistryKeyValue`](OZORegistryKeyValue.md) class definitions.
# Write-OZORegistryKeyValueData
This function is part of the [OZORegistry PowerShell Module](../README.md).

## Description
A simple function for adding or updating a single registry key value.

## Syntax
```
Write-OZORegistryKeyValueData
    -Key   <String>
    -Value <String>
    -Data  <Byte[] | Int32 | Int64 | String | String[]>
    -Type  <String>
```

## Parameters
|Parameter|Description|
|---------|-----------|
|`Key`|The registry key.|
|`Value`|The key value.|
|`Data`|The value data.|
|`Type`|The data type. Valid types are `Binary`, `Dword`, `ExpandString`, `MultString`, `None`, `Qword`, `String`, and `Unknown`. Defaults to `String`.|

## Examples
```powershell
Write-OZORegistryKeyValueData
```

## Notes
Requires Administrator privileges.

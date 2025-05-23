# Write-OZORegistryKeyValueData
This function is part of the [OZORegistry PowerShell Module](../README.md).

## Description


## Syntax
```
Write-OZORegistryKeyValueData
    -Key   <String>
    -Value <String>
    -Data
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
Requires Administrator privileges. This function expectes registry keys in the _HKEY_LOCAL_MACHINE\\..._ format. If your path is in the _HKLM:\\..._ format, reformat it with [`Convert-OZORegistryPath`](Convert-OZORegistryPath.md).

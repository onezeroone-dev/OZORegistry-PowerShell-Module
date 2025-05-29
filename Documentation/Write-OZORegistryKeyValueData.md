# Write-OZORegistryKeyValueData
This function is part of the [OZORegistry PowerShell Module](../README.md).

## Description
A simple function for adding or updating a single registry key value. If the key value does not exist, it will be created. If it does exist, it will be updated. Returns True on success and False on failure. Failures are typically due to inadequate permissions or data type mismatches.

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
|`Type`|The data type. Valid types are `Binary`, `Dword`, `ExpandString`, `MultString`, `Qword`, and `String`. Defaults to `String`.|

## Examples
```powershell
Write-OZORegistryKeyValueData -Key "HKEY_LOCAL_MACHINE\SOFTWARE\One Zero One" -Value "Acronym" -Data "OZO" -Type "String"
True
```

## Notes
Requires Administrator privileges.

## Logging
Messages as written to the Windows Event Viewer [_One Zero One_](https://github.com/onezeroone-dev/OZOLogger-PowerShell-Module/blob/main/README.md) provider when available. Otherwise, messages are written to the _Microsoft-Windows-PowerShell_ provider under event ID 4100.

# Write-OZORegistryKeyNameValue
This function is part of the [OZORegistry PowerShell Module](../README.md).

## Description
A simple function for adding or updating a single registry key name. If the key + name does not exist, it will be created. If it does exist, it will be updated. Returns True on success and False on failure. Failures are typically due to inadequate permissions or type mismatches.

## Syntax
```
Write-OZORegistryKeyNameValue
    -Key   <String>
    -Name  <String>
    -Value <Byte[] | Int32 | Int64 | String | String[]>
    -Type  <String>
```

## Parameters
|Parameter|Description|
|---------|-----------|
|`Key`|The registry key.|
|`Name`|The key name.|
|`Value`|The name value.|
|`Type`|The type. Valid types are `Binary`, `Dword`, `ExpandString`, `MultString`, `Qword`, and `String`. Defaults to `String`.|

## Examples
```powershell
Write-OZORegistryKeyNameValue -Key "HKEY_LOCAL_MACHINE\SOFTWARE\One Zero One" -Value "Acronym" -Data "OZO" -Type "String"
True
```

## Logging
Messages as written to the Windows Event Viewer [_One Zero One_](https://github.com/onezeroone-dev/OZOLogger-PowerShell-Module/blob/main/README.md) provider when available. Otherwise, messages are written to the _Microsoft-Windows-PowerShell_ provider under event ID 4100.

## Notes
Requires _Administrator_ privileges.

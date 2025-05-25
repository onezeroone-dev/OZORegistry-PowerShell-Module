# Read-OZORegistryKeyValueType
This function is part of the [OZORegistry PowerShell Module](../README.md).

## Description
Returns the type for an existing key value. Returns "Invalid path" if the path is not valid, "Not found" if the path does not exist, and "Could not read values" if the key values could not be read.

## Syntax
```
Read-OZORegistryKeyValueType
    -Key   <String>
    -Value <String>
```

## Parameters
|Parameter|Description|
|---------|-----------|
|`Key`|The registry key.|
|`Value`|The key value.|

## Examples
```powershell
Read-OZORegistryKeyValueType -Key "Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion" -Value "ProgramFilesDir"
String
```

## Notes
This function expectes registry keys in the _HKEY_LOCAL_MACHINE\\..._ format. If your path is in the _HKLM:\\..._ format, reformat it with [`Convert-OZORegistryPath`](Convert-OZORegistryPath.md).

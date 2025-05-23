# Read-OZORegistryKeyValueData
This function is part of the [OZORegistry PowerShell Module](../README.md).

## Description
Returns a registry key value data. Returns "Invalid path" if the path is not valid and "Not found" if the path does not exist. 

## Syntax
```
Read-OZORegistryKeyValueData
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
Read-OZORegistryKeyValueData -Key "Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion" -Value "ProgramFilesDir"
C:\Program Files
```

## Notes
This function expectes registry keys in the _HKEY_LOCAL_MACHINE\\..._ format. If your path is in the _HKLM:\\..._ format, reformat it with [`Convert-OZORegistryPath`](Convert-OZORegistryPath.md).

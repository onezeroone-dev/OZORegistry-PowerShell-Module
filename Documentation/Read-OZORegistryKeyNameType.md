# Read-OZORegistryKeyValueType
This function is part of the [OZORegistry PowerShell Module](../README.md).

## Description
A simple function for returning the data _type_ from a single registry key value. Returns "Invalid path" if the path is not valid, "Not found" if the path does not exist, and "Could not read values" if the key values could not be read.

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
### Example 1
```powershell
Read-OZORegistryKeyValueType -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion" -Value "ProgramFilesDir"
String
```
### Example 2
```powershell
Read-OZORegistryKeyValueType -Key "HLKM:\SOFTWARE\Microsoft\Windows\CurrentVersion" -Value "ProgramFilesDir"
String
```

## Logging
Messages as written to the Windows Event Viewer [_One Zero One_](https://github.com/onezeroone-dev/OZOLogger-PowerShell-Module/blob/main/README.md) provider when available. Otherwise, messages are written to the _Microsoft-Windows-PowerShell_ provider under event ID 4100.

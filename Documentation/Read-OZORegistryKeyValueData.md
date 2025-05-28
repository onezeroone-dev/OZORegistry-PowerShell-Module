# Read-OZORegistryKeyValueData
This function is part of the [OZORegistry PowerShell Module](../README.md).

## Description
A simple function for returning the data from a single registry key value. Returns "Invalid path" if the path is not valid, "Not found" if the path does not exist, "Could not read values" if the key values could not be read, and "Unhandled data type" if the data cannot be returned.

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
### Example 1
```powershell
Read-OZORegistryKeyValueData -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion" -Value "ProgramFilesDir"
C:\Program Files
```
### Example 2
```powershell
Read-OZORegistryKeyValueData -Key "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion" -Value "ProgramFilesDir"
C:\Program Files
```

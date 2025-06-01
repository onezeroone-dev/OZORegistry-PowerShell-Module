# Read-OZORegistryKeyNameValue
This function is part of the [OZORegistry PowerShell Module](../README.md).

## Description
A simple function for returning the value for a single registry key name. Returns "Key path is not valid" if the path is not valid, "Key not found" if the path does not exist, "Could not read key names" if the key names could not be read, and "Unhandled data type" if the data cannot be returned.

## Syntax
```
Read-OZORegistryKeyNameValue
    -Key  <String>
    -Name <String>
```

## Parameters
|Parameter|Description|
|---------|-----------|
|`Key`|The registry key.|
|`Name`|The key name.|

## Examples
### Example 1
```powershell
Read-OZORegistryKeyNameValue -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion" -Name "ProgramFilesDir"
C:\Program Files
```
### Example 2
```powershell
Read-OZORegistryKeyNameValue -Key "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion" -Name "ProgramFilesDir"
C:\Program Files
```

## Outputs
`Byte[]` | `Int32` | `Int64` | `String` | `String[]`

## Logging
Messages as written to the Windows Event Viewer [_One Zero One_](https://github.com/onezeroone-dev/OZOLogger-PowerShell-Module/blob/main/README.md) provider when available. Otherwise, messages are written to the _Microsoft-Windows-PowerShell_ provider under event ID 4100.

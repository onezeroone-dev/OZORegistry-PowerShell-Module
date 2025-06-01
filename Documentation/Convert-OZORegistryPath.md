# Convert-OZORegistryPath
This function is part of the [OZORegistry PowerShell Module](../README.md).

## Description
Converts a registry string from one format to another, e.g., _HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion_ to _HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion_. If the input string is invalid, it is returned unmodified.

## Syntax
```
Convert-OZORegistryPath
    -RegistryPath <String>
```

## Parameters
|Parameter|Description|
|---------|-----------|
|`RegistryPath`|The registry string to convert. Accepts pipeline input.|

## Examples
### Example 1
```powershell
Convert-OZORegistryPath -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion"
HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion
```
### Example 2
```powershell
Convert-OZORegistryPath -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion"
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion
```
### Example 3
```powershell
"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion" | Convert-OZORegistryPath
HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion
```

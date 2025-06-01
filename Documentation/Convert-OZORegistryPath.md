# Convert-OZORegistryPath
This function is part of the [OZORegistry PowerShell Module](../README.md).

## Description
Converts a registry string from one format to another, e.g., _HKCU:\SOFTWARE\Google\Chrome_ to _HKEY_CURRENT_USER\SOFTWARE\Google\Chrome_. If the input string is invalid, it is returned unmodified.

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
Convert-OZORegistryPath -Path "HKEY_CURRENT_USER\SOFTWARE\Google\Chrome"
HKCU:\SOFTWARE\Google\Chrome
```
### Example 2
```powershell
Convert-OZORegistryPath -Path "HKCU:\SOFTWARE\Google\Chrome"
HKEY_CURRENT_USER\SOFTWARE\Google\Chrome
```
### Example 3
```powershell
"HKEY_CURRENT_USER\SOFTWARE\Google\Chrome" | Convert-OZORegistryPath
HKCU:\SOFTWARE\Google\Chrome
```

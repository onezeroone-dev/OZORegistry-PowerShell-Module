# Get-OZORegistryKey
This function is part of the [OZORegistry PowerShell Module](../README.md).

## Description
Returns an `OZORegistryKey` object that represents a registry key (whether existing or not). The object contains methods for reading, adding, updating, and removing key values; and a method for processing (writing) the changes to the registry. This function (and resulting object) is the most robust and flexible use of this module.

## Syntax
```
Convert-OZORegistryKey
    -Key     <String>
    [-Value] <String>
```

## Parameters
|Parameter|Description|
|---------|-----------|
|`Key`|The registry key.|
|`Value`|The registry value.|

## Examples
### Example 1 - Read a registry key value data and type
```powershell
$ozoRegistryKey = (Get-OZORegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion")
Using key path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion.
Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion exists and all values read.

Name                     Type         Data
----                     ----         ----
ProgramFilesDir          String       C:\Program Files
CommonFilesDir           String       C:\Program Files\Common Files
ProgramFilesDir (x86)    String       C:\Program Files (x86)
CommonFilesDir (x86)     String       C:\Program Files (x86)\Common Files
CommonW6432Dir           String       C:\Program Files\Common Files
DevicePath               ExpandString %SystemRoot%\inf
MediaPathUnexpanded      ExpandString %SystemRoot%\Media
ProgramFilesPath         ExpandString %ProgramFiles%
ProgramW6432Dir          String       C:\Program Files

$ozoRegistryKey.ReturnKeyValueData("ProgramFilesDir")
C:\Program Files
$ozoRegistryKey.ReturnKeyValueType("ProgramFilesDir")
String
```


### Example 2
```powershell

```

## Notes
For more information, please see the [`OZORegistryKey`](OZORegistryKey.md) and [`OZORegistryKeyValue`](OZORegistryKeyValue.md) class definitions.
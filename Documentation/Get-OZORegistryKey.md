# Get-OZORegistryKey
This function is part of the [OZORegistry PowerShell Module](../README.md).

## Description
Returns an `OZORegistryKey` object that represents a registry key (whether existing or not). The object contains methods for reading, adding, updating, and removing key values; and a method for processing (writing) the changes to the registry. This function (and resulting object) is the most robust and flexible use of this module.

## Syntax
```
Get-OZORegistryKey
    -Key     <String>
    -Display <Switch>
```

## Parameters
|Parameter|Description|
|---------|-----------|
|`Key`|The registry key.|
|`Display`|Display console messages (effective only for user-interactive sessions).|

## Examples
### Example 1
Return an object representing a registry key **with** console messages.
```powershell
$ozoRegistryKey = (Get-OZORegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion" -Display)
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
```

### Example 2
Return an object representing a registry key **without** console messages.
```powershell
$ozoRegistryKey = (Get-OZORegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion")
```

### Example 3
Return an object representing a registry key **without** console messages, and set the _Display_ property to enable console messages. _Note: For clarity and brevity, the remaining examples will omit console messages._
```powershell
$ozoRegistryKey = (Get-OZORegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion")
$ozoRegistryKey.DisplayKeyValues()
$ozoRegistryKey.Display = $true
$ozoRegistryKey.DisplayKeyValues()

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
```

### Example 3
Get the data and the type for the _ProgramFilesDir_ value.
```powershell
$ozoRegistryKey = (Get-OZORegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion")
$ozoRegistryKey.ReturnKeyValueData("ProgramFilesDir")
C:\Program Files
$ozoRegistryKey.ReturnKeyValueType("ProgramFilesDIr")
String
```

## Logging
Messages as written to the Windows Event Viewer [_One Zero One_](https://github.com/onezeroone-dev/OZOLogger-PowerShell-Module/blob/main/README.md) provider when available. Otherwise, messages are written to the _Microsoft-Windows-PowerShell_ provider under event ID 4100.

## Notes
For more information, please see the [`OZORegistryKey`](OZORegistryKey.md) and [`OZORegistryKeyValue`](OZORegistryKeyValue.md) class definitions.

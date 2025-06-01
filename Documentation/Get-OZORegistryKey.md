# Get-OZORegistryKey
This function is part of the [OZORegistry PowerShell Module](../README.md).

## Description
Returns an `OZORegistryKey` object. This object may represent a new or existing registry key. The object contains methods for [reading, adding, updating, and removing](OZORegistryKey.md#public-methods) key names; and methods for [displaying](OZORegistryKey.md#public-methods) the key and--once all desired changes have been staged--for [processing](OZORegistryKey.md#public-methods) the changes to the key. This function (and resulting object) provide the most robust and flexible use of this module.

## Syntax
```
Get-OZORegistryKey
    -Key     <String>
    -Display <Switch>
```

## Parameters
|Parameter|Description|
|---------|-----------|
|`Key`|The registry key in the short (`HKLM:\...`) or long (`HKEY_LOCAL_MACHINE\...`) format. Key may be new or existing.|
|`Display`|Display console messages (effective only for user-interactive sessions).|

## Examples
### Example 1
Return an object representing a registry key **with** console messages.
```powershell
$ozoRegistryKey = (Get-OZORegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion" -Display)
Using key path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion.
Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion exists and all values read.

Name                     Type         Value
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
$ozoRegistryKey.SetDisplay($true)
$ozoRegistryKey.DisplayKeyValues()

Name                     Type         Value
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
Get the value and the type for the _ProgramFilesDir_ name.
```powershell
$ozoRegistryKey = (Get-OZORegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion")
$ozoRegistryKey.ReturnKeyNameValue("ProgramFilesDir")
C:\Program Files
$ozoRegistryKey.ReturnKeyNameType("ProgramFilesDIr")
String
```

### Example 4
Get add a new name to an existing registry key.
```powershell
$ozoRegistryKey = (Get-OZORegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\One Zero One")
If (($ozoRegistryKey.AddKeyName("Version","1.0.0")) -eq $true) {
    $ozoRegistryKey.ProcessChanges()
}
```

### Example 5
Update an existing registry key name with a new value.
```powershell
$ozoRegistryKey = (Get-OZORegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\One Zero One")
If (($ozoRegistryKey.UpdateKeyName("Version","2.0.0")) -eq $true) {
    $ozoRegistryKey.ProcessChanges()
}
```

### Example 6
Remove an existing name from a registry key
```powershell
$ozoRegistryKey = (Get-OZORegistryKey -Key "HKEY_LOCAL_MACHINE\SOFTWARE\One Zero One")
If (($ozoRegistryKey.UpdateName("Version")) -eq $true) {
    $ozoRegistryKey.ProcessChanges()
}
```

## Logging
Messages as written to the Windows Event Viewer [_One Zero One_](https://github.com/onezeroone-dev/OZOLogger-PowerShell-Module/blob/main/README.md) provider when available. Otherwise, messages are written to the _Microsoft-Windows-PowerShell_ provider under event ID 4100.

## Notes
For more information, please see the [`OZORegistryKey`](OZORegistryKey.md) and [`OZORegistryKeyValue`](OZORegistryKeyValue.md) class definitions.

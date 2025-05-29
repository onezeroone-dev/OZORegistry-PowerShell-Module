# OZORegistry PowerShell Module Installation, Usage, and Guidance
This module provides functions and classes for interacting with the Microsoft Windows Registry.

- [The Registry](#the-registry)
- [Installation](#installation)
- [Usage](#usage)
- [Logging](#logging)
- [License](#license)
- [Acknowledgements](#acknowledgements)

## The Registry
<img src="OZORegistryKey.png" alt="The Registry Editor showing the One Zero One key." width="600">

### Definitions

|Term|Definition|
|----|----------|
|Hive|The registry is composed of several _hives_ that each contain a hierarchy of keys. The image above shows the `HKEY_LOCAL_MACHINE` _hive_.|
|Key|Each hive contains a hierarchy of _keys_ that may contain other keys, and may contain zero or more values. The image above shows the `One Zero One` _key_ in the `SOFTWARE` _key_ in the `HKEY_LOCAL_MACHINE` hive.|
|Value|Each key contains zero or more unique _values_. The image above shows the `(default)` and `Acronym` _values_ in the `One Zero One` key.|
|Data|Each values may be empty but will usually contain _data_. The image above shows `OZO` _data_ in the `Acronym` value.|
|Type|Each value has a data _type_. Valid registry data types are `Binary`, `Dword`, `ExpandString`, `MultiString`, `Qword`, and `String`. The image above shows the `REG_SZ` _type_ (String) for the `Acronym` value.|

### Types in the Registry vs. PowerShell
Each registry key _value_ has a _data type_. This table details the relationship between registry _data types_ and PowerShell _data types_ to help you align the data you are reading or writing in PowerShell with the corresponding registry data.

|Registry Type|Registry Display|PowerShell Type|Description|
|-------------|----------------|---------------|-----------|
|Binary|REG_BINARY|Byte[]|Byte array|
|Dword|REG_DWORD|Int32|32-bit unsigned integer|
|ExpandString|REG_EXPAND_SZ|String|String that will be expanded when retrieved|
|MultString|REG_MULTI_SZ|String[]|String array|
|Qword|REG_QWORD|Int64|64-bit unsigned integer|
|String|REG_SZ|String|A regular string|

### Paths
Registry paths are generally expressed using one of two common formats, e.g., for `HKEY_LOCAL_MACHINE`:

- `HKEY_LOCAL_MACHINE\SOFTWARE\One Zero One`
- `HKLM:\SOFTWARE\One Zero One`

Either format is acceptable for all functions in this module.

## Installation
This module is published to [PowerShell Gallery](https://learn.microsoft.com/en-us/powershell/scripting/gallery/overview?view=powershell-5.1). Ensure your system is configured for this repository then execute the following in an _Administrator_ PowerShell:

```powershell
Install-Module OZORegistry
```

## Usage
### Importing
Import this module in your script or console to make the functions available for use:

```powershell
Import-Module OZORegistry
```

### Simple Functions
- [Convert-OZORegistryPath](Documentation/Convert-OZORegistryPath.md) converts a registry string from one format to another.
- [Read-OZORegistryKeyValueData](Documentation/Read-OZORegistryKeyValueData.md) is a simple function for returning the data from a single registry key value.
- [Read-OZORegistryKeyValueType](Documentation/Read-OZORegistryKeyValueType.md) is a simple function for returning the data _type_ from a single registry key value.
- [Write-OZORegistryKeyValueData](Documentation/Write-OZORegistryKeyValueData.md) is a simple function for adding or updating a single registry key value.

### Advanced Functions
- [Get-OZORegistryKey](Documentation/Get-OZORegistryKey.md) returns an `OZORegistryKey` object that represents a registry key (whether existing or not). The resulting object contains methods for reading, adding, updating, and removing key values; and a method for processing (writing) the changes to the registry. This function (and resulting object) is the most robust and flexible use of this module.

### Classes
- [OZORegistryKey](Documentation/OZORegistryKey.md)
- [OZORegistryKeyValue](Documentation/OZORegistryKeyValue.md)

## Logging
Messages as written to the Windows Event Viewer [_One Zero One_](https://github.com/onezeroone-dev/OZOLogger-PowerShell-Module/blob/main/README.md) provider when available. Otherwise, messages are written to the _Microsoft-Windows-PowerShell_ provider under event ID 4100.

## License
This module is licensed under the [GNU General Public License (GPL) version 2.0](LICENSE).

## Acknowledgements
Special thanks to my employer, [Sonic Healthcare USA](https://sonichealthcareusa.com), who supports the growth of my PowerShell skillset and enables me to contribute portions of my work product to the PowerShell community.

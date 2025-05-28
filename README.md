# OZORegistry PowerShell Module Installation and Usage

## Installation
This module is published to [PowerShell Gallery](https://learn.microsoft.com/en-us/powershell/scripting/gallery/overview?view=powershell-5.1). Ensure your system is configured for this repository then execute the following in an _Administrator_ PowerShell:

```powershell
Install-Module OZORegistry
```

## Usage
Import this module in your script or console to make the functions available for use:

```powershell
Import-Module OZORegistry
```

## Functions

|Function|Description|
|--------|-----------|
|[Convert-OZORegistryPath](Documentation/Convert-OZORegistryPath.md)||
|[Get-OZORegistryKey](Documentation/Get-OZORegistryKey.md)|Returns an `OZORegistryKey` object that represents a registry key (whether existing or not). The object contains methods for reading, adding, updating, and removing key values; and a method for processing (writing) the changes to the registry. This function (and resulting object) is the most robust and flexible use of this module.|
|[Read-OZORegistryKeyValueData](Documentation/Read-OZORegistryKeyValueData.md)|A simple function for returning the data from a single registry key value.|
|[Read-OZORegistryKeyValueType](Documentation/Read-OZORegistryKeyValueType.md)|A simple function for returning the data _type_ from a single registry key value.|
|[Write-OZORegistryKeyValueData](Documentation/Write-OZORegistryKeyValueData.md)|A simple function for adding or updating a single registry key value.|

## Classes
- [OZORegistryKey](Documentation/OZORegistryKey.md)
- [OZORegistryKeyValue](Documentation/OZORegistryKeyValue.md)

## Acknowledgements
Special thanks to my employer, [Sonic Healthcare USA](https://sonichealthcareusa.com), who supports the growth of my PowerShell skillset and enables me to contribute portions of my work product to the PowerShell community.

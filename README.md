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
- [Convert-OZORegistryPath](Documentation/Convert-OZORegistryPath.md)
- [Read-OZORegistryKeyValueData](Documentation/Read-OZORegistryKeyValueData.md)
- [Read-OZORegistryKeyValueType](Documentation/Read-OZORegistryKeyValueType.md)
- [Write-OZORegistryKeyValueData](Documentation/Write-OZORegistryKeyValueData.md)

## Classes
- [RegistryItem](Documentation/RegistryItem.md)

## Acknowledgements
Special thanks to my employer, [Sonic Healthcare USA](https://sonichealthcareusa.com), who supports the growth of my PowerShell skillset and enables me to contribute portions of my work product to the PowerShell community.

Function Convert-OZORegistryString {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Converts a registry string from one format to another, e.g., "HKCU:\SOFTWARE\Google\Chrome" to "HKEY_CURRENT_USER\SOFTWARE\Google\Chrome". If the input string is invalid, it is returned unmodified.
        .PARAMETER RegistryPath
        The registry string to convert. Accepts pipeline input.
        .EXAMPLE
        Convert-OZORegistryString -Path "HKEY_CURRENT_USER\SOFTWARE\Google\Chrome"
        HKCU:\SOFTWARE\Google\Chrome
        .EXAMPLE
        Convert-OZORegistryString -Path "HKCU:\SOFTWARE\Google\Chrome"
        HKEY_CURRENT_USER\SOFTWARE\Google\Chrome
        .LINK
        https://github.com/onezeroone-dev/OZORegistry-PowerShell-Module/blob/main/Documentation/Convert-OZORegistryString.md
    #>
    # Parameters
    [CmdletBinding()] Param (
        [Parameter(Mandatory=$true,HelpMessage="The registry path to convert")][String]$RegistryPath
    )
    # Switch on RegistryPath
    Switch($RegistryPath) {
        {$_ -Like "HKCR:\*"              } { return $RegistryPath.Replace("HKCR:","HKEY_CLASSES_ROOT")   }
        {$_ -Like "HKCU:\*"              } { return $RegistryPath.Replace("HKCU:","HKEY_CURRENT_USER")   }
        {$_ -Like "HKLM:\*"              } { return $RegistryPath.Replace("HKLM:","HKEY_LOCAL_MACHINE")  }
        {$_ -Like "HKU:\*"               } { return $RegistryPath.Replace("HKU:" ,"HKEY_USERS")          }
        {$_ -Like "HKCC:\*"              } { return $RegistryPath.Replace("HKCC:","HKEY_CURRENT_CONFIG") }
        {$_ -Like "HKEY_CLASSES_ROOT\*"  } { return $RegistryPath.Replace("HKEY_CLASSES_ROOT","HKCR:")   }
        {$_ -Like "HKEY_CURRENT_USER\*"  } { return $RegistryPath.Replace("HKEY_CURRENT_USER","HKCU:")   }
        {$_ -Like "HKEY_LOCAL_MACHINE\*" } { return $RegistryPath.Replace("HKEY_LOCAL_MACHINE","HKLM:")  }
        {$_ -Like "HKEY_USERS\*"         } { return $RegistryPath.Replace("HKEY_USERS","HKU:")           }
        {$_ -Like "HKEY_CURRENT_CONFIG\*"} { return $RegistryPath.Replace("HKEY_CURRENT_CONFIG","HKCC:") }
    }
}

Function Read-OZORegistryValue {
    <#
        .SYNOPSIS
        .DESCRIPTION
        .PARAMETER
        .EXAMPLE
        .LINK
        https://github.com/onezeroone-dev/OZORegistry-PowerShell-Module/blob/main/Documentation/Read-OZORegistryValue.md
    #>
}

Function Read-OZORegistryValueType {
    <#
        .SYNOPSIS
        .DESCRIPTION
        .PARAMETER
        .EXAMPLE
        .LINK
        https://github.com/onezeroone-dev/OZORegistry-PowerShell-Module/blob/main/Documentation/Read-OZORegistryValueType.md
    #>
}

Function Write-OZORegistryValue {
    <#
        .SYNOPSIS
        .DESCRIPTION
        .PARAMETER
        .EXAMPLE
        .LINK
        https://github.com/onezeroone-dev/OZORegistry-PowerShell-Module/blob/main/Documentation/Write-OZORegistryValue.md
    #>
}

Export-ModuleMember -Function Convert-OZORegistryString,Read-OZORegistryValue,Read-OZORegistryValueType,Write-OZORegistryValue
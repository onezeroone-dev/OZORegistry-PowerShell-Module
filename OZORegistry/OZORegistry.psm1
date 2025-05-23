# CLASSES
Class RegistryItem {
    # PROPERTIES: Booleans, Strings
    [Boolean] $Exists = $true
    [String]  $Key    = $null
    [String]  $Value  = $null
    [String]  $Type   = $null
    # METHODS: Constructor method
    RegistryKeyValueData($Key,$Value) {

    }
}

# FUNCTIONS
Function Convert-OZORegistryPath {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Converts a registry string from one format to another, e.g., "HKCU:\SOFTWARE\Google\Chrome" to "HKEY_CURRENT_USER\SOFTWARE\Google\Chrome". If the input string is invalid, it is returned unmodified.
        .PARAMETER RegistryPath
        The registry string to convert. Accepts pipeline input.
        .EXAMPLE
        Convert-OZORegistryPath -Path "HKEY_CURRENT_USER\SOFTWARE\Google\Chrome"
        HKCU:\SOFTWARE\Google\Chrome
        .EXAMPLE
        Convert-OZORegistryPath -Path "HKCU:\SOFTWARE\Google\Chrome"
        HKEY_CURRENT_USER\SOFTWARE\Google\Chrome
        .LINK
        https://github.com/onezeroone-dev/OZORegistry-PowerShell-Module/blob/main/Documentation/Convert-OZORegistryPath.md
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
        default                            { return $RegistryPath                                        }
    }
}

Function Read-OZORegistryKeyValueData {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns a registry key value data. Returns "Invalid path" if the path is not valid and "Not found" if the path does not exist. 
        .PARAMETER Key
        The registry key.
        .PARAMETER Value
        The key value.
        .EXAMPLE
        Read-OZORegistryKeyValueData -Key "Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion" -Value "ProgramFilesDir"
        C:\Program Files
        .LINK
        https://github.com/onezeroone-dev/OZORegistry-PowerShell-Module/blob/main/Documentation/Read-OZORegistryKeyValueData.md
        .NOTES
        This function expectes registry keys in the "HKEY_LOCAL_MACHINE\..." format. If your path is in the "HKLM:\..." format, reformat it with Convert-OZORegistryPath.
    #>
    # Parameters
    [CmdletBinding()] Param (
        [Parameter(Mandatory=$true,HelpMessage="The registry key")][String]$Key,
        [Parameter(Mandatory=$true,HelpMessage="The key value")][String]$Value
    )
    # Attempt to get the data
    $data = [Microsoft.Win32.Registry]::GetValue($Key,$Value,"Not found")
    # Determine if the data is null
    If ($null -eq $data) {
        # Data is null
        $data = "Invalid path"
    }
    # Return the data
    return $data
}

Function Read-OZORegistryKeyValueType {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns the data type for a registry key value. Returns "Invalid path" if the path is not valid.
        .PARAMETER Key
        The registry key.
        .PARAMETER Value
        The key value.
        .EXAMPLE
        Read-OZORegistryKeyValueType -Key "Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion" -Value "ProgramFilesDir"
        String
        .LINK
        https://github.com/onezeroone-dev/OZORegistry-PowerShell-Module/blob/main/Documentation/Read-OZORegistryKeyValueType.md
        .NOTES
        This function expectes registry keys in the "HKEY_LOCAL_MACHINE\..." format. If your path is in the "HKLM:\..." format, reformat it with Convert-OZORegistryPath.
    #>
    # Parameters
    [CmdletBinding()] Param (
        [Parameter(Mandatory=$true,HelpMessage="The registry key")][String]$Key,
        [Parameter(Mandatory=$true,HelpMessage="The key value")][String]$Value
    )
    # Try to get the value type
    Try {
        $type = (Get-Item -Path ("Microsoft.PowerShell.Core\Registry::" + $Key) -ErrorAction Stop).GetValueKind($Value)
    } Catch {
        $type = "Invalid path"
    }
    # Return the type
    return $type
}

Function Write-OZORegistryKeyValueData {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Writes data to a registry key value. If the key value does not exist, it will be created. If it does exist, it will be updated. Returns True on success and False on failure.
        .PARAMETER Key
        The registry key.
        .PARAMETER Value
        The key value.
        .PARAMETER Data
        The value data.
        .PARAMETER Type
        The data type. Valid types are "Binary", "Dword", "ExpandString", "MultString", "None", "Qword", "String", and "Unknown". Defaults to "String".
        .EXAMPLE
        Write-OZORegistryKeyValueData -Key "HKEY_LOCAL_MACHINE\SOFTWARE\One Zero One" -Value "Acronym" -Data "OZO" -Type "String"
        .LINK
        https://github.com/onezeroone-dev/OZORegistry-PowerShell-Module/blob/main/Documentation/Write-OZORegistryKeyValueData.md
        .NOTES
        Requires Administrator privileges. This function expectes registry keys in the "HKEY_LOCAL_MACHINE\..." format. If your path is in the "HKLM:\..." format, reformat it with Convert-OZORegistryPath.
    #>
    # Parameters
    [CmdletBinding()] Param (
        [Parameter(Mandatory=$true,HelpMessage="The registry key")][String]$Key,
        [Parameter(Mandatory=$true,HelpMessage="The key value")][String]$Value,
        [Parameter(Mandatory=$true,HelpMessage="The value data")][String]$Data,
        [Parameter(Mandatory=$false,HelpMessage="The data type")][ValidateSet("Binary","Dword","ExpandString","MultString","None","Qword","String","Unknown")][String]$Type = "String"
    )
    # Determine if the operator is an administrator
    If (Test-OZOLocalAdministrator -eq $true) {
        # Operator is an Administrator; try to set the registry key value
        Try {
            [Microsoft.Win32.Registry]::SetValue($Key,$Value,$Data,[Microsoft.Win32.RegistryValueKind]::$Type)
            # Success
            return $true
        } Catch {
            # Failure
            Write-OZOProvider -Message ("Error writing registry value data. Error message is: " + $_) -Level "Error"
            return $false
        }
    } Else {
        # Operator is not an Administrator
        Write-OZOProvider -Message "The Write-OZORegistryValue function requires Administrator privileges." -Level "Error"
        return $false
    }
}

Export-ModuleMember -Function Convert-OZORegistryString,Read-OZORegistryKeyValueData,Read-OZORegistryKeyValueType,Write-OZORegistryKeyValueData